# list available plugins

cmd() {
    validate_no_more_args "$@"

    local plugin
    for plugin in $(get_plugins); do
        [ $plugin != xoo ] || continue
        echo $plugin
    done
}
