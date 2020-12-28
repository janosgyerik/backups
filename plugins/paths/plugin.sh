validate_args() {
    require_arguments 1 "$@"
    local name=$1; shift

    test $# -gt 0 || { errmsg "got no more arguments; expected paths"; return 1; }
}

run() {
    # output: relative path from $workdir of a single file to backup
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    validate_args $name "$@"

    local filename=$name.tgz
    local out
    if ! out=$(tar zcf "$workdir/$filename" "$@" 2>&1); then
        echo "$out" >&2
        exit 1
    fi
    echo "$filename"
}
