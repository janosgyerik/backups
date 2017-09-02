# show system information (hidden command, for testing)

cmd() {
    test $# != 0 || fatal invalid name: empty

    local name=$1; shift
    validate_no_more_args "$@"

    case "$name" in
        HOME) echo $HOME ;;
        CONF) echo $CONF ;;
        BACKUPS_PATH) echo $BACKUPS_PATH ;;
        *) fatal invalid name: $name
    esac
}
