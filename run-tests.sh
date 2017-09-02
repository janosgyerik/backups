#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./include/functions.sh
. ./include/test-functions.sh

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15

#crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -

test $# -gt 0 || set -- tests/* plugins/*/tests.sh

export MAIN=$PWD/backups.sh
unset HOME BACKUPS_PATH

for testscript; do
    test -f "$testscript" || continue

    work=$(mktemp -d)
    export HOME=$work/home
    export HOME_OVERRIDE=$HOME
    export BACKUPS_PATH=$work/backups
    export BACKUPS_PATH_OVERRIDE=$BACKUPS_PATH
    export CONF=$work/conf
    export CONF_OVERRIDE=$CONF
    mkdir -p "$HOME" "$BACKUPS_PATH" "$CONF"

    msg running tests: $testscript ...
    assert_ok $testscript
    cleanup
done

summary
