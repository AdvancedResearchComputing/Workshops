# "Symbolic Links"
[Previous Section > Logic and Math](./logic_and_math.md)
#### teaching: 10
#### exercises: 10
#### questions:
- "How can you reuse one file in multiple directories?"
- "How can you ease moving around your file system?"

#### objectives:
- "Detail symbolic links, and how they are used"
- "Learn when not to use symbolic links, and how to avoid pitfalls in using them."

#### keypoints:
- "Symbolic links to objects (files or directories) can be created using `ln -s`"
- "These are links to the object, not it's contents, so these can change or be deleted"
- "Symbolic links can cross physical disks, and so are useful in networked filesystems"
- "Caution must be exercised when following `..` paths across symbolic links"
- "They are most useful for linking to, and/or renaming, input and configuration files or directories"
- "Never use the flag `-r` with `rm` when removing a symbolic link to a directory; it can delete
the directory's contents."
---

A _symbolic link_, also called a _soft link_ or _symlink_,
is a pointer that enables you to reference another
file, much like a shortcut in Windows.
Like these it is useful for

- creating shortcuts within the file system,
- simplifying the file paths and names used by other programs,
- easing your navigation between different work directories in a networked system
(important when working on HPC systems),
- creating uniformity across filenames (e.g., when used by a program or script).

It is important to remember that symbolic links do not point directly to any data that might be in the target, they instead point to the file system itself.
This allows you to link to either files or directories using the same command, and also to link to filesystems
hosted on remote computers.
But it also means that there is a high risk of data loss if the
remote files are moved or deleted. Because of this it is recommended that you use them
sparingly in your workflows.

Also, note that you can do a lot of damage with symbolic links.
Perhaps the most egregious is that in deleting a symbolic link,
if you do it wrong, you can also delete the file to which the symbolic link points (in addition to the link itself).
So be careful.

### Format for Creating a Symbolic Link

To create a symbolic link to a file, the format is:

```bash
ln -s <data-file>  <name-of-link>
```

where `<data-file>` is the pre-existing file of information to which the link points, and `<name-of-link>` is the newly-created symbolic link.

To create a symbolic link to a directory, the format is:

```
ln -s <directory>  <name-of-link>
```

where `<directory>` is the pre-existing directory to which the link points, and `<name-of-link>` is the newly-created symbolic link pointing to the directory.


### Creating a Symbolic Link to a File

Our data file, _company.data_ contains:

```
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
```


We create a symbolic link to this file with command

```
ln -s company.data co.data.sl
```

where `co.data.sl` is the newly created symbolic link.

Assuming we started with a clean directory, invoking `ls -lrt` should give something like the following:

```
-rw-r--r-- 1 <owner-name> <owner-group> 462 Jul  1 11:04 company.data
lrwxrwxrwx 1 <owner-name> <owner-group>  12 Jul  1 11:05 co.data.sl -> company.data
```

We see that the symbolic link is shown, and in the same line, the file to which the link points; in this case, _company.data_.
That is, the delimiter ''->'' indicates a symbolic link.

Note that suffixing a symbolic link with `.sl` is __NOT__ standard.
We do it here only to make more clear the type of file it is.

Also, note in the permissions area of the second line, `lrwxrwxrwx`,
the first character is `l`, indicating that this file is a symlink.


Also, symbolic links pointing to files do not have to be in the same
directory as the file, as was the case above.

For example, referring to a file in a different directory is commonly done.

```
ln -s /home/<user-name>/dataGraphs/elderly.data   elderly.sl
```

The current directory (which can be obtained by typing `pwd`),
is where the symbolic link _elderly.sl_ will reside, and is presumably different from the directory where the file _elderly.data_ reside.

You might do this because you have data files spread across many directories, but a subset of data files are going to be used for a new project.
You can create, in one new directory for the new project, symbolic links to the data files in other directories.
This way, all data files for the project (in the form of
symbolic links) are in one place.


### Creating a Symbolic Link to a Directory

Let us create two new directories, both below the current directory, so that the second directory is at a relative depth of two.

We do these steps:

- `mkdir dir01`
- `cd dir01`
- `mkdir dir02`
- `cd dir02`

The directory dir02 should be empty. To see this, type `ls` and note no return information.

Now we will move up two directories using `cd ../..`
and create a symbolic link to directory dir02, using this command

```
ln -s     dir01/dir02/   dir.sl
```


Now issuing command `ls -lrt` one should get back
something like:

```
-rw-r--r-- 1 <owner-name> <owner-group> 462 Jul  1 11:04 company.data
lrwxrwxrwx 1 <owner-name> <owner-group>  12 Jul  1 11:05 co.data.sl -> company.data
drwxr-sr-x 3 <owner-name> <owner-group> 4096 Jul  1 11:33 dir01
lrwxrwxrwx 1 <owner-name> <owner-group>   12 Jul  1 11:34 dir.sl -> dir01/dir02/
```


We see that dir.sl points to a subdirectory ''dir02'' of
directory ''dir01'', as we intended.
''Normal'' files to not have ''->'' next to them.


### Ways to List Files in Directories

We looked at one way, above, to identify files that are symbolic links: to invoke `ls -lrt`.

Here, we identify another way.
First, though, we show a method that does NOT work.

If we merely list the files using `ls`, then there is no difference
between regular files and symbolic links.
We obtain this output

```
co.data.sl  company.data  dir01  dir.sl
```


We say that there is no distinction; in reality, there might be
because the color of files, on many systems, changes, depending
how configuration files are setup.

However, if we issue

```
ls -F
```

the `-F` flag tells the shell interpretor to
- append an `@` symbol to each symbolic link, and
- append an `/` symbol to each directory.
- all other files in this listing are standard data files.

Invoking the above command, the shell returns

```
co.data.sl@  company.data  dir01/  dir.sl@
```

and the `@` and `/` symbols are placed as expected.


### Warning About Using Symbolic Links With `cd ..`

We are going to give two sets of commands, and intuitively, one
might think that the two sets of commands should give the same results, but they do not.

From the starting directory of this episode (which is where
we should be), we issue this set of commands

```
cd dir.sl
pwd
cd ..
pwd
```


And we have the second set of commands, the only difference being
the `-P` option for the first `cd` command.


```
cd -P dir.sl
pwd
cd ..
pwd
```


Let us look at the responses from the shell interpretor.

In the first case, we get

```
/projects/kuhlman-project-storage/workshops/summer-2024/bash/symlinks/dir.sl
/projects/kuhlman-project-storage/workshops/summer-2024/bash/symlinks
```


In the second case, we get

```
/projects/kuhlman-project-storage/workshops/summer-2024/bash/symlinks/dir01/dir02
/projects/kuhlman-project-storage/workshops/summer-2024/bash/symlinks/dir01
```


Note that we end up in two different directories when comparing
the outputs from the two sets of commands.

This is because the `-P` option, in the second case, resolves
the symbolic link, taking us to to directory `/dir01/dir02`.
However, in the first case, `cd` (without `-P`) takes us to the "directory" `dir.sl`

So the upshot of this example is to be careful about how you
move around directories when some of the directories are
symbolic links.
And in particular, avoid using the up-one-directory operator `..`
in commands to change directories, like `cd ..`.


### Destroying Symbolic Links, But Not the Entities That They Point To

Almost without exception---really, without exception---if you want
to remove a symbolic link, then you do _NOT_ want to remove
the file that it points to.

(If you want to remove both the symbolic link and the data file,
best practices would dictate that you delete each separately.)

Consider this sequence of commands. where we copy the _company.data_
file to _data.to.delete_, create a symbolic link pointing to it,
and then deleting that link.

```
cp  company.data  data.to.delete
ln -s data.to.delete  delete.sl
ls -l
rm delete.sl
ls -l
```


These command produce this output.  Note that after removing (deleting) the symlink, the file _data.to.delete_ is still there.


```
total 5
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:05 co.data.sl -> company.data
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  1 11:04 company.data
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  2 08:32 data.to.delete
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   14 Jul  2 08:33 delete.sl -> data.to.delete
drwxr-sr-x 3 ckuhlman arc.kuhlman-project-storage 4096 Jul  1 11:33 dir01
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:34 dir.sl -> dir01/dir02/

total 4
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:05 co.data.sl -> company.data
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  1 11:04 company.data
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  2 08:32 data.to.delete
drwxr-sr-x 3 ckuhlman arc.kuhlman-project-storage 4096 Jul  1 11:33 dir01
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:34 dir.sl -> dir01/dir02/
```


Now we move to symbolic links of directories and the possible hazard of deleting symlinks incorrectly:  your files (not just the symlinks) will be erroneously deleted.

Here is a list of commands to create a new directory, put two files into it (each with the word ''hello''), create a symlink to the directory, and then various commands to delete the symlink---which can, when done incorrectly, delete the files in the directory.


```
mkdir dir_of_extras
cd dir_of_extras/
echo "hello" > extra01.dat
cp extra01.dat extra02.dat
ls
cd ..
ln -s dir_of_extras  my_dir_of_extras_sl
```

The command

```
rm my_dir_of_extras_sl
```

is safe:  it will remove the symlink and it will not alter "dir_of_extras" nor its contents.

However, the command

```
rm -r my_dir_of_extras_sl/
```

is _NOT_ safe. It will _NOT_ remove the symlink but it _WILL_ remove
the _contents_ of the directory "dir_of_extras"

This sequence of command is what you do _NOT_ want to do.

```
ls -lrt
ls dir_of_extras/
rm -r my_dir_of_extras_sl/
ls -lrt
ls dir_of_extras/
```


```
total 6
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  1 11:04 company.data
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:05 co.data.sl -> company.data
drwxr-sr-x 3 ckuhlman arc.kuhlman-project-storage 4096 Jul  1 11:33 dir01
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:34 dir.sl -> dir01/dir02/
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  2 08:32 data.to.delete
drwxr-sr-x 2 ckuhlman arc.kuhlman-project-storage 4096 Jul  2 09:02 dir_of_extras
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   13 Jul  2 09:07 my_dir_of_extras_sl -> dir_of_extras

extra01.dat  extra02.dat

rm: cannot remove 'my_dir_of_extras_sl/': Not a directory

total 6
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  1 11:04 company.data
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:05 co.data.sl -> company.data
drwxr-sr-x 3 ckuhlman arc.kuhlman-project-storage 4096 Jul  1 11:33 dir01
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   12 Jul  1 11:34 dir.sl -> dir01/dir02/
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  462 Jul  2 08:32 data.to.delete
lrwxrwxrwx 1 ckuhlman arc.kuhlman-project-storage   13 Jul  2 09:07 my_dir_of_extras_sl -> dir_of_extras
drwxr-sr-x 2 ckuhlman arc.kuhlman-project-storage 4096 Jul  2 09:08 dir_of_extras


```


The first `ls -lrt` shows our starting point.
The second command, `ls dir_of_extras/` show that there are two files in the directory, `extra01.dat extra02.dat`.
The attempt to remove the symlink `rm -r my_dir_of_extras_sl/` actually gives an error---that the symlink cannot be removed.
We confirm this with the second `ls -lrt` because the symlink `my_dir_of_extras_sl` still exists and points to the correct directory, _dir_of_extras_.
But when we repeat the `ls dir_of_extras`, note that there are no files in this directory---the `rm -r my_dir_of_extras_sl/` command
removed the two files, _extra01.dat_ and _extra02.dat_, from the directory.

Never use the `-r` flag with `rm` when removing a symlink.

