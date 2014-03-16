Adding a new Project
====================

Synopsis
--------

Adds a new project mirror to our ftp infrastructure

Intro/Background/Info
---------------------

Mirroring projects is fun and easy

Detailed Procedure
------------------

First, choose which array to put the project:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- We have two arrays: /data/ftp/.1 and /data/ftp/.2
- Make sure there is enough disk space for your project
- If you expect the project to use a lot of bandwidth, put it on the less used
  array (look at iostat)

In cfengine
~~~~~~~~~~~

For local master (account on ftp-osl to upload files):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- add trigger permissions in cf.mirror::
  
  /data/trigger/set/$project mode=2775 owner=$project group=trigger
- add ``files/data/mirror/bin/update-master/$project``:

.. code-block:: bash

    #!/bin/bash

    echo "We are master"

For remote mirrors (update via rsync):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- add project cronjob to ``files/etc/cron.d/mirror/update.master``
- add rsync line to ``files/data/mirror/bin/update-master/$project``:

.. code-block:: bash

    #!/bin/bash

    rsync -avH --delete projecthost::module/ /data/ftp/.$array/$project/

For all mirrors:
^^^^^^^^^^^^^^^^

- add symlink in cf.mirror::
  
  /data/ftp/pub/$project -> /data/ftp/.1/$project 

- if wanted, add vhost config:
  ``files/etc/apache2/vhosts.d/mirror/$project.osuosl.org.conf``
- commit

On ftp-osl
~~~~~~~~~~

For local master:
^^^^^^^^^^^^^^^^^

.. code-block:: bash

    useradd -m $project
    mkdir /data/ftp/.$array/$project
    chown $project:$project /data/ftp/.$array/$project
    ln -sf /data/ftp/pub/$project /home/$project/data
    
- put ssh keys in /home/$project/.ssh/authorized_keys
- add trigger script /home/$project/trigger-$project

.. code-block:: bash

    #!/bin/bash

    /data/mirror/bin/trigger-set $project

- add ``/home/$project/README``

::

    Your data is in /data/ftp/.$array/$project/
    The symlink "data" links there for your convenience.

    To signal the server to push your data to the other servers, run the
    trigger-$project script.

For remote mirror:
^^^^^^^^^^^^^^^^^^

- after committing/pushing changes in git, run ``cfexecd -F -q``
- run the update script ``/data/mirror/bin/run-update <project> --email``
  - this will sync the project, and trigger the slaves to sync with the master

On ftp-{osl,nyc,chi}
~~~~~~~~~~~~~~~~~~~~
- mkdir ``/data/ftp/.$array/$project``
- run ``cfexecd -F -q``
- reload apache, ``/etc/init.d/apache2 reload``

Email message
~~~~~~~~~~~~~

You should now be able to ssh to ftp-osl.osuosl.org with the username $project
and the key that you provided. See the README file in your home directory on
that server for instructions on how to upload files. 

