The repository tree and content
===============================

.. sourcecode:: bash

        ├── apache
        ├── bin
        ├── conf.d
        ├── cron.d
        ├── docs
        ├── etc
        ├── etc.master
        ├── etc.slave
        ├── ftpsync
        ├── init.d
        ├── LICENSE
        ├── local.start
        ├── local.stop
        ├── mirror-stats
        ├── README.rst
        ├── requirements.txt
        ├── rsync
        ├── sbin.mirror
        ├── venv
        ├── www
        └── xinetd



apache
    This consits of all the apache configuration files which shall reside in
    /etc/apache2 directory of the master.

bin
    This directory consists of update-master/$project scripts that are
    responsible for updating the master when new content available at the
    primary mirors of these projects. There are also other useful scripts
    written in bash and python to check file sizes.

rsync
    Consists of the rsync daemon configuration file for ftp hosts.
    The rsync daemon runs on the master and is repsonsible providng a service to
    the ftp hosts to sync from it.

cron.d
    Defines the crontab entries that are responsible for periodically running
    scripts defined in other directories. This includes periodic tasks like
    updating master and slaves.

mirror-stats
    Contains scripts useful for generating various mirror statistics like pie
    charts showing sync status, disk space, etc

sbin-mirror
    Useful scripts that will be run only by a root user on the master. Scripts
    are used for hash checks, generate hit statistics, etc.

xinetd
    Here we add rsync as a service and provide location of the rsync
    configuration files. Currently there are 2 rsync services that run on
    different ports each having its own configuration file "rsync" and
    "rsync-osl". The first one is for running a public rsync service with limits
    on the number of instances so that people can't DoS the rsync service. This
    restriction is not imposed by the latter.

