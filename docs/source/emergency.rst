FTP Emergency Docs
==================

This doc will describe a variety of potential emergency situations we may run
into with the ftp cluster. Its mostly to be used as a potential guide in case
they happen.

FTP Array Failure
-----------------

In the eventual but hopefully unlikely event that an array of disks completely
fails due to too many disks failing, this might be what to do. This is much
easier to work around if the machine is one of the slaves (nyc/chi), however in
the case of ftp-osl going down it gets even more complicated.

ftp-osl failure
~~~~~~~~~~~~~~~

Some things to consider:

- This machine acts as master mirror for some projects
- All slaves sync from this host
- While we rebuild ftp-osl, all new syncs will likely be stopped to ensure data
  integrity

With this in mind, we have to consider a few list of actions. The TL;DR version
of what we should probably do is:

- Stop all cronjobs on all ftp hosts to mitigate any potential data loss (simply
  stopping cron is probably ok)
- Take ftp-osl out of DNS rotation
- Shutdown http/xinetd. We might want to restrict ssh access too 
- Notify the outage via hosting list and other methods (may even need a news
  post on our website)
- Ensure the integrity of the data on the other two slave machines for the same
  partition (basically make sure each repo is the same size or close to it)
- Designate which slave to use to re-copy data back to ftp-osl, likely chi but
  nyc might be faster
- Rebuild the disk array and mkfs.xfs it, etc. It's probably easier to just
  recreate the array at that point
- Start an rsync from slave node (this will likely take DAYS depending on the
  load and such).
- Ensure everything looks sane
- Re-enable cronjobs and do some tests
- Add back into rotation
- Send out another announcement
