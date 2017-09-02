#!/usr/bin/env bash

set -euo pipefail

. ./include/functions.sh
. ./include/test-functions.sh

assert_fail validate_cmd
assert_fail validate_cmd ''
assert_fail validate_cmd nonexistent
assert_ok validate_cmd config

assert_fail validate_plugin
assert_fail validate_plugin ''
assert_fail validate_plugin nonexistent
assert_ok validate_plugin xoo

assert_fail validate_name
assert_fail validate_name ''
assert_fail validate_name 'a b'
assert_fail validate_name 'a%b'
assert_ok validate_name simple_name_1

assert_ok validate_config_missing xoo config1
assert_fail validate_config_exists xoo config1
ok add xoo config1 d

assert_fail validate_config_missing xoo config1
assert_ok validate_config_exists xoo config1
ok remove xoo config1

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

assert_ok validate_no_more_args
assert_fail validate_no_more_args ''
assert_fail validate_no_more_args x

summary
