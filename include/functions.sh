#!/bin/sh
#
# File: functions.sh
# Purpose: common functions 
#

is_ready_backupsite() {
    readyfile=$ready_dir/$1
    test -f $readyfile && return 0 || return 1
}

detect_backupsites() {
    grep '^Host backup-.*' ~/.ssh/config 2>/dev/null | cut -f2 -d' '
}

info() {
    echo '[info]' $@
}
checking() {
    echo '[check]' $@
}
result() {
    echo '[result]' $@
}
warn() {
    echo '[WARN]' $@
}

require0() {
    type "$1" >/dev/null 2>/dev/null
    return $?
}

require() {
    if ! type "$1" >/dev/null 2>/dev/null; then
	echo 'Fatal: program "'$1'" is either not in PATH or not installed. Exit.'
	exit 1
    fi
}

set_period_target() {
    period=$1
    dumpname=$2
    case "$period" in
        daily)
            # abbreviated weekday name
            target=$local_backups_dir/daily/$dumpname-$(date +%a).gz
            ;;
        weekly)
            # day of month
            target=$local_backups_dir/weekly/$dumpname-$(date +%d).gz
            ;;
        monthly)
            # abbreviated month name
            target=$local_backups_dir/monthly/$dumpname-$(date +%b).gz
            ;;
        *)
            echo 'Error: unsupported period type: '$period >&2
            exit 1
            ;;
    esac
}
