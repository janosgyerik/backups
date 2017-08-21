# add a backup configuration

plugin=$1; shift
validate_plugin $plugin

name=$1; shift
validate_name $plugin "$name"
validate_config_nonexistent $plugin $name

periods=$1; shift
validate_periods "$periods"

load_plugin $plugin

validate_args $name "$@"

write_config $plugin $name

add_crontab $plugin $name $periods
