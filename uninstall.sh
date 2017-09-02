#!/usr/bin/env bash
#
# SCRIPT: uninstall.sh
# AUTHOR: Janos Gyerik <info@janosgyerik.com>
# DATE:   2017-09-02
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Unistall the crontab for the backups manager
#

set -euo pipefail

cd "$(dirname "$0")"

./crontab-installer/crontab.sh --remove
