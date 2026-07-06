## File Systems

---

⬅️ [Previous: Main](01_main.md) | [Next: File and directory permissions ➡️](03_file_permissions.md)


### File Systems Introduction 

#### Conceptual View of ARC Storage

Graphic below shows schematically different storage devices
(in green) and some important features.

![conceptual view](./figures/file-system-basic.png)


Illustration of how the Tinkercliffs (TC), Owl, and Falcon
clusters share some storage devices (e.g. `/home` and `/projects`)
but not others (e.g., `/scratch` and localscratch).

![illustrative example](./figures/file-system-specific.png)

#### Partial Summary of Storage Options on ARC Clusters

|   Directory  |   File System  |  Size Limit   |  inode Limit   |   Permanence  | Accessibility  |  Qualitative Access Speed  |
|   ----       |    ----------  |   ----------- |   ---------    |   --------    |  ---------     |   -----        |
|    /home     | Qumulo         |    640 GB per user  |  1 M     |   permanent   |  Across all 3 clusters |  slow   |
|   /projects  |  General Parallel File System (GPFS)  |  50 TB per PI  |   10 M  |  permanent |  Across all 3 clusters |  slow   |
|  /scratch    |  VAST          |   "No limit"  |   "No limit"   |   90-day limit; then deleted | Individual, per cluster | fast | 
| "localscratch"*,$ |  NVMe drive or array | Generally smaller | NA  |  Only for life of job  |  Individual, per cluster  | faster  |

\* The actual location is job dependent, under the /tmp directory.

\$ NVMe (Non-Volatile Memory Express) is a high-performance storage protocol designed for solid state drives [that use flash memory] that uses the PCIe interface to provide high speed and low latency. It communicates directly with the CPU, etc.

#### Ranking Storage Options on Different Criteria

Different storage options have desirability based on what
criteria are important to you.

![storage-rankings](./figures/ranking-storage-options.png)

### Tools for Exploring File Systems

#### Tools for Storage Usage

1. quota
   - ARC script (not shell command) to provide /home and /projects use.
   - Shows your allocations for storage and how much of that storage that you have used.
   - Shows your monthly job allocation and how much of that you have used.
2. du
   - “disk usage” 
   - Typically used to display metadata (e.g., size of all files in a directory).
   - Often used to identify “culprits”.
   - Default units are KiB (units of 1024-byte blocks)
   - Example:  du /home/ckuhlman/help-issues/
      - “help-issues” could be a file or directory name.
   - Example:  du
      - Shows all subdirectories of current location.
3. df
   - “disk filesystem”
   - Specifies how much storage has been used and is free on various file systems.
   - Example:  df
       - Shows all filesystems and their usage.
       - You will see a lot of the names of the file systems that we’ve mentioned above.
   


#### Tools for Files and Directories

1. stat
   - Displays information about files and file systems.
   - Example:  stat --file-system /projects
2. ls
   - List files, directories, and symlinks (symbolic links) in a directory.
   - Example:  ls -lrt
     - "long lists" the files, directories, and symlinks.
     - We will use this a lot to see permissions, to help us change them.
3. find
   - Locates files (i.e., if files exist, then it will give their full paths).
   - Example:  find .  -name “my_file.txt”
     - Start in the current directory and look here and in subdirectories to find “my_file.txt”.
   





---

⬅️ [Previous: Main](01_main.md) | [Next: File permissions ➡️](03_file_permissions.md)
