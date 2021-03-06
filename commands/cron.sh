# run configurations of specified period

validate_periodname() {
    test ${1+x} || { errmsg 'argument missing; expected period name'; return 1; }
    local name=$1
    case "$name" in
        daily|weekly|monthly|hourly) ;;
        *) errmsg "invalid period name: '$name'"; return 1;
    esac
}

cmd() {
    validate_period "$@"
    local period=$1; shift

    validate_no_more_args "$@"

    _log() {
        log cron $period "$@"
    }
    _log start

    local plugin config
    for plugin in $(get_plugins); do
        for config in $(get_configs $plugin); do
            load_config $plugin $config
            if [[ $periods == *$period* ]]; then
                _log $plugin $config start
                $MAIN run $plugin $config
                _log $plugin $config end
            fi
        done
    done

    _log end
}
