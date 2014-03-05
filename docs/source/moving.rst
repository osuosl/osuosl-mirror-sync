Moving projects to a different array
====================================

Copy the files to the new array on the slave servers

.. code-block:: bash

    rsync -av /data/ftp/.$old_array/$project/ /data/ftp/.$new_array/$project/
    ln -sf ../.$new_array/$project /data/ftp/pub/$project
    rm -rf /data/ftp/.$old_array/$project/

Copy the files to the new array on ftp-osl

.. code-block:: bash

    rsync -av /data/ftp/.$old_array/$project/ /data/ftp/.$new_array/$project/
    ln -sf ../.$new_array/$project /data/ftp/pub/$project
    rm -rf /data/ftp/.$old_array/$project/

Change update-master sync script to sync to the new location, and update
symlinks in cfengine

.. code-block:: bash

    vi infra/files/data/mirror/bin/update-master/$project
    vi infra/cfengine/inputs/cf.mirror

