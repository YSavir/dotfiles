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
