#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail add   # missing plugin
fail add nonexistent_plugin
fail add xoo  # missing name
fail add xoo 'nonexistent name'
fail add xoo name x_nonexistent_periods
fail add xoo name $all_periods excess_arg

ok add xoo name $all_periods
matches "xoo name $all_periods" config xoo name
fail add xoo name $all_periods  # name already exists
ok remove xoo name

summary
