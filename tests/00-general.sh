#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail  # no command
fail nonexistent_command

unset BACKUPS_PATH_OVERRIDE
unset CONF_OVERRIDE
matches $HOME/backups sysinfo BACKUPS_PATH
matches $PWD/conf sysinfo CONF

tmp1=/tmp/x
tmp2=/tmp/y

export BACKUPS_PATH=$tmp1
matches $tmp1 sysinfo BACKUPS_PATH
matches $PWD/conf sysinfo CONF

unset BACKUPS_PATH
export BACKUPS_PATH_OVERRIDE=$tmp1
matches $tmp1 sysinfo BACKUPS_PATH
matches $PWD/conf sysinfo CONF

export BACKUPS_PATH=$tmp1
export BACKUPS_PATH_OVERRIDE=$tmp2
matches $tmp2 sysinfo BACKUPS_PATH
matches $PWD/conf sysinfo CONF

export CONF_OVERRIDE=$tmp1
matches $tmp1 sysinfo CONF

summary
