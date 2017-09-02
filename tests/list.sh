#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

day=$(date +%a)
week=$(date +%d)

ok list
matches '' list
matches '' list xoo

fail list nonexistent_plugin
fail list xoo nonexistent_config

ok add xoo example1 d
ok run xoo example1
ok list xoo example1
matches "$BACKUPS_PATH/xoo/example1/daily/xoo.$day.zip" list xoo

ok add xoo example2 w
ok run xoo example2
ok list xoo

matches "$BACKUPS_PATH/xoo/example1/daily/xoo.$day.zip" list xoo example1
matches "$BACKUPS_PATH/xoo/example2/weekly/xoo.$week.zip" list xoo example2
matches "$BACKUPS_PATH/xoo/example1/daily/xoo.$day.zip
$BACKUPS_PATH/xoo/example2/weekly/xoo.$week.zip" list xoo

ok add xoo example3 w
ok list xoo example3
matches '' list xoo example3

summary
