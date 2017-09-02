#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail run nonexistent_plugin
fail run xoo nonexistent_config
ok add xoo name $all_periods
fail run xoo name x_nonexistent_periods
fail run xoo name d excess_arg

ok run xoo name dw
backups_exist xoo name dw
backups_clean xoo name

ok run xoo name
backups_exist xoo name $all_periods
backups_clean xoo name

summary
