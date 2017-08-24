# remove a backup configuration

cmd() {
    local plugin=$1; shift
    validate_plugin "$plugin"

    local name=$1; shift
    validate_name $plugin "$name"
    validate_config_exists $plugin $name

    validate_no_more_args "$@"

    remove_config $plugin $name
    #TODO
    #rm_crontab $plugin $name
}
