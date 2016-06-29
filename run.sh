#!/bin/bash
#
# File: run.sh
# Purpose: create and rotate backups
#

usage() {
    echo Usage: $0 'daily|weekly|monthly|hourly [type [name]]'
    exit 1
}

period=$1
btype=$2
name=$3
test "$period" || usage

cd $(dirname "$0")
. ./common.sh

run_type_name() {
    btype=$1
    name=$2
    info backup: $btype $period $name
    ./scripts/backup-$btype.sh $period $name
}

run_type() {
    btype=$1
    namevar=${btype}_names
    for name in ${!namevar}; do
        run_type_name $btype $name
    done
}

run() {
    if test "$types"; then
        for btype in "$types"; do
            run_type $btype
        done
    fi
}

if test "$btype" -a "$name"; then
    run_type_name $btype $name
elif test "$btype"; then
    run_type $btype
else
    run
fi
