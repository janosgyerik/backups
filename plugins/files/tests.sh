#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

. ${0%/*}/plugin.sh

assert_equals _etc_fstab $(slugify /etc/fstab)
assert_equals _etc_fstab $(slugify /etc//fstab)
assert_equals _etc_fstab $(slugify ///etc/fstab)
assert_equals _etc_fstab $(slugify /etc/../etc/fstab)
assert_equals _etc $(slugify /etc////)

fail add files           # name missing
fail add files system    # period missing
fail add files system d  # files missing
ok add files system d /etc/fstab /etc/resolv.conf
ok config files system
matches 'files system d /etc/fstab /etc/resolv.conf' config files system

ok run files system
backups_exist files system d

summary
