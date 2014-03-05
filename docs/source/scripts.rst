FTP Scripts
===========

Summary
-------

This page is part of the :ref:`ftp-infrastructure` documentation. Please visit
that page for an overview.

There are five categories of scripts:

- :ref:`sync-data-from-upstream`
- :ref:`sync-between-master-slave`
- :ref:`control-downloads`
- :ref:`gather-stats`
- :ref:`ftpsync`

Each is explained here.

Types of scripts
----------------

.. _sync-data-from-upstream:

Sync Data from Upstream
~~~~~~~~~~~~~~~~~~~~~~~
- ``/data/mirror/bin/run-update``

  - Wrapper for scripts to sync and lock.
  - If you need to force an update to a specific project, please do the
    following on ftp-osl:

.. code-block:: bash

    $ /data/mirror/bin/run-update <project name> --email

- ``/data/mirror/bin/update-master/*``

  - Run by ``run-update`` to actually sync the data for each tree.
  - Should not be run manually (use ``run-update`` instead).

.. _sync-between-master-slave:

Sync Between Master and Slave
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This system of triggering runs on a cron job once per minute, so in theory
changes to ftp-osl are propagated very quickly out to the other ftp servers.

- ``/data/mirror/bin/run-update``
  - Same use as for pulling from upstream, but pulls from master.
- ``/data/mirror/bin/trigger-set``

  - Puts a trigger file in ``/data/trigger/set/tree_name/`` on master.
  - The trigger indicates that the master is up-to-date and the slaves can begin
    pulling data.
- ``/data/mirror/bin/trigger-run``

  - Used by the slave servers to check for new triggers set on the master.
  - If it tries to remove a trigger that has already been removed, will send an
    error e-mail. It is safe to ignore this e-mail unless a deluge of errors
    occurs. Network latency is usually the cause.
- ``/data/mirror/bin/trigger-scan``

  - Copies set triggers from master to slaves.
- ``/usr/local/sbin/mkchroot``

  - Creates and sets up chroot used by trigger system.

.. _control-downloads:

Control Downloads
~~~~~~~~~~~~~~~~~

- ``/usr/local/sbin/i2-check``

  - Check if a particular IP address is on the I2 list.
- ``/usr/local/sbin/i2-check.pl``

  - A much faster version of the bash script.
- ``/usr/local/sbin/i2-fill``

  - Update the mysql database of IP addresses from the I2 list.
- ``/usr/local/sbin/ip*``

  - Manage temporary iptables blacklist.
  - Accepts any number of IPs/netblocks as arguments.
  - Only affects local box.
  - Won't affect normal firewall; uses mangle table.

.. _gather-stats:

Gather Statistics
~~~~~~~~~~~~~~~~~
- ``/data/mirror/bin/check-size``

  - Goes through trees to find size of each.
  - Info stored in a log file, processed by fir.
- ``/data/mirror/bin/gen-header``

  - Run manually to update fancy header used on http indexes.
  - Since the output files are in cfengine, need to update those files at the
    same time.
- ``/data/mirror/bin/gen-footer``

  - Run every minute to update bandwidth bar.
- ``/usr/local/sbin/check-apt-mirror``

  - Runs md5sum on every package in specified ubuntu or debian tree.
  - Takes about half a day to run.
- ``/usr/local/sbin/logs-*`` *Deprecated??*

  - Manage apache and ftp logs instead of using logrotate
  - Run by cron jobs.

.. _ftpsync:

ftpsync
~~~~~~~
- ``/data/mirror/ftpsync/bin/ftpsync``

  - syncs files with a 2-stage sync to avoid breaking 
- ``/data/mirror/ftpsync/bin/runmirrors``

  - triggers slaves
- ``/data/mirror/etc/ftpsync-$project.conf``

  - config file for ftpsync to sync ``$project``
- ``/data/mirror/etc/runmirrors-$project.conf``

  - config file for runmirrors to push ``$project``
- ``/data/mirror/etc/$project.mirror``

  - config file listing slaves to push
- see http://www.debian.org/mirror/push_mirroring for more info
