validate_args() {
    shift
    test $# = 0 || fatal "excess arguments: $@"
}

run() {
    # params: plugin name workdir
    # output: path to backup file
    local backupfile=xoo.zip
    touch "$3/$backupfile"
    echo $backupfile
}
