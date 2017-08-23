#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./include/functions.sh

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15

export MAIN=$PWD/backups.sh
#crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -

test $# -gt 0 || set -- tests/* plugins/*/tests.sh

for testscript; do
    test -f "$testscript" || continue

    work=$(mktemp -d)
    export WORK=$work/work
    export CONF=$work/conf
    export BACKUPS=$work/backups
    mkdir -p "$WORK" "$CONF" "$BACKUPS"

    msg running tests: $testscript ...
    $testscript
    cleanup
done
