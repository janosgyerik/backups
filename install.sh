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
0 * * * * $PWD/backups.sh cron hourly
15 0 * * * $PWD/backups.sh cron daily
20 1 7,14,21,28 * * $PWD/backups.sh cron weekly
35 1 1 * * $PWD/backups.sh cron monthly
EOF
}

if test -f $crontab; then
    msg "file $crontab exists, not overwriting"
else
    msg "creating $crontab with content:"
    cat_default_crontab | tee $crontab | {
        echo
        sed -e 's/^/  /'
        echo
    }
fi

msg running installer ...
$installer/crontab.sh
