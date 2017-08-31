# add a backup configuration

cmd() {
    validate_plugin "$@"
    local plugin=$1; shift

    validate_name $plugin "$@"
    local name=$1; shift

    validate_config_nonexistent $plugin $name

    validate_periods "$@"
    local periods=$1; shift

    load_plugin $plugin

    validate_args $name "$@"

    write_config $plugin $name
    write_plugin_args $plugin $name "$@"
}
