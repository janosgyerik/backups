#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail remove xoo name
ok add xoo name $all_periods

fail remove xoo name excess_arg
ok remove xoo name

summary
