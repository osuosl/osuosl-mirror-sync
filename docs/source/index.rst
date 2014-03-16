.. _ftp-infrastructure:

FTP Infrastructure
==================

.. toctree::
  :maxdepth: 1
  :glob:

  *

Summary
-------

The FTP mirrors are fairly complex, especially when it comes to the way data is
kept in sync and monitored. There are many scripts that are scattered about that
makes the magic happen. Hopefully this documentation reveals the truth behind
the magic.

Introduction
------------

The nature of our system allows some flexibility to the services that we can
offer. We can serve as the master mirror for small projects, but also as a part
of a large project's mirror infrastructure. Each set of data is referred to as a
'tree'; each project may have one or more trees.

.. note::

  This project has been tightly integrated into the OSL mirror infrastructure
  and has a lot of hard coded references to hosts, paths and other bits.

Installation
------------

As it stands now, the system is currently deployed using the OSL internal
CFEngine configuration management system. Documentation will be updated to
reflect how it should be installed externally.

Most of the files reside in ``/data/mirror`` on the nodes while some scripts are
located in ``/usr/local/sbin``. In addition there are other services such as
xinetd, bwbar, etc that need to be configured outside these directories or the
current repository.

Hardware
--------

Currently there are three servers in the system:

- ftp-osl

  - Located in Corvallis, OR
  - Master mirror
  - HP Proliant DL385 G5 server
  - 8G RAM
  - Two data arrays

    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS
    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS
- ftp-chi

  - Located in Chicago, IL, courtesy of TDS
  - Slave mirror
  - HP Proliant DL385 G5 server
  - 8G RAM
  - Two data arrays

    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS
    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS
- ftp-nyc

  - Located in New York, NY, courtesy of TDS
  - Slave mirror
  - HP Proliant DL385 G5 server
  - 8G RAM

    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS
    - 3T (RAID 6 + spare) msa70 25x 146G 2.5" SAS

Software
--------

The scripts used to manage the servers fall into several categories:

- Sync from upstream.
- Sync from the master mirror to the slaves.
- Control distribution of downloads.
- Gather statistics on the status of the data.

External Links
--------------

.. note::

  Some of these links are restricted to OSL only networks currently.

- `Mirror Sync Status`_: The sync status of every tree on each mirror.
- `Mirror Tree Sizes`_: The size of every tree.  Used to monitor changes in
  array usage.
- `FTP Map`_: A graphical overview of the bandwidth usage of each server.
- `Awstats`_: Some projects have stats compiled for downloads of their software
  hosted by us.

.. _Mirror Sync Status: http://log.osuosl.org/
.. _Mirror Tree Sizes: http://log.osuosl.org/size/
.. _FTP Map: http://ftpmap.osuosl.org/
.. _Awstats: https://awstats.osuosl.org/
