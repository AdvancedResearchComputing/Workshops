# Data Transfer and Sharing on ARC

March 9, 2026

Nicole Braunscheidel\
Computational Scientist (ARC)\
Email: nbraunsc@vt.edu

## Logistics
Feedback form: [https://forms.gle/NK3AiVxMLbintCJT8](https://forms.gle/NK3AiVxMLbintCJT8)

General Comments:
- Informal workshop so please feel free to interrupt me or use the chat for questions!
- You can also access the material here: [https://github.com/AdvancedResearchComputing/Workshops/blob/main/Data_Transfer_and_Sharing.md](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Data_Transfer_and_Sharing.md)
- We have a lot of short video tutorials (I will eventually record this workshop without attendees): [https://docs.arc.vt.edu/usage/video.html#video](https://docs.arc.vt.edu/usage/video.html#video)
- If you want to follow along, make sure you are connected to VT network (VPN if off campus) and have an ARC account

Useful links:
- ARC's documentation site: [https://docs.arc.vt.edu/](https://docs.arc.vt.edu/)
- GitHub Examples: [https://github.com/AdvancedResearchComputing/examples](https://github.com/AdvancedResearchComputing/examples)
- Office Hours: [https://arc.vt.edu/about/office-hours.html](https://arc.vt.edu/about/office-hours.html)
- 4Help: [https://arc.vt.edu/help](https://arc.vt.edu/help)
- Data Transfer: https://docs.arc.vt.edu/usage/data_transfer.html

## Outline of this Workshop
1. [Transfer Tools](#transfer-tools) (internally, local <-> remote, Globus)
2. [Tar and Compression Tools](#tar-and-compression-tools) (tar, compression/zip)
3. [File Management via IDE](#file-management-via-ide) (vs code, OOD)

# Transfer Tools
ARC resources are a remote host so you need additional tools to move, copy, delete files. You can think of ARC systems as another computer so you will have to move your files or code to that "computer" in order to run them on ARC. 

Some terminalogy:
- local: refers to your personal computer
- remote: refers to ARC systems
- internal: refers to files on the same computer/machine/system
- external to VT: refers to computers outside of Virginia Tech's network

## Handling files internally
There are two main tools we use to move or copy files that are on ARC. Both of this tools work in a similar fashion with the first argument defines what/where that file is and the second argument defines the where/what do you want to name the "new" file.

### Copy or `cp`

To copy files either in the same folder/directory or to copy files to another directory, you can use the `cp` or copy command.

`cp` – “copy” makes a copy of a file. Now you have two!

If you want to copy a file to a new location, you will use the following command if you are currently in the directory of that file:
```
cp <original_file> <path_to_new_location>
```
If you want to copy a file from a different location into your current working directory, use the following:
```
cp <path_to_file/name_of_file> .
```
The period `.` is telling `cp` to copy that original file to the current directory (i.e. copy right here). 

If you want to copy a file in the same directory, you will use the following command and will have to provide a new name for the copied file:
```
cp <original_file> <new_name_of_file>
```

### Move or `mv`
If you don't want a copy of that file, you can use the move `mv` command. This works in a similar way as `cp` but will move that file to the location you request:

```
mv <original_file> <new_file_location>
```

Move `mv` can also be used to rename a file so be extra careful!
```
mv <orginial_filename> <new_filename>
```
The move `mv` command is not recommended for the following case:
- transferring between two filesystems (risky!)
- transferring data to /scratch (mv preserves timestamps!)
- transferring data to /projects (mv preserves group ID and permissions modes)

## File transfers between internal and remote
You will use the following file transfer tools when you want to transfer files between your local computer and our remote ARC computers.

### Secure Copy or `scp`
To transfer files or directories between local computer and remote cluster (ARC), you can use the secure copy or `scp` command.

Most often executed on a personal computer to push data to or pull data from ARC systems

```
scp <source> <destination>
```

Example:
```
nicole@MacBook-Pro-3:~/Old Drive/code/demo$ ls
Manifest.toml Project.toml  src
nicole@MacBook-Pro-3:~/Old Drive/code/demo$ scp Project.toml nbraunsc@tinkercliffs1.arc.vt.edu:/home/nbraunsc/workshops/data_transfer
Project.toml                                                  100%  511    13.3KB/s   00:00
```

You can also use `scp` for directories using the `-r` flag which tells `scp` to do the copy recursively
```
nicole@MacBook-Pro-3:~/Old Drive/code$ scp -r demo/ nbraunsc@tinkercliffs1.arc.vt.edu:/home/nbraunsc/workshops/data_transfer
Manifest.toml                                                 100%   49KB 417.4KB/s   00:00
Project.toml                                                  100%  511    13.3KB/s   00:00
demo.jl                                                       100%   59     1.5KB/s   00:00
happy.txt                                                     100%   25     0.6KB/s   00:00
```

### `rsync`
Another tool is called `rsync` that can do local ↔ remote or remote ↔ remote.

```
rsync <flags> <source> <destination>
```

Flags:
- `-a` or `--archive`: Archive mode, this is the most common flag, preserving symbolic links, permissions, modification times, groups, and owners.
- `-v` or `--verbose`: Increases verbosity, showing more detail about the files being transferred.
- `-z` or `--compress`: Compresses file data during the transfer, useful for slower network connections.
- `-h` or `--human-readable`: Outputs numbers in a human-readable format (e.g., KB, MB).
- `-P`: A combination of `--partial` (allows resuming interrupted transfers) and --progress (displays a progress bar for each file)

Note: Avoid “-a” option when copying data to /scratch or /projects (”-a” preserves timestamps, GIDs, and modes)

`rsync` can also be used to synchronize outdated copies. So sometimes within a batch job for example, you can have an rsync runnning that will synchronize output data between two different locations like /scratch and /home.

Example with no `/` after directory name:
```
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ rsync -avh nbraunsc@tinkercliffs1.arc.vt.edu:/home/nbraunsc/workshops/data_transfer .
Transfer starting: 9 files
data_transfer/
data_transfer/happy.txt
data_transfer/hello_world.txt
data_transfer/demo/
data_transfer/demo/Manifest.toml
data_transfer/demo/Project.toml
data_transfer/demo/src/
data_transfer/demo/src/demo.jl
data_transfer/demo/src/happy.txt

sent 166 bytes  received 51064 bytes  512M bytes/sec
total size is 50479  speedup is 0.99
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ ls
data_transfer
```

Example with a `/` after source directory name copies all contents but not the top level directory:
```
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ rsync -avh nbraunsc@tinkercliffs1.arc.vt.edu:/home/nbraunsc/workshops/data_transfer/ .
Transfer starting: 9 files
./
happy.txt
hello_world.txt
demo/
demo/Manifest.toml
demo/Project.toml
demo/src/
demo/src/demo.jl
demo/src/happy.txt

sent 166 bytes  received 51049 bytes  512M bytes/sec
total size is 50479  speedup is 0.99
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ ls
demo            happy.txt       hello_world.txt
```

Example with only the `-a` flag:
```
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ rsync -a nbraunsc@tinkercliffs1.arc.vt.edu:/home/nbraunsc/workshops/data_transfer .
nicole@MacBook-Pro-3:~/Old Drive/code/demo/rsync_demo$ ls
data_transfer
```

### `rclone`
`rclone` is another great tool when you want to transfer files from a storage server or cloud storage to ARC. One current workflow is to use our Remote Desktop application on Open OnDemand (ood.arc.vt.edu)

First you will have to load the module:
```
module load rclone
```
Then start the configuration of the transfer
```
rclone config
```

```
nbraunsc@tinkercliffs1:~/workshops/data_transfer$ rclone config
2026/03/08 15:37:41 NOTICE: Config file "/home/nbraunsc/.config/rclone/rclone.conf" not found - using defaults
No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

Enter name for new remote.
name> metafaces

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
 1 / 1Fichier
   \ (fichier)
 2 / Akamai NetStorage
   \ (netstorage)
 3 / Alias for an existing remote
   \ (alias)
...
19 / Google Drive
   \ (drive)

Storage> 19

Use web browser to automatically authenticate rclone with remote?
 * Say Y if the machine running rclone has a web browser you can use
 * Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.

y) Yes (default)
n) No
y/n> y
2026/03/08 15:50:38 NOTICE: If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth?state=IWwJdUjLOsY9ppP_l7EZOA
2026/03/08 15:50:38 NOTICE: Log in and authorize rclone for access
2026/03/08 15:50:38 NOTICE: Waiting for code...
```

At this point copy the url, open Firefox in the remote desktop, and paste url in browser.

Then go back to the rclone in the terminal:
```
Y/n> n
Y/e/d> y
/n/d/r/c/s/q> q
```
To get a list of files:
```
rclone ls metfaces:
```

To copy those files to the current working directory:
```
rclone copy metfaces: ./
```

# Globus
Globus is an infrastructure designed for managing data, potentially among multiple institutions. [https://docs.arc.vt.edu/software/globus.html#globus](https://docs.arc.vt.edu/software/globus.html#globus)

At Virginia Tech, ARC maintains an institutional Globus Subscription and hosts a Globus Connect Server (GCS) which provides a Globus endpoint for ARC’s /projects directories. Among other features, Globus provides fault tolerance for (large) data transfers.

VT has subscribed to the High Assurance tier to help enable the transfer of Protected Health Information (PHI), Personally Identifiable Information (PII), and Controlled Unclassified Information (CUI) data. This allows VT entities to host Globus Connect Servers and designate collections as on enabled servers as “HA”.

In addition, individuals may create personal Globus accounts and use Globus Connect Personal (GCP) on ARC systems or other platforms if they have their own Globus license.

To share data with other institutions and people outside of VT, you will use Globus Guest Collections. When you create a Guest Collection, you will define who can access it and what permissions they will have on the data within it.

Everyone at VT has a globus account, https://globus.org that you can login to.
Search for Guest Collections (might have to unclick "Recent Tasks") and you should see "Virginia Tech ARC Globus Projects Directories".

# Tar and Compression Tools
It is often best, when transfering a large number of files to first tar or compress the files and then transfer.

## `tar`
A common tool you can use is `tar` or "tape archive". This is fast, only limited by read/write speed. Also has options for create, inspect, extract, compress.

Create example:
```
tar -cf archive_filename.tar <dirname>
```
Inspect example:
```
tar -tf archive_filename.tar
```
Zip (with gzip; "tarball") example:
```
tar -zcf archive_filename.tar.gz <dirname>
```
Extract example:
```
tar -zxf archive_filename.tar.gz 
```
(add “–m” to update timestamps on extraction)

## Compression/Zip
Compression and Zip work to minimize the size of the tar directory. Compression algorithms take advantage of redundancy to reduce size. They are CPU-bound so they can consumes considerable time and energy.

`gzip` is popular and widely supported and is natively supported by many analysis tools. The following examples are using DNA sequencing files that are in a FASTQ format (“Q” stands for quality score). This format is necessary for bioinformatics software.

Compress with `gzip`:
```
gzip archive_filename.fastq
```
Compress with `gzip` “levels” (levels range from 1 to 9, 1 being the fastest and 9 being the best or most optimial compression)
```
gzip -9 archive_filename.fastq
```

`xz -T` or `zstd` are faster because they can be parallelized and have better compression, but have more limited support on other systems.

Compress with `xz`:
```
xz archive_filename.fastq
```
Compress in parallel threads with `xz`:
```
xz -T 24 archive_filename.fastq
```

Note: Binary data formats are often incompressible (already compressed)
- Matlab .mat, BAM files, netCDF, HDF5, etc. 

# File Management via IDE
If you want to avoid the terminal, you can use an Integrated Development Environment (IDE) to manage files on ARC.

A common one is Visual Studio Code (VS Code).

We also offer file management in Open OnDemand [https://ood.arc.vt.edu/](https://ood.arc.vt.edu/).

# Wrap-up
Feedback form: [https://forms.gle/NK3AiVxMLbintCJT8](https://forms.gle/NK3AiVxMLbintCJT8)