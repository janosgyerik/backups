validate_args() {
    local name=$1; shift
    test $# = 0 || fatal "excess arguments: $@"
}

run() {
    # output: path to backup file
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    local backupfile=xoo.zip
    touch "$workdir/$backupfile"
    echo $backupfile
}
