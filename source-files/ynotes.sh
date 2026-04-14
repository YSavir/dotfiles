YNOTES_DIR="$HOME/Documents/notes"
YNOTES_CSV="$YNOTES_DIR/.notes_index.csv"

_ynotes_ensureDir() {
  [ -d "$YNOTES_DIR" ] || mkdir -p "$YNOTES_DIR"
  [ -f "$YNOTES_CSV" ] || echo "name,created,is_todo,deadline,filepath" > "$YNOTES_CSV"
}

_ynotes_epochForDate() {
  date -j -f "%Y-%m-%d" "$1" +%s 2>/dev/null
}

_ynotes_updateCsv() {
  local target_name="$1"
  local new_todo="$2"
  local new_deadline="$3"
  local tmpfile
  tmpfile=$(mktemp)

  head -1 "$YNOTES_CSV" > "$tmpfile"
  tail -n +2 "$YNOTES_CSV" | while IFS=',' read -r name created is_todo deadline filepath; do
    if [ "$name" = "$target_name" ]; then
      [ -n "$new_todo" ] && is_todo="$new_todo"
      [ -n "$new_deadline" ] && deadline="$new_deadline"
    fi
    echo "$name,$created,$is_todo,$deadline,$filepath" >> "$tmpfile"
  done
  mv "$tmpfile" "$YNOTES_CSV"
}

_ynotes_help() {
  cat <<'HELP'
Usage: ynotes <command> [options]

Commands:
  edit  <name> [--todo] [--deadline YYYY-MM-DD]   Open or create a note
        For existing notes, --todo and --deadline update the index
  list  [--urgent | --overdue]                     List notes
  find  <query>                                    Search notes by name and content
  help                                             Show this message

Examples:
  ynotes edit meeting-prep --todo --deadline 2026-04-17
  ynotes edit meeting-prep
  ynotes list --urgent
  ynotes find deploy
HELP
}

_ynotes_edit() {
  local name=""
  local is_todo="no"
  local deadline=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --todo)
        is_todo="yes"
        shift
        ;;
      --deadline)
        if [ -z "$2" ]; then
          echo "Error: --deadline requires a date in YYYY-MM-DD format"
          return 1
        fi
        if ! echo "$2" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
          echo "Error: deadline must be in YYYY-MM-DD format"
          return 1
        fi
        if [ -z "$(_ynotes_epochForDate "$2")" ]; then
          echo "Error: invalid date '$2'"
          return 1
        fi
        deadline="$2"
        is_todo="yes"
        shift 2
        ;;
      -*)
        echo "Unknown option: $1"
        return 1
        ;;
      *)
        if [ -z "$name" ]; then
          name="$1"
          shift
        else
          echo "Unexpected argument: $1"
          return 1
        fi
        ;;
    esac
  done

  if [ -z "$name" ]; then
    echo "Error: note name is required"
    echo "Usage: ynotes edit <name> [--todo] [--deadline YYYY-MM-DD]"
    return 1
  fi

  name="${name// /-}"
  local sanitized
  sanitized=$(echo "$name" | tr -cd 'a-zA-Z0-9_-')
  if [ "$sanitized" != "$name" ]; then
    echo "Error: note name can only contain letters, numbers, hyphens, and underscores"
    return 1
  fi

  local filepath="$YNOTES_DIR/${name}.md"
  local is_new=false

  if [ ! -f "$filepath" ]; then
    is_new=true
  else
    if [ "$is_todo" = "yes" ] || [ -n "$deadline" ]; then
      _ynotes_updateCsv "$name" \
        "$([ "$is_todo" = "yes" ] && echo "yes")" \
        "$deadline"
      echo "Updated '$name' in index."
    fi
  fi

  ${EDITOR:-vim} "$filepath"

  if $is_new; then
    if [ -s "$filepath" ]; then
      local today
      today=$(date +%Y-%m-%d)
      echo "$name,$today,$is_todo,$deadline,$filepath" >> "$YNOTES_CSV"
      echo "Note '$name' saved."
    else
      rm -f "$filepath"
      echo "Empty note discarded."
    fi
  fi
}

_ynotes_list() {
  local filter="$1"
  local now_epoch
  now_epoch=$(_ynotes_epochForDate "$(date +%Y-%m-%d)")

  printf "%-25s %-12s %-6s %-12s %-6s\n" "NAME" "CREATED" "TODO" "DEADLINE" "OPEN"
  printf "%-25s %-12s %-6s %-12s %-6s\n" "----" "-------" "----" "--------" "----"

  tail -n +2 "$YNOTES_CSV" | while IFS=',' read -r name created is_todo deadline filepath; do
    case "$filter" in
      --urgent)
        [ "$is_todo" = "yes" ] || continue
        [ -n "$deadline" ] || continue
        local dl_epoch
        dl_epoch=$(_ynotes_epochForDate "$deadline")
        [ -n "$dl_epoch" ] || continue
        local diff=$(( dl_epoch - now_epoch ))
        [ "$diff" -ge 0 ] && [ "$diff" -le 259200 ] || continue
        ;;
      --overdue)
        [ "$is_todo" = "yes" ] || continue
        [ -n "$deadline" ] || continue
        local dl_epoch
        dl_epoch=$(_ynotes_epochForDate "$deadline")
        [ -n "$dl_epoch" ] || continue
        [ "$dl_epoch" -lt "$now_epoch" ] || continue
        ;;
    esac

    local created_epoch
    created_epoch=$(_ynotes_epochForDate "$created")
    local open_days=""
    if [ -n "$created_epoch" ]; then
      open_days="$(( (now_epoch - created_epoch) / 86400 ))d"
    fi

    printf "%-25s %-12s %-6s %-12s %-6s\n" "$name" "$created" "$is_todo" "${deadline:--}" "$open_days"
  done
}

_ynotes_find() {
  local query="$1"
  if [ -z "$query" ]; then
    echo "Error: search query is required"
    echo "Usage: ynotes find <query>"
    return 1
  fi

  echo "=== Matching note names ==="
  tail -n +2 "$YNOTES_CSV" | while IFS=',' read -r name created is_todo deadline filepath; do
    if echo "$name" | grep -qi "$query"; then
      printf "  %-25s (%s)\n" "$name" "$created"
    fi
  done

  echo ""
  echo "=== Matching file contents ==="
  grep -ril "$query" "$YNOTES_DIR"/*.md 2>/dev/null | while read -r match; do
    printf "  %s\n" "$(basename "$match" .md)"
  done
}

ynotes() {
  _ynotes_ensureDir
  local cmd="${1:-help}"
  shift 2>/dev/null
  case "$cmd" in
    edit) _ynotes_edit "$@" ;;
    list) _ynotes_list "$@" ;;
    find) _ynotes_find "$@" ;;
    help) _ynotes_help ;;
    *)    echo "Unknown command: $cmd"; _ynotes_help ;;
  esac
}
