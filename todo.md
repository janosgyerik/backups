functionality
-------------

- fix all "unbound variable" errors, for example: ./backups.sh add
  - need a systematic fix, there are too many possible occurrences
- add proper tests with multiple arguments in xoo
- add 'plugins' command so the interface is explorable
- add tests for 'sysinfo' command
- use a simple loop to parse `-h`, no need for the usual parameter array
  - and no need to make the -h depend on the command
- write readme with usage examples
- fix the fragilities of the cron command, harden with more tests
- mysql plugin
- create crontab installer and uninstaller
  - sub-module the existing scripts, don't reinvent the wheel
- make failure in summary red color to stand out
- complete all TODO

framework improvements
----------------------

- store the periods in a more convenient format, for example space separated list of terms: daily weekly monthly hourly
  - the input format could stay the same, for easy processing and compact writing

scripts
-------

- backups.sh: main script to manage backups (configure, schedule, list)
- run-tests.sh: run self-tests

Usage examples:

    ./backups.sh add mysql bashoneliners dwm
    ./backups.sh add files bashoneliners dwm path/to/sqlite3.db
    ./backups.sh config mysql bashoneliners
    ./backups.sh config mysql
    ./backups.sh list mysql bashoneliners
    ./backups.sh list mysql

design goals
------------

- organize backups by label, a slug, for example bashoneliners
- possible to add new kind of backup (db, files, dirs, web) without modifying base script
- default periods are daily, monthly, weekly, hourly
- do not dump a database 3 times just to create 3 different periods, dump once and reuse

Usage: cron jobs:

    0 * * * * backups.sh cron hourly
    15 0 * * * backups.sh cron daily
    20 1 7,14,21,28 * * backups.sh cron weekly
    35 1 1 * * backups.sh cron monthly

Configuration:

- Use the 'config' command to display configuration
- Use the 'update' to modify the configuration
