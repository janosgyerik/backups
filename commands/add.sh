# add a backup configuration

cmd() {
    local plugin=$1; shift
    validate_plugin $plugin

    local name=$1; shift
    validate_name $plugin "$name"
    validate_config_nonexistent $plugin $name

    local periods=$1; shift
    validate_periods "$periods"

    load_plugin $plugin

    validate_args $name "$@"

    write_config $plugin $name

    add_crontab $plugin $name $periods
}
