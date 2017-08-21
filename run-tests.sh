#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15
work=$(mktemp -d)

export CONF=$work/conf
export BACKUPS=$PWD/backups.sh
export CRONTAB=cat
#crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -

msg() {
    echo "* $@"
}

for t in tests/* plugins/*/tests.sh; do
    test -f "$t" || continue
    msg running tests: $t ...
    $t
done
