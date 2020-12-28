tests_cnt=0
failed_cnt=0

assert_fail() {
    ((++tests_cnt))
    if "$@" &>/dev/null; then
        ((++failed_cnt))
        errmsg "Failed: got success, expected failure: $@"
    fi
}

assert_ok() {
    ((++tests_cnt))
    if ! "$@" >/dev/null; then
        ((++failed_cnt))
        errmsg "Failed: got failure, expected success: $@"
    fi
}

assert_equals() {
    local expected=$1; shift
    local actual=$1; shift
    ((++tests_cnt))
    if [ "$actual" != "$expected" ]; then
        ((++failed_cnt))
        errmsg "got $actual != $expected"
    fi
}

testrun() {
    "$MAIN" "$@" | sort
}

fail() {
    assert_fail testrun "$@"
}

ok() {
    assert_ok testrun "$@"
}

matches() {
    ((++tests_cnt))
    local expected=$1; shift
    local actual=$(testrun "$@")
    if [ "$expected" != "$actual" ]; then
        ((++failed_cnt))
        errmsg "got '$actual', expected '$expected'"
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
        is_non_empty_dir "$backups_dir" || { errmsg "expected backups in $backups_dir"; return 1; }
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

summary() {
    if test $failed_cnt = 0; then
        msg ok: all $tests_cnt tests passed
    else
        errmsg "Tests failed: $failed_cnt / $tests_cnt tests failed"
        return 1
    fi
}
