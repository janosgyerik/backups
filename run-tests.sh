#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15
work=$(mktemp -d)

export WORK=$work/work
export CONF=$work/conf
export BACKUPS=$work/backups
mkdir -p "$WORK" "$CONF" "$BACKUPS"

export MAIN=$PWD/backups.sh
export CRONTAB=cat
#crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -

msg() {
    echo "* $@"
}

test $# -gt 0 || set -- tests/* plugins/*/tests.sh

for testscript; do
    test -f "$testscript" || continue
    msg running tests: $testscript ...
    $testscript
done
