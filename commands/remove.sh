# remove a backup configuration

cmd() {
    validate_plugin "$@"
    local plugin=$1; shift

    validate_name "$@"
    local name=$1; shift

    validate_config_exists $plugin $name

    validate_no_more_args "$@"

    remove_config $plugin $name
}
