# run a backup configuration

cmd() {
    validate_plugin "$@"
    local plugin=$1; shift

    validate_name "$@"
    local name=$1; shift

    validate_config_exists $plugin $name

    local active_periods
    if test $# -gt 0; then
        active_periods=$1; shift
        validate_periods "$active_periods"
    else
        load_config $plugin $name
        active_periods=$periods
    fi

    validate_no_more_args "$@"

    local workdir=$WORK

    load_plugin $plugin
    load_plugin_args $plugin $name

    local i outfile basename ext label period backups_dir
    for ((i = 0; i < ${#active_periods}; i++)); do
        outfile=$(run $plugin $name "$workdir" "${ARGS[@]:-}")
        test -f "$workdir/$outfile" || continue
        basename=${outfile%.*}
        basename=${basename##*/}
        ext=${outfile##*.}
        test "$ext" || ext=bak

        period=${active_periods:i:1}
        case $period in
            d) label=$(date +%a) ;;
            w) label=$(date +%d) ;;
            m) label=$(date +%b) ;;
            h) label=$(date +%H) ;;
            s) label=snapshot ;;
            *) fatal "Unknown period: $period"
        esac

        backups_dir=$(get_backups_dir $plugin $name $period)
        mkdir -p "$backups_dir"

        mv "$workdir/$outfile" "$backups_dir/$basename.$label.$ext"
    done
}
