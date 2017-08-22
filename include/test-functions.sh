tests_cnt=0
failed_cnt=0

assert_equals() {
    local expected=$1; shift
    local actual=$1; shift
    ((++tests_cnt))
    if [ "$actual" != "$expected" ]; then
        ((++failed_cnt))
        echo "got $actual != $expected"
    fi
}

run_main() {
    "$MAIN" "$@"
}

fail() {
    ((++tests_cnt))
    if run_main "$@" &>/dev/null; then
        ((++failed_cnt))
        echo got success, expected fail: $@
    fi
}

ok() {
    ((++tests_cnt))
    if ! run_main "$@" >/dev/null; then
        ((++failed_cnt))
        echo got failure, expected success: $@
    fi
}

matches() {
    ((++tests_cnt))
    local expected=$1; shift
    local actual=$(run_main "$@")
    if [ "$expected" != "$actual" ]; then
        ((++failed_cnt))
        echo "got '$actual', expected '$expected'"
    fi
}

backups_exist() {
    local plugin=$1; shift
    local name=$1; shift
    local periods=$1; shift
    local period backups_dir

    for ((i = 0; i < ${#periods}; i++)); do
        period=${periods:i:1}
        backups_dir=$(get_backups_dir $plugin $name $period)
        is_non_empty_dir "$backups_dir" || fatal "expected backups in $backups_dir"
    done
}

backups_clean() {
    local plugin=$1; shift
    local name=$1; shift
    local backups_dir=$(get_backups_dir $plugin $name d)
    rm -fr "${backups_dir%/*}"
}

is_non_empty_dir() {
    test "$(ls -A "$1")"
}

crontabs() {
    TODO
}

summary() {
    if test $failed_cnt = 0; then
        echo ok: all $tests_cnt tests passed
    else
        echo failed: $failed_cnt / $tests_cnt tests failed
    fi
}
