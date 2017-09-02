#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail cron
fail cron x_nonexistent_period

ok add xoo example1 d
ok add xoo example2 dw
ok add xoo example3 wm

fail cron daily excess_arg
ok cron daily

backups_exist xoo example1 d
backups_exist xoo example2 d

fail cron weekly excess_arg
ok cron weekly

backups_exist xoo example2 w
backups_exist xoo example3 w

fail cron monthly excess_arg
ok cron monthly

backups_exist xoo example3 m

summary
