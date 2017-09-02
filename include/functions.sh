all_periods=dwmh
all_periods_iterable='d w m h'

msg() {
    echo "* $@"
}

errmsg() {
    local bold_red='\033[1;31m'
    local reset='\033[0m'
    printf "${bold_red}%s${reset}\n" "$*" >&2
}

fatal() {
    errmsg "fatal: $@"
    exit 1
}

validate_cmd() {
    test ${1+x} || fatal 'argument missing; expected command name'
    test "$1" || fatal 'invalid command: empty'
    local path=./commands/$1.sh
    test -f "$path" || fatal "no such command ($path)"
}

validate_plugin() {
    test ${1+x} || fatal 'argument missing; expected plugin name'
    test "$1" || fatal 'invalid plugin: empty'
    local path=./plugins/$1/plugin.sh
    test -f "$path" || fatal "no such plugin ($path)"
}

validate_name() {
    test ${1+x} || fatal 'argument missing; expected name'
    test "$1" || fatal 'invalid name: empty'
    [[ $1 =~ ^[a-zA-Z0-9_-]+$ ]] || fatal "invalid name: $1"
}

validate_config_nonexistent() {
    local name path=$CONF/$1/$2.sh
    test ! -e "$path" || fatal "configuration '$1 $2' already exists; expected not to"
}

validate_config_exists() {
    local name path=$CONF/$1/$2.sh
    test -f "$path" || fatal "configuration '$1 $2' does not exist; expected to exist"
}

validate_periods() {
    test ${1+x} || { errmsg 'argument missing; expected periods'; return 1; }
    test "$1" || { errmsg invalid periods: empty; return 1; }
    local d=0 w=0 m=0 h=0
    for ((i = 0; i < ${#1}; ++i)); do
        local period=${1:i:1}
        case $period in
            d) test $d = 0 && d=1 || { errmsg duplicate period: $period; return 1; } ;;
            w) test $w = 0 && w=1 || { errmsg duplicate period: $period; return 1; } ;;
            m) test $m = 0 && m=1 || { errmsg duplicate period: $period; return 1; } ;;
            h) test $h = 0 && h=1 || { errmsg duplicate period: $period; return 1; } ;;
            *) errmsg invalid period: $period; return 1;
        esac
    done
}

validate_no_more_args() {
    test $# = 0 || fatal "excess arguments: $@"
}

require_arguments() {
    local count=$1; shift
    test $# -ge $count || fatal "got $# arguments; expected $count"
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

    echo $BACKUPS_PATH/$plugin/$name/$period_dir
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
