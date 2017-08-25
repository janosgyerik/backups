msg() {
    echo "* $@"
}

fatal() {
    echo fatal: $* >&2
    exit 1
}

validate_cmd() {
    test "$1" || fatal 'invalid command: empty'
    local path=./commands/$1.sh
    test -f "$path" || fatal "no such command ($path)"
}

validate_plugin() {
    test "$1" || fatal 'invalid plugin: empty'
    local path=./plugins/$1/plugin.sh
    test -f "$path" || fatal "no such plugin ($path)"
}

validate_name() {
    test "$1" || fatal 'invalid name: empty'
    [[ $1 =~ ^[a-zA-Z0-9_-]+$ ]] || fatal "invalid name: $1"
}

validate_config_nonexistent() {
    local name path=$CONF/$1/$2.sh
    test ! -e "$path" || fatal "configuration '$1 $2' already exists"
}

validate_config_exists() {
    local name path=$CONF/$1/$2.sh
    test -f "$path" || fatal "configuration '$1 $2' does not exist"
}

validate_periods() {
    test "$1" || fatal 'invalid period: empty'
    for ((i = 0; i < ${#1}; ++i)); do
        local period=${1:i:1}
        case $period in
            # TODO don't allow same period twice
            [dwmh]) ;;
            *) fatal "invalid period: $period"
        esac
    done
}

validate_no_more_args() {
    test $# = 0 || fatal "excess arguments: $@"
}

clear_config() {
    periods=
}

get_config_path() {
    local plugin=$1
    local name=$2
    echo "$CONF/$plugin/$name.sh"
}

get_plugin_args_path() {
    local plugin=$1
    local name=$2
    echo "$CONF/$plugin/$name.sh.args"
}

load_config() {
    clear_config
    . "$(get_config_path "$@")"
}

write_config() {
    local path=$(get_config_path "$@")
    mkdir -p "${path%/*}"
    cat <<EOF >"$path.bak"
periods=$periods
EOF
    mv "$path.bak" "$path"
}

write_plugin_args() {
    local plugin=$1; shift
    local name=$1; shift
    test $# -gt 0 || return 0

    local path=$(get_plugin_args_path $plugin $name)
    local arg
    for arg; do
        echo "$arg"
    done > "$path"
}

load_plugin_args() {
    local plugin=$1; shift
    local name=$1; shift

    ARGS=()
    local path=$(get_plugin_args_path $plugin $name)
    test -f "$path" || return 0

    local arg
    while read -r arg; do
        ARGS+=("$arg")
    done <<< "$(cat "$path")"
}

remove_config() {
    rm "$(get_config_path "$@")"
}

load_plugin() {
    local plugin=$1
    . ./plugins/base.sh
    . ./plugins/$plugin/plugin.sh
}

print_config() {
    local plugin=$1
    local name=$2
    load_config $plugin $name
    load_plugin_args $plugin $name
    echo $plugin $name $periods "${ARGS[@]}"
}

add_crontab() {
    # TODO
    :
}

get_backups_dir() {
    local plugin=$1; shift
    local name=$1; shift
    local period=$1; shift
    local period_dir

    case $period in
        d) period_dir=daily ;;
        w) period_dir=weekly ;;
        m) period_dir=monthly ;;
        h) period_dir=hourly ;;
        *) fatal "Unknown period: $period"
    esac

    echo $BACKUPS/$plugin/$name/$period_dir
}

get_plugins() {
    ls -d plugins/*/ | cut -f2 -d/
}

get_configs() {
    local plugin=$1; shift
    local path=$CONF/$plugin

    if test -d "$path"; then
        find "$path" -type f -name '*.sh' | sed -e 's?.*/??' -e 's/\.sh$//'
    fi
}
