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

filename=$name.dump

case "$period" in
    daily)
        # abbreviated weekday filename
        target=$local_backups_dir/daily/$filename-$(date +%a).gz
        ;;
    weekly)
        # day of month
        target=$local_backups_dir/weekly/$filename-$(date +%d).gz
        ;;
    monthly)
        # abbreviated month filename
        target=$local_backups_dir/monthly/$filename-$(date +%b).gz
        ;;
    *)
    	echo 'Error: unsupported period type: '$period >&2
        exit 1
        ;;
esac

basedir=$(dirname "$target")
mkdir -p $basedir

mysqldump --defaults-file=~/.my.cnf.$name $name | gzip -c >$target
