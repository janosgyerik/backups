# run a backup configuration

plugin=$1; shift
validate_plugin $plugin

name=$1; shift
validate_name $plugin "$name"
validate_config_exists $plugin $name

if test $# -gt 0; then
    requested_periods=$1; shift
    validate_periods "$requested_periods"
else
    requested_periods=
fi

validate_no_more_args "$@"

load_plugin $plugin

load_config $plugin $name

test "$requested_periods" && periods=$requested_periods

workdir=$WORK
for ((i = 0; i < ${#periods}; i++)); do
    outfile=$(run $plugin $name "$workdir")

    basename=${outfile%.*}
    basename=${basename##*/}
    ext=${outfile##*.}
    test "$ext" || ext=bak

    period=${periods:i:1}
    case $period in
        d) label=$(date +%a) ;;
        w) label=$(date +%d) ;;
        m) label=$(date +%b) ;;
        h) label=$(date +%H) ;;
        *) fatal "Unknown period: $period"
    esac

    backups_dir=$(get_backups_dir $plugin $name $period)
    mkdir -p "$backups_dir"

    mv "$workdir/$outfile" "$backups_dir/$basename.$label.$ext"
done
