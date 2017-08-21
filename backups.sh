#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./include/functions.sh

# usage examples:
# add mysql wp1 d
# add file name d path
# update mysql wp1 d
# rm mysql wp1
# list [mysql [wp1]]
# crontabs mysql [wp1]
# run mysql wp1 [d]

cmd=$1; shift
validate_cmd "$cmd"

. ./commands/$cmd.sh
cmd "$@"
