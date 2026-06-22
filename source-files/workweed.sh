# workweed shell integration. Source this from ~/.bashrc.
# The function captures the chosen worktree path from the `workweed` binary's
# stdout and cd's into it. The binary draws its TUI on /dev/tty, so nothing
# besides the chosen path ever lands on stdout.
workweed() {
    local target
    target=$(command workweed "$@")
    local status=$?
    if [[ $status -eq 0 && -n "$target" && -d "$target" ]]; then
        cd "$target"
    fi
    return $status
}

_workweed() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    if (( COMP_CWORD == 1 )); then
        COMPREPLY=($(compgen -W "set-repo set-hook add remove rm help" -- "$cur"))
        return
    fi

    case "${COMP_WORDS[1]}" in
        remove|rm)
            local names
            names=$(command workweed names 2>/dev/null)
            COMPREPLY=($(compgen -W "$names" -- "$cur"))
            ;;
    esac
}
complete -F _workweed workweed
