#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

. ${0%/*}/plugin.sh

fail add paths           # name missing
fail add paths system    # period missing
fail add paths system d  # paths missing
ok add paths system d /etc/fstab /etc/resolv.conf
ok config paths system
matches 'paths system d /etc/fstab /etc/resolv.conf' config paths system

ok run paths system
backups_exist paths system d

summary
