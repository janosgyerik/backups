todo
----

- separate the configuration needed by the framework and custom configuration of the plugins, for example:
  - the framework needs just periods for now
  - the path plugin will need path
  - the url plugin will need url
  - plugins should have the ability (and responsibility) to load/write their own custom config, though the framework could provide helper functions
  - the framework will provide WORK area where plugins can write whatever they want

- store the periods in a more convenient format, for example space separated list of terms: daily weekly monthly hourly
  - the input format could stay the same, for easy processing and compact writing

scripts
-------

- backup.sh: run all or selected backups, create selected milestones
- configure.sh: display and edit configuration

usage examples:

./configure.sh add bashoneliners mysql
./configure.sh add bashoneliners file path/to/sqlite3.db [-n sqlite]
./configure.sh list bashoneliners
./configure.sh list bashoneliners mysql

design goals
------------

- organize backups by label, a slug, for example bashoneliners
- possible to add new kind of backup (db, files, dirs, web) without modifying base script
- default periods are daily, monthly, weekly
    - possible to add hourly
    - possible to disable periods
- do not dump a database 3 times just to create 3 different periods, dump once and reuse

Usage: cron jobs:

0 * * * * backup.sh hourly
0 0 * * * backup.sh daily
0 1 7,14,21,28 * * backup.sh weekly
0 1 1 * * backup.sh monthly

Configuration:

- do not edit by hand, use configure.sh to display and to edit
- the directory layout indicates hierarchy
- the terminal nodes, files, are bash scripts with variable assingments

Configuration layout:

conf/
    project/
        mysql/
            db1
            db2
        file/
            label1
            label2

Backups:

backups/
    project/
        latest/
            mysql/
                db1
        daily/
            mysql/
                db1
        weekly/

modular: it should be possible to add new backup mechanisms without modifying the base script

usage example 1: invoke create-backups.sh with no params

- read configuration files and create all backups

usage example 2: invoke create-backups.sh with backup type

- read configuration of backup type and create backups of that type only

usage example 3: invoke create-backups.sh with backup type and target name

- read configuration of backup type and create specific backup

