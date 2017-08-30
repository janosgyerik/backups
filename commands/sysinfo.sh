# show system information (hidden command, for testing)

cmd() {
    local name=$1; shift
    validate_no_more_args "$@"

    case "$name" in
        BACKUPS_PATH) echo $BACKUPS_PATH ;;
        CONF) echo $CONF ;;
        *) fatal "invalid option: $1"
    esac
}
