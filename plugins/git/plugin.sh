validate_args() {
    require_arguments 1 "$@"
    local name=$1; shift

    test $# -gt 0 || { errmsg "got no more arguments; expected path to git work tree"; return 1; }

    local git_work_tree=$1; shift
    test -d "$git_work_tree/.git" || { errmsg "expected directory to exist: $git_work_tree"; return 1; }
}

run() {
    # output: nothing! the Git repo itself stores past states
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    validate_args "$name" "$@"

    local git_work_tree=$1; shift
    (
        cd "$git_work_tree"
        git add -A
        git commit -m "Auto-commit on $(date)" &>/dev/null || :
    ) >/dev/null
}
