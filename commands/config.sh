# list configurations

print_configs() {
    local plugin=$1
    local name=$2

    if test "$name"; then
        print_config $plugin $name
    else
        for name in $(get_configs $plugin); do
            print_config $plugin $name
        done
    fi
}

cmd() {
    local plugin name

    if test $# -gt 0; then
        plugin=$1; shift
        validate_plugin "$plugin"

        if test $# -gt 0; then
            name=$1; shift
            validate_name "$name"
            validate_config_exists "$plugin" "$name"

            validate_no_more_args "$@"
        else
            name=
        fi
    else
        plugin=
        name=
    fi

    if test "$plugin"; then
        print_configs $plugin "$name"
    else
        for plugin in $(get_plugins); do
            print_configs $plugin "$name"
        done
    fi
}
