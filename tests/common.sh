#!/usr/bin/env bash

set -euo pipefail

. ./functions.sh

# general usage
fail  # no command
fail invalid_command

# add
fail add invalid_plugin
fail add xoo 'invalid name'
fail add xoo name invalid_periods
fail add xoo name dwmh excess_arg
ok add xoo name dwmh
matches "xoo name dwmh" config xoo name
#TODO
#crontabs 4 xoo name
fail add xoo name dwmh  # name already exists
ok rm xoo name
#TODO
#crontabs 0 xoo name

# config
fail config xoo name
ok add xoo name dwmh
ok config xoo name
fail config xoo name excess_arg
fail config xoo nonexistent_name
ok rm xoo name

# rm
fail rm xoo name
ok add xoo name dwmh
fail rm xoo name excess_arg
ok rm xoo name

summary
