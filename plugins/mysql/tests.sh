#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

. ${0%/*}/plugin.sh

#assert_equals _etc_fstab $(slugify /etc/fstab)
#assert_equals _etc_fstab $(slugify /etc//fstab)
#assert_equals _etc_fstab $(slugify ///etc/fstab)
#assert_equals _etc_fstab $(slugify /etc/../etc/fstab)
#assert_equals _etc $(slugify /etc////)

fail add mysql           # name missing
fail add mysql testdb    # period missing
fail add mysql nonexistent d

touch $HOME/.my.cnf.testdb
ok add mysql testdb d
ok config mysql testdb

summary
