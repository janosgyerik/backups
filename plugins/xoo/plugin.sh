validate_args() {
    shift
    test $# = 0 || fatal "excess arguments: $@"
}

run() {
    :
}
