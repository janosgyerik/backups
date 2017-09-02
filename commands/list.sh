# list backups

print_backups_plugin_name_period() {
    local plugin=$1
    local name=$2
    local period=$3
    local backups_dir

    backups_dir=$(get_backups_dir $plugin $name $period)
    # TODO fragile
    if test -d "$backups_dir"; then
        find "$backups_dir" -type f | sed -e "s?^$BACKUPS_PATH/??"
    fi
}

print_backups_plugin_name() {
    local plugin=$1
    local name=$2
    local period backups_dir

    # TODO fragile
    backups_dir=$(get_backups_dir $plugin $name d)
    test -d "${backups_dir%/*}" || fatal "no such configuration: $plugin $name"

    for period in $all_periods_iterable; do
        print_backups_plugin_name_period $plugin $name $period
    done
}

print_backups_plugin() {
    local plugin=$1
    local name

    for name in $(get_configs $plugin); do
        print_backups_plugin_name $plugin $name
    done
}

print_backups() {
    local plugin

    for plugin in $(get_plugins); do
        print_backups_plugin $plugin
    done
}

cmd() {
    if test $# -gt 0; then
        plugin=$1; shift
        validate_plugin "$plugin"

        if test $# -gt 0; then
            name=$1; shift
            validate_name "$name"

            validate_no_more_args "$@"

            print_backups_plugin_name $plugin $name
        else
            print_backups_plugin $plugin
        fi
    else
        print_backups
    fi
}
