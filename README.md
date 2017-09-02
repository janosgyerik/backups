Simple modular backup manager
-----------------------------

TODO: this document is a work in progress, not everything works yet as advertised

Create rolling periodic full backups of MySQL databases, files and more.

Backups are scheduled using cron jobs:

- daily: backups are tagged with the day's name, naturally rotating weekly
- weekly: backups are tagged with the day's number, running on day 7, 14, 21, 28 of every month, naturally rotating monthly
- monthly: backups are tagged with the month's name, naturally rotating yearly

That is, for every file (for example a database dump), you get 23 backups:

- 7 rotating daily backups (last 7 days)
- 4 rotating weekly backups (last 4 weeks)
- 12 rotating yearly backups (last 12 months)

The timing and frequency of the backups is easy to customize by editing the crontab that the script installs.
The default cron configuration is something like this:

    # UNIQUE LABEL
    0 * * * * $PWD/backups.sh cron hourly
    15 0 * * * $PWD/backups.sh cron daily
    20 1 7,14,21,28 * * $PWD/backups.sh cron weekly
    35 1 1 * * $PWD/backups.sh cron monthly

Each cron job executes all the backup configurations that are relevant for the given period. A backup configuration may use any combination of periods. However, all configurations for a given period are triggered at the same time, and run sequentially.

The backup configurations are managed by the `./backup.sh` script,
and should not be edited by hand.

Backup logic is implemented as plugins, so that new kind of backups can be added easily and independently from the rest of the logic, such as the rotating backup mechanism or configuration.

Currently supported plugins:

- mysql: backup mysql databases by running mysqldump and zipping the output
- files: backup groups of files by simply copying

Examples
--------

Install the cron jobs:

    ./install.sh

Get basic usage help:

    ./backup.sh
    ./backup.sh -h
    ./backup.sh --help

Schedule daily and weekly backup of the 'bashoneliners' MySQL database:

    ./backups.sh add mysql bashoneliners dw

Run the backups right now for the MySQL database 'bashoneliners', for all the configured periods:

    ./backups.sh run mysql bashoneliners

List the backup files of the MySQL database 'bashoneliners':
    
    ./backups.sh list mysql bashoneliners

List the backup files of all MySQL database backup configurations:
    
    ./backups.sh list mysql

Show all the MySQL database backup configurations:

    ./backups.sh config mysql

Development
-----------

Run self-tests:

    ./run-tests.sh

To develop a new kind of plugin, see the existing ones as examples in the `plugins` directory.
Feel free to use them as starting point, inspiration.
Each plugin directory contains at least two files:

- `plugin.sh`: the main implementation overriding functions defined in `plugins/base.sh`, and adding any additional functions used internally by the plugin
- `tests.sh`: self-tests, automatically executed when running `./run-tests.sh`

It's best to write the self-tests first, before writing the actual implementation.

