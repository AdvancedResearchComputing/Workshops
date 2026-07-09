# Storage

ARC clusters use a variety of storage options.
This is because different storage devices/types
have different strengths and weaknesses.
So a particular type of storage may be used to
fulfill a particular need.

A summary of storage options are given below.
Note that each file system (matched to a directory
on ARC clusters in most cases) is
provided with four dimensions:
- size.
- permanence (e.g., how long can you keep your files there).
- accessibility (e.g., from which clusters can you access the same storage).
- access speed (e.g., how fast are code-based input read and output write operations).


|   Directory  |   File System  |  Size Limit   |  inode Limit   |   Permanence  | Accessibility  |  Qualitative Access Speed  |
|   ----       |    ----------  |   ----------- |   ---------    |   --------    |  ---------     |   -----        |
|    /home     | Qumulo         |    640 GB per user  |  1 M     |   permanent   |  Across all 3 clusters |  slow   |
|   /projects  |  General Parallel File System (GPFS)  |  50 TB per PI  |   10 M  |  permanent |  Across all 3 clusters |  slow   |
|  /scratch    |  VAST          |   "No limit"  |   "No limit"   |   90-day limit; then deleted | Individual, per cluster | fast | 
| "localscratch"*,$ |  NVMe drive or array | Generally smaller | NA  |  Only for life of job  |  Individual, per cluster  | faster  |

\* The actual location is job dependent, under the /tmp directory.

\$ NVMe (Non-Volatile Memory Express) is a high-performance storage protocol designed for solid state drives [that use flash memory] that uses the PCIe interface to provide high speed and low latency. It communicates directly with the CPU, etc.

Given the above data, a short description of uses is given for each file system.

#### Home

Used for specifying your profile, .bashrc, aliases, and other system-based files.

Can put virtual environments here.

Not much use for research since the size limit of 640 GB per user is prohibitive.

#### Projects

Used to store files associated with PI (i.e., professor) research because
(1) there is adequate space (up to roughly 50 TB per PI) and
(2) this storage is permanent.

Can store VEs here (e.g., instead of in `/home`).

Directory structure is:  `/projects/<PI-specified-directory-name>`.
Then you and your advisor create directories and soforth under here.

(Slurm) jobs can access files in this file system, but a faster option is given next.

#### Scratch

Your scratch area is : `/scratch/<username>`.

You have this directory on each of the three clusters,
but unlike `/home` and `/projects`,
the same physical storage is not accessible from TC, Owl, and Falcon.
This is because there is a separate scratch mount for each cluster.
This is done to achieve greater I/O (input/output, read/write) speeds.

Your code will perform I/O faster with files in `/scratch` than
it will with files in `/projects`/

`/scratch` has essentially unlimited size in the short-term.

However, the critical thing to know about scratch is that when files reach
90 days in age, they are automatically deleted.
So this is NOT permanent storage.

A common use case is to:
1. copy files from `/projects` to `/scratch`.
2. Run your code by accessing input files from `/scratch` and writing data to files
   in `/scratch`.
3. When your code execution completes, move the output files from
   your area in `/scratch` to some directory under `/projects`.

#### Localscratch

Localscratch is not a dedicated physical drive, per se, as are the other 
file systems.

Rather, storage is allocated under `/tmp`.

The storage is right on the compute node, making it even faster than
`/scratch` for I/O operations during program execution.

However, the lifetime of files on localscratch are even less than the
90 days on scratch.

The lifetime of files in localscratch is the duration of a slurm job.

Therefore, if one looks at the 3-step process in the previous subsection,
then to use localscratch instead of scratch:
- substitute "localscratch" for `/scratch`.
- note that all three steps must be done inside of the slurm scipt.

The second bullet makes sense:  if you write new output files, and
wait until after the slurm job is over to move them, then they are
already gone because localscratch ends with the slurm job.

There is a video on how to construct slurm sbatch scripts for
running out of local scratch:  [section of videos doc page](https://docs.arc.vt.edu/usage/video.html#how-to-run-codes-your-own-or-commercial-open-software)
and select the video "**Batch jobs using volatile resources**".


It is recommended that you attempt to first run your job with
files in scratch, because it can store larger files.
Then, if you have heavy I/O needs, you can try localscratch
and can determine whether the files will fit into localscratch
(if not, you may get an OOM error [out of memory error]).
That is, get your job to run successfully first and then
focus on optimizations (in this case, by using localscratch).