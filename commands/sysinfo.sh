# show system information (hidden command, for testing)

cmd() {
    test $# != 0 || { errmsg invalid name: empty; return 1; }

    local name=$1; shift
    validate_no_more_args "$@"

    case "$name" in
        HOME) echo $HOME ;;
        CONF) echo $CONF ;;
        BACKUPS_PATH) echo $BACKUPS_PATH ;;
        *) errmsg invalid name: $name; return 1;
    esac
}
