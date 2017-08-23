validate_args() {
    local name=$1; shift
    test $# -gt 0 || fatal "got no more arguments; expected paths"
}

run() {
    # output: relative paths of files to backup
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    local path
    for path; do
        filename=$(slugify "$path")
        cp "$path" "$workdir/$filename"
        echo "$filename"
    done
}

slugify() {
    local path=$1
    path=$(normalize "$path")
    echo ${path//\//_}
}

normalize() {
    local path=$1
    if test -d "$path"; then
        (cd "$path" && pwd)
    else
        echo "$(cd "$(dirname "$path")"; pwd)/$(basename "$path")"
    fi
}
