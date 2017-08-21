common_params="periods extras"
plugin_params=

clear_config() {
    local name
    for name in $common_params $plugin_params; do
        printf -v $name ""
    done
}

load_config() {
    clear_config
    . "$CONF/$1/$2.sh"
}

write_config() {
    local name path=$CONF/$1/$2.sh
    mkdir -p "$(dirname "$path")"
    > "$path.bak"
    set +u
    for name in $common_params $plugin_params; do
        echo "$name=\"${!name}\"" >> "$path.bak"
    done
    set -u
    mv "$path.bak" "$path"
}

validate_args() {
    :
}

run() {
    :
}
