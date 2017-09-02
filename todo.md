first release
-------------

- create crontab installer and uninstaller: install.sh
  - sub-module the existing scripts, don't reinvent the wheel
- add proper tests with multiple arguments in xoo
- manual test all supported plugins
- drop the TODO from the README, and make sure it all works as advertised

functionality
-------------

- add plugin help, triggered by -h appearing anywhere after plugin name; this is important, because it's not obvious what kind of parameters are required by mysql and files plugins
- add 'plugins' command so the interface is explorable
- add tests for 'sysinfo' command
- fix the fragilities of the cron command, harden with more tests
- make failure in summary red color to stand out
- complete all TODO
- add logging

framework improvements
----------------------

- create daily/monthly/weekly/hourly crontabs to reduce the workload of the cron command -- but maybe this is unnecessary complexity, the current slowness is probably not a big concern in practice
- store the periods in a more convenient format, for example space separated list of terms: daily weekly monthly hourly
  - the input format could stay the same, for easy processing and compact writing

design goals
------------

- organize backups by label, a slug, for example bashoneliners
- possible to add new kind of backup (db, files, dirs, web) without modifying base script
- default periods are daily, monthly, weekly, hourly
- do not dump a database 3 times just to create 3 different periods, dump once and reuse
