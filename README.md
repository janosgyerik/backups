Simple modular backup manager
-----------------------------

Create rolling periodic full backups of MySQL databases, paths and more.

Main features:

- Create full backups of MySQL databases or filesystem paths
- Run backups periodically, executed by cron, daily, weekly, monthly
- Rotate backups
- Manage backups: add and list configurations, list backup files

Quick guide
-----------

Install the cron jobs that will execute the backup configurations:

    ./install.sh

To create and manage the backup configurations, use the `./backups.sh` command.
Run it without arguments or with `-h` or `--help` to get basic usage help:

    ./backup.sh
    ./backup.sh -h
    ./backup.sh --help

To dive right in, jump to the **Examples** section.

To understand the concepts and how it works, continue reading the **Detailed guide**.

Detailed guide
--------------

A backup configuration consists of the following parameters:

- `plugin`: the plugin to use to generate backup files, for example `mysql`, `paths`
- `name`: a simple label to use to identify the configuration
- `periods`: the backup periods, for example daily, weekly, monthly
- any additional arguments required by the given plugin, for example:
  - the `mysql` plugin doesn't require any additional arguments
  - the `paths` plugin requires a list of paths

Note that all the backup configurations of a given period run all at once.
For example all the daily backup configurations run at the same time.

Backups are scheduled using cron jobs:

- daily: backups are tagged with the day's name, naturally rotating weekly
- weekly: backups are tagged with the day's number, running on day 7, 14, 21, 28 of every month, naturally rotating monthly
- monthly: backups are tagged with the month's name, naturally rotating yearly

That is, for every file (for example a database dump), you get 23 backups:

- 7 rotating daily backups (last 7 days)
- 4 rotating weekly backups (last 4 weeks)
- 12 rotating yearly backups (last 12 months)

The default crontab is something like this:

    # UNIQUE LABEL
    0 * * * * $PWD/backups.sh cron hourly
    15 0 * * * $PWD/backups.sh cron daily
    20 1 7,14,21,28 * * $PWD/backups.sh cron weekly
    35 1 1 * * $PWD/backups.sh cron monthly

You can install the default crontab with `./install.sh`.
To modify the timing edit the crontab directly with `crontab -e`.

Each cron job executes all the backup configurations that are relevant for the given period. A backup configuration may use any combination of periods. However, all configurations for a given period are triggered at the same time, and executed sequentially.

The backup configurations are managed by the `./backup.sh` script,
and should not be edited by hand.

Backup logic is implemented as plugins, so that new kind of backups can be added easily and independently from the rest of the logic, such as the rotating backup mechanism or configuration.

Currently supported plugins:

- mysql: backup mysql databases by running mysqldump and gzip the output
- paths: backup groups of files and directories as a gzip

Examples
--------

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

