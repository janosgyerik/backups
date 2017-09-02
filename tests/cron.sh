#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail cron
fail cron x_nonexistent_period

ok add xoo example1 d
ok add xoo example2 dw
ok add xoo example3 wm

fail cron d excess_arg
fail cron daily  # invalid arg, should use dwmh
ok cron d

backups_exist xoo example1 d
backups_exist xoo example2 d

fail cron w excess_arg
fail cron weekly
ok cron w

backups_exist xoo example2 w
backups_exist xoo example3 w

fail cron m excess_arg
fail cron monthly excess_arg
ok cron m

backups_exist xoo example3 m

summary
