#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

ok config
matches '' config

fail config nonexistent_plugin
fail config xoo nonexistent_config

ok add xoo example1 d
matches 'xoo example1 d' config xoo
fail config xoo example1 excess_arg

ok add xoo example2 w
matches 'xoo example1 d' config xoo example1
matches 'xoo example2 w' config xoo example2
matches 'xoo example1 d
xoo example2 w' config xoo

summary
