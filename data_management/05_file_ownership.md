
---

⬅️ [Previous: umask](04_umask.md) | [Next: Data recovery and long-term storage ➡️](06_data_recovery_long_term_storage.md)


## File and Directory Ownership

### File and Directory Individual Ownership

You will rarely, if ever, in your life time, change the individual
ownership of a file.
And if you do, you are almost guaranteed to be a system administrator.

We give the command here with no further comment:

`chown  <username-of-new-owner>  <file or directory name>`


### File and Directory Group Ownership

A common use case for a need to change group ownership
of a file or directory is if you
are in multiple groups and you have a file that you created as
part of one group, and you want to now use that file
as part of a second group.

In this case, you may want the name of the second group as the
new group owner.

The command is:

`chgrp  <name-of-new-group-to-own> <file or directory name>`

You only have a finite number of choices for `<name-of-new-group-to-own>` and these choices are the 
groups in which you currently reside.

To list the groups to which you belong,
enter either of these commands:
1. `id`
2. `groups`

Please choose one of the groups to use in the `chgrp` command above.




---

⬅️ [Previous: umask](04_umask.md) | [Next: Data recovery and long-term storage ➡️](06_data_recovery_long_term_storage.md)

