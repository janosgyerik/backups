first release
-------------

- add proper tests with multiple arguments in xoo
- create crontab installer and uninstaller: install.sh
  - sub-module the existing scripts, don't reinvent the wheel
- drop the TODO from the README, and make sure it all works as advertised

functionality
-------------

- add plugin help, triggered by -h appearing anywhere after plugin name
- add 'plugins' command so the interface is explorable
- add tests for 'sysinfo' command
- fix the fragilities of the cron command, harden with more tests
- mysql plugin
- make failure in summary red color to stand out
- complete all TODO

framework improvements
----------------------

- store the periods in a more convenient format, for example space separated list of terms: daily weekly monthly hourly
  - the input format could stay the same, for easy processing and compact writing

design goals
------------

- organize backups by label, a slug, for example bashoneliners
- possible to add new kind of backup (db, files, dirs, web) without modifying base script
- default periods are daily, monthly, weekly, hourly
- do not dump a database 3 times just to create 3 different periods, dump once and reuse
