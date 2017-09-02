validate_args() {
    require_arguments 1 "$@"
    local name=$1; shift

    test $# -gt 0 || { errmsg "got no more arguments; expected paths"; return 1; }
}

run() {
    # output: relative paths of files to backup
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    validate_args $name "$@"

    local filename=$name.tgz
    tar zcf "$workdir/$filename" "$@" &>/dev/null
    echo "$filename"
}
