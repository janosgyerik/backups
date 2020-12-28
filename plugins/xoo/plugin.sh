validate_args() {
    require_arguments 1 "$@"
    local name=$1; shift

    test $# = 0 || { errmsg "excess arguments: $@"; return 1; }
}

run() {
    # output: relative path from $workdir of a single file to backup
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    local backupfile=xoo.zip
    touch "$workdir/$backupfile"
    echo $backupfile
}
