#!/usr/bin/env bash
#
# SCRIPT: backups.sh
# AUTHOR: Janos Gyerik <info@janosgyerik.com>
# DATE:   2017-08-30
#
# PLATFORM: Not platform dependent
#
# PURPOSE: A simple modular backup manager
#

set -euo pipefail

cd "$(dirname "$0")"

. ./include/functions.sh

usage() {
    test $# = 0 || echo "$@"
    echo "Usage: $0 COMMAND [COMMAND-ARGS...]"
    echo
    echo A simple modular backup manager
    echo
    echo Options:
    echo
    echo "  -h, --help         Print this help"
    echo
    echo Commands:
    echo
    echo "  add PLUGIN NAME PERIODS [ARGS...]"
    echo "  config [PLUGIN [NAME]]"
    echo "  cron [daily|weekly|month|hourly]"
    echo "  list [PLUGIN [NAME]]"
    echo "  remove PLUGIN NAME"
    echo "  run PLUGIN NAME [PERIODS]"
    echo
    exit 1
}

for arg; do
    case "$arg" in
        -h|--help) usage ;;
        '') fatal empty argument, probably an error ;;
    esac
done

test $# -gt 0 || usage

cmd=$1; shift
validate_cmd "$cmd"

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15

work=$(mktemp -d)

MAIN=$PWD/backups.sh
WORK=$work

if test "${HOME_OVERRIDE+x}"; then
    HOME=$HOME_OVERRIDE
fi

if test "${CONF_OVERRIDE+x}"; then
    CONF=$CONF_OVERRIDE
else
    CONF=$PWD/conf
fi

if test "${BACKUPS_PATH_OVERRIDE+x}"; then
    BACKUPS_PATH=$BACKUPS_PATH_OVERRIDE
elif test ! "${BACKUPS_PATH+x}"; then
    BACKUPS_PATH=$HOME/backups
fi

. ./commands/$cmd.sh
cmd "$@"
