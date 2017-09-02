validate_args() {
    require_arguments 1 "$@"
    local name=$1; shift

    my_cnf_path=$(my_cnf_path $name)
    test -f "$my_cnf_path" || { errmsg "Configuration file $my_cnf_path missing; create like this: $(print_sample_my_cnf)"; return 1; }
}

my_cnf_path() {
    echo $HOME/.my.cnf.$1
}

print_sample_my_cnf() {
    cat <<EOF


[client]
user=DBUSER
password=DBPASS
host=DBHOST

[mysql]
database=DBNAME
EOF
}

run() {
    # output: relative paths of files to backup
    local plugin=$1; shift
    local name=$1; shift
    local workdir=$1; shift

    validate_args $name "$@"

    target=$workdir/$name.gz
    mysqldump --defaults-file=$(my_cnf_path $name) $name | gzip -c >"$target"
    echo "$name.gz"
}
