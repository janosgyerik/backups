# run configurations of specified period

validate_periodname() {
    local name=$1
    case "$name" in
        daily|weekly|monthly|hourly) ;;
        *) fatal "invalid period name: '$name'"
    esac
}

get_period() {
    local shortname
    case "$1" in
        daily) shortname=d ;;
        weekly) shortname=w ;;
        monthly) shortname=m ;;
        hourly) shortname=h ;;
    esac
    echo $shortname
}

cmd() {
    validate_periodname "$@"
    local periodname=$1; shift

    validate_no_more_args "$@"

    period=$(get_period $periodname)

    for plugin in $(get_plugins); do
        for config in $(get_configs $plugin); do
            load_config $plugin $config
            if [[ $periods == *$period* ]]; then
                $MAIN run $plugin $config
            fi
        done
    done
}
