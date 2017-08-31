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
    echo "Usage: $0 CMD [CMD-ARGS]"
    echo
    echo A simple modular backup manager
    echo
    echo Options:
    echo
    echo "  -h, --help         Print this help"
    echo
    echo Commands:
    echo
    echo "  add PLUGIN NAME PERIODS"
    echo "  config [PLUGIN [NAME]]"
    echo "  cron [daily|weekly|month|hourly]"
    echo "  list [PLUGIN [NAME]]"
    echo "  remove PLUGIN NAME"
    echo "  run PLUGIN NAME [PERIODS]"
    echo
    exit 1
}

args=
#flag=off
#param=
while test $# != 0; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
#    -p|--param) shift; param=$1 ;;
#    --) shift; while test $# != 0; do args="$args \"$1\""; shift; done; break ;;
    -|-?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
    esac
    shift
done

eval "set -- $args"  # save arguments in $@. Use "$@" in for loops, not $@ 

test $# -gt 0 || usage

cmd=$1; shift
validate_cmd "$cmd"

cleanup() {
    test -d "$work" && rm -fr "$work"
}

trap 'cleanup; exit' 0 1 2 3 15

work=$(mktemp -d)

export MAIN=$PWD/backups.sh
export WORK=$work

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
