#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

fail  # no command
fail nonexistent_command

summary
