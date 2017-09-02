#!/usr/bin/env bash
#
# SCRIPT: install.sh
# AUTHOR: Janos Gyerik <info@janosgyerik.com>
# DATE:   2017-09-02
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Install the crontab for the backups manager
#

set -euo pipefail

cd "$(dirname "$0")"

installer=crontab-installer
crontab=$installer/crontab.sh.crontab

msg() {
    echo "* $@"
}

cat_default_crontab() {
    cat <<EOF
0 * * * * $PWD/backups.sh cron h
15 0 * * * $PWD/backups.sh cron d
20 1 7,14,21,28 * * $PWD/backups.sh cron w
35 1 1 * * $PWD/backups.sh cron m
EOF
}

if test -f $crontab; then
    msg "File $crontab exists, not overwriting"
else
    msg "Creating $crontab ..."
    cat_default_crontab > $crontab
fi

msg Running installer ...
$installer/crontab.sh
