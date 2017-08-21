# list configurations

if test $# -gt 0; then
    plugin=$1; shift
    validate_plugin $plugin

    if test $# -gt 0; then
        name=$1; shift
        validate_name $plugin "$name"

        validate_no_more_args "$@"
    else
        name=
    fi
else
    plugin=
fi

print_configs() {
    load_plugin $plugin
    if test "$name"; then
        print_config $plugin $name
    else
        for name2 in $(get_configs $plugin); do
            print_config $plugin $name2
        done
    fi
}

if test "$plugin"; then
    print_configs $plugin
else
    for plugin in $(get_plugins); do
        print_configs $plugin
    done
fi
