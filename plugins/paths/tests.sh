#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

. ${0%/*}/plugin.sh

fail add paths           # name missing
fail add paths system    # period missing
fail add paths system d  # paths missing
ok add paths system d /etc/hosts /etc/resolv.conf
ok config paths system
matches 'paths system d /etc/hosts /etc/resolv.conf' config paths system

ok run paths system
backups_exist paths system d

ok add paths system2 w /etc/hosts /etc/nonexistent
ok config paths system2
matches 'paths system2 w /etc/hosts /etc/nonexistent' config paths system2
fail run paths system2

summary
