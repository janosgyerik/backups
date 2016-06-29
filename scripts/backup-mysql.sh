#!/bin/sh
#
# File: backup-mysql.sh
# Purpose: backup selected mysql databases to $local_backups_dir
#

period=$1
name=$2

if ! test "$period" -a "$name"; then
    echo Usage: $0 'daily|weekly|monthly' name
    exit 1
fi

cd $(dirname $0)/..
. ./common.sh

set_period_target $period $name.dump

basedir=$(dirname "$target")
mkdir -p $basedir

mysqldump --defaults-file=~/.my.cnf.$name $name | gzip -c >$target
