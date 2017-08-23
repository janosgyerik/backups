#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail config xoo name
ok add xoo name $all_periods
ok config xoo name
#TODO
#ok config xoo
#ok config
fail config xoo name excess_arg
fail config xoo nonexistent_name

summary
