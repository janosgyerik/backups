#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

. ${0%/*}/plugin.sh

fail add git             # name missing
fail add git reponame    # period missing
fail add git reponame d  # git work dir missing
fail add git reponame d /nonexistent # invalid git work dir
fail add git reponame d /tmp         # invalid git work dir

repo=$TMP/repo
mkdir "$repo"
(
    cd "$repo"
    git init
    date > date.out
    git add -A
    git commit -m 'Add a file'
) >/dev/null

ok add git foo d "$repo"
ok config git foo
matches "git foo d $repo" config git foo

rev_count() {
    (cd "$repo"; git rev-list HEAD) | wc -l
}

assert_rev_count() {
    count=$(rev_count)
    ((count == $1))
}

fail test -f "$repo/file"
date > "$repo/file"
ok run git foo
assert_ok assert_rev_count 2

date >> "$repo/file"
ok run git foo
assert_ok assert_rev_count 3

ok run git foo
assert_ok assert_rev_count 3

summary
