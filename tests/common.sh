#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

all_periods=dwmh

# general usage
fail  # no command
fail nonexistent_command

# add
fail add nonexistent_plugin
fail add xoo 'nonexistent name'
fail add xoo name x_nonexistent_periods
fail add xoo name $all_periods excess_arg
ok add xoo name $all_periods
matches "xoo name $all_periods" config xoo name
#TODO
#crontabs 4 xoo name
fail add xoo name $all_periods  # name already exists
ok remove xoo name
#TODO
#crontabs 0 xoo name

# config
fail config xoo name
ok add xoo name $all_periods
ok config xoo name
#TODO
#ok config xoo
#ok config
fail config xoo name excess_arg
fail config xoo nonexistent_name
ok remove xoo name

# remove
fail remove xoo name
ok add xoo name $all_periods
fail remove xoo name excess_arg
ok remove xoo name

# run
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

ok remove xoo name

#TODO list backups
#list

summary
