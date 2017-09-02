#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

assert_fail validate_periods
assert_fail validate_periods ''
assert_fail validate_periods x
assert_ok validate_periods dwmh
assert_ok validate_periods d
assert_ok validate_periods w
assert_ok validate_periods m
assert_ok validate_periods h

assert_fail validate_periods dd
assert_fail validate_periods ww
assert_fail validate_periods mm
assert_fail validate_periods hh
assert_fail validate_periods dwmhd
assert_fail validate_periods ddw
assert_fail validate_periods xd

summary
