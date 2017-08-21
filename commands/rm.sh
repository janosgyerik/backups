# remove a backup configuration

plugin=$1; shift
validate_plugin $plugin

name=$1; shift
validate_name $plugin "$name"
validate_config_exists $plugin $name

validate_no_more_args "$@"

rm_config $plugin $name
#TODO
#rm_crontab $plugin $name
