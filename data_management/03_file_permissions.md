## File and Directory Permissions

---

⬅️ [Previous: File systems](02_file_systems.md) | [Next: umask ➡️](04_umask.md)


### High Level Summary of Permissions for Student-Advisor Interactions

A student has an advisor.
An advisor is also known within ARC as a PI.
The steps are written for the perspective of the student,
in relation to their advisor.
The steps are also written from the perspective of
a student doing work under her/his professor's account.
This account is under `/projects/<PIs-account>`.

1. You (a student) have control over who can access your files,
   and directories, up to a point.
   The point is that your advisor can
   access your files and directories created under her/his projects.
   - Access can mean any combination of:
     - see that the file exists.
     - view contents of file.
     - alter contents of file.
     - run or execute contents of file.
2. Permissions across ARC on files and directories
   are now set up to enable a student and their advisor
   to see student files.  (There are still some older
   files where this is not the case, but for the most
   part ...)
     - This is done so that an advisor has access to 
       her/his students' files.
     - Default file and directory permissions are:
        - directory permissions:  770
          - A student's directory can be (1) viewed,
            (2) written to (i.e.,
            create new files/directories and
            modify/delete existing ones), and
            (3) can execute appropriate files inside
            of the directory by ...
            - Student
            - Advisor/group (i.e., the PI's project)
          - No one outside of the PI's (advisor's) group
            has any access to the files. 
        - file permissions: 660
          - A student's file can be (1) read, and
            (2) written to (i.e., modified) by ...
            - Student
            - Advisor/group
          - No one outside of the PI's (advisor's) group
            has any access to the file. 


## Permissions Fundamentals

### Actions You May Have Permissions For

There is one permission value (i.e., yes, you have permission,
or no, you do not have permission) for each of the actions:
1. read:  you can/cannot read the contents of a file.
2. write:  you can/cannot modify the file by altering its content.
3. execute:  you can/cannot execute the file.

These actions are straight-forward conceptually for a file.

But for directories, it can cause confusion.
It is best to think of directories as files;
files that contain other files, directories, and symlinks.

With this in mind, the three actions for directories are:
1. read:  you can/cannot read the contents of a directory (e.g., names of files, directories,
   symlinks).
2. write:  you can/cannot add and delete files.
3. execute:  you can enter a directory and access metadata.  You can alter files per file permissions.
   -  If you do not have `x` (execute permission), then you cannot access the
      files in it, even if you have r + w permissions on files therein.



### An Action's Permission

That action's permission can be observed (on files and
directories that you have access to)
and are denoted by the following:
1. if permission is granted (we say that "the permission is set"),
   - the permission on read is "r."
   - the permission on write is "w."
   - the permission on execute is "x."
2. if the permission is not granted (we say that "the permission is not set"),
   - the permission on each of read, write, and execute is "-."

So far in this section, we are explaining the permissions in terms
of the text that you will see associated with files and 
directories when you "long list" them, i.e., use the command:
`ls -l <file-name>`

But there is another way to look at actions and their permissions---as a binary bit.
If a bit for read, write, or execute is "set," then the 
bit has value 1.
If a bit for read, write, or execute is "unset" (i.e., not set),
then the bit has value 0.

We will both structures for examining permissions below.

### Permission Classes

In the previous two sections, we spoke about actions and whether
permission is granted to perform that action.

Each action is either granted or not granted permission for
three permission classes:
1. user:  typically the user that created the file.
2. group:  typically the name of the PI's project under which the
   student is working.
3. other:  everyone else (that is the user or in the group).

## Putting These Ideas Together

### Permissions

Let us assume that you have a file _trial01.txt_ that you created
under your advisor's project.
Let us assume that your user ID is "mharvey" and that you work
for professor Smart.
Professor Smart's project name is "genomics-01."

If you issue the command `ls -lrt trial01.txt` then you might see:

```
-rw-rw---- 2 mharvey genomics-01 322  Mar 15 15:32  trial01.txt
```

Starting from left, you see `-rw-rw----`.
We break this down as follows.

1. The first `-` (to the left of the first `rw`) means that
   _trial01.txt is a file.
   - If instead of `-`, there was `d`, then trial01.txt is a 
     directory.
   - If instead of `-`, there was `l`, then trial01.txt is a 
     symbolic link.
2. The next three characters are the user permissions.
   - `rw-` means that the user can read (`r`) the file,
     can write (`w`) to the file (i.e., modify it), 
     but cannot execute (`x`) it.
   - Based on our description above, since read and write are set,
     we see `r` and `w`, but since execute is unset we see `-`.
3. The next three characters are the group permissions.
   - `rw-` means that the group members can read (`r`) the file,
     can write (`w`) to the file (i.e., modify it), 
     but cannot execute (`x`) it.
   - Based on our description above, since read and write are set,
     we see `r` and `w`, but since execute is unset we see `-`.
   - Note that for this file, the user and group permissions are 
     the same.
4. The final three characters are the other permissions.
   - `---`, i.e., three consecutive `-`, means that other
     (i.e., all users that are not the user nor in the group)
     have no permissions.
   - Each of the read, write, and execute permissions are
     unset.


This description here corresponds exactly with the default
permissions for a file that you create under your advisor's project,
as described above.

### Everything Else on the Line

Continuing on the line, the individual owner is mharvey and the
group owner is genomics-01, the size of the file "trial-01.txt" is
322 bytes, and date/time of last file modification is 15 March at time 15:32.

The name of the file (or directory or symbolic link) is the last
entry on the line.

### Summary Integer of Permissions of Permission Class

The combinations of read, write, and execute for one permission
class (each value read, write, or execute being set or unset) give rise a unique mapping from the permission to an integer in [0, 7].

The table below gives this mapping.

|  Read Bit  |  Write Bit |  Execute Bit | Integer |
| ---------  |   ------   |    --------  |  ------ |
|    0       |    0       |      0       |    0    |
|    0       |    0       |      1       |    1    |
|    0       |    1       |      0       |    2    |
|    0       |    1       |      1       |    3    |
|    1       |    0       |      0       |    4    |
|    1       |    0       |      1       |    5    |
|    1       |    1       |      0       |    6    |
|    1       |    1       |      1       |    7    |

For example, if we give permissions of read and write, but
not execute, then the integer that summarizes these read,
write, and execute permissions of one permission class is 6.

Using the table above, and noting that permission classes are
always in the order of user, group, and other, then 
if we are given for one file that:
1. a user can read, write to, and execute the file.
2. the group can read and execute the file.
3. other can only execute the file.

Then the integer value, from the table above,
for the three permission classes are:
1. user:  7
2. group: 5
3. other: 1

The complete specification of the permissions on this file are:  751.

## Common Cases

There are sets of permissions that most commonly arise
when setting them for files and directories.

### File Permissions

|  Permissions  |  File |  Meaning    |
| ---------  |   ------   |    --------   |
|    660     |    F       |      User and group have access to read all file content and to modify the file.  Other has no accessibility. |
|    664       |    F       |     The same as the previous example, but now others have the ability to read the contents of files.   |

Question:  What are the permissions for user to read and write,
and the group and other to each read a file?

Answer:  644.



##### Directory Permissions

|  Permissions  |  Directory |  Meaning    |
| ---------  |   ------   |    --------   |
|    770     |    D       |      User and group have full access to all items (files, directories, symlinks) in the directory.  Other has no accessibility. |
|    750       |    D       |     User has full access (i.e., can create, modify, and execute all items (files, directories, symlinks) in the directory.  Group members can read and execute files in the directory and can list contents of and enter subdirectories.  Other has no accessibility.   |


## Changing Permissions


The command is `chmod <permissions>   <file or directory name>`

#### Example  Change the Permission on a Directory

We want to change the permissions on a directory _reptiles_ to 750
(see the most recent table for the meaning).
The command is `chmod 750 reptiles`


#### Example  Change the Permission on a File

We want to change the permissions on a file _salamander_ to 644
(see the most recent table for the meaning).
The command is `chmod 644 salamader`


#### Note

After executing the `chmod` command, follow that up with the 
command `ls -l <file or directory name>` to see/confirm the resulting
permissions.


---

⬅️ [Previous: File systems](02_file_systems.md) | [Next: umask ➡️](04_umask.md)