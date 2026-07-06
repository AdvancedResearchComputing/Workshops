
---

⬅️ [Previous: File and directory ownership](05_file_ownership.md) | [Next: Best practices ➡️](07_best_practices.md)

## Data Recovery and Long-Term Storage


### Backups of Your Data

> [!NOTE]
> ARC provides zero backups for your data.

> [!NOTE]
> It is your responsibility to back up your data.


This policy is NOT because ARC does not care about your data.

The reason is that it is prohibitively costly to purchase the
hardware and put into place a system that will back up 
cluster data.

### ARC Provides a Service of Last Resort

> [!NOTE]
> This service is not guaranteed to last into the future.

> [!NOTE]
> It is not a subsitute for you backing up your data.

1. Very limited backups of some data are made.
2. The frequency of backups are generated like an
   “exponential backoff” algorithm, i.e., more backups
   near “now” and far fewer as you go back in time.
3. To see snapshots—--for your `$HOME` area, not `/projects`
   - `cd  ~/.snapshot`        # This will NOT tab complete.
   - `ls -l`                  # Will show the snapshots saved.
4. You might find under some date directory a version (perhaps not the 
   latest version) of a file that is missing.

If you have a lost file(s) problem, then please enter a help ticket at [www.arc.vt.edu/help](www.arc.vt.edu/help) and click on “Request this service.”


### Archiving Service

This is long-term storage for data that you will not need to access for a year or more, but need to keep.

The process involves significant reading and writing so it is
not a service fit for regular/frequent data access.

There is a charge for this service.

Please enter a help ticket at [www.arc.vt.edu/help](www.arc.vt.edu/help ) and click on “Request this service” and specify your need.


---

⬅️ [Previous: File and directory ownership](05_file_ownership.md) | [Next: Best practices ➡️](07_best_practices.md)
