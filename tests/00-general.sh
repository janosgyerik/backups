#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail  # no command
fail nonexistent_command

unset HOME
unset HOME_OVERRIDE
unset BACKUPS_PATH
unset BACKUPS_PATH_OVERRIDE
unset CONF
unset CONF_OVERRIDE

HOME=x matches x sysinfo HOME
HOME=x HOME_OVERRIDE=y matches y sysinfo HOME

export HOME=/tmp/home
matches $HOME/backups sysinfo BACKUPS_PATH
BACKUPS_PATH=x matches x sysinfo BACKUPS_PATH
BACKUPS_PATH=x BACKUPS_PATH_OVERRIDE=y matches y sysinfo BACKUPS_PATH

matches $PWD/conf sysinfo CONF
CONF=x matches $PWD/conf sysinfo CONF
CONF_OVERRIDE=x matches x sysinfo CONF

summary
