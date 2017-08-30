#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./include/functions.sh

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15

#crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -

test $# -gt 0 || set -- tests/* plugins/*/tests.sh

export MAIN=$PWD/backups.sh
unset BACKUPS_PATH

for testscript; do
    test -f "$testscript" || continue

    work=$(mktemp -d)
    export CONF=$work/conf
    export BACKUPS=$work/backups
    mkdir -p "$CONF" "$BACKUPS"

    export CONF_OVERRIDE=$CONF
    export BACKUPS_PATH_OVERRIDE=$BACKUPS

    msg running tests: $testscript ...
    $testscript
    cleanup
done
