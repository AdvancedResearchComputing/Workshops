5. [Mapping job types to GPUs ⬅️ Previous:](./mapping_job_types_to_gpus.md)

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


|   Directory  |   File System  |  Size Limit   |  inode Limit   |   Permanence  | Accessibility  | Locality  |
|   ----       |    ----------  |   ----------- |   ---------    |   --------    |  ---------     |   -----        |
|    `/home`   | Qumulo         |    640 GB per user  |  1 M     |   permanent   |  omnipresent |  remote   |
|   `/projects`|  General Parallel File System (GPFS)  |  50 TB per PI  |   10 M  |  permanent | omnipresent |  remote   |
| `/scratch`   |  VAST          |   "No limit"  |   "No limit"   |   90-day limit; then deleted | per cluster | remote | 
| `/localscratch`* |  NVMe drive or array | Varies | NA  |  Only for life of job  |  node-specific  | local  |

\* The actual location is job dependent, under the /tmp directory.

NVMe (Non-Volatile Memory Express) is a high-performance storage protocol designed for solid state drives [that use flash memory] that uses the PCIe interface to provide high speed and low latency. 

Given the above data, a short description of uses is given for each file system.

#### Home

Used for specifying your profile, .bashrc, aliases, and other system-based files.

Can put virtual environments here.

Not much use for research since the size limit of 640 GB per user is prohibitive.

#### Projects

Used to store files associated with a PI's (i.e., professor's) research because:
1. there is adequate space (up to roughly 50 TB per PI).
2. this storage is permanent.
3. all data is managed by the PI-owner.

Students, post-docs, etc.:
this is the location (i.e., `/projects`) under which your PI's/professor's 
project name will be found.  This is the "project storage."

Directory structure is:  `/projects/<PI-specified-directory-name>`.
Then you and your PI create directories and so forth under here.

(Slurm) jobs can access files in this file system, but a faster option is given next.

Can store VEs here (e.g., instead of in `/home`) and share them with a group.

#### Scratch

Your scratch area is : `/scratch/<username>`.

You have this directory on each of the three clusters,
but unlike `/home` and `/projects`,
the same physical storage is NOT accessible from TC, Owl, and Falcon.
This is because there is a separate scratch mount for each cluster.
This is done to achieve greater I/O (input/output, read/write) segregration which benefits speeds.
To be clear, although you have a `/scratch/<username>` on each of TC,
Owl, and Falcon, these three are three separate storage areas.

Your code will perform I/O slightly faster with files in `/scratch` than
it will with files in `/projects`/

`/scratch` has essentially unlimited size in the short-term.

However, the critical thing to know about scratch is that when files reach
90 days in age, they are automatically deleted.
**So this is NOT permanent storage.**

A common use case is to:
1. copy files from your PI's `/projects` area to your `/scratch` directory.
2. Run your code by accessing input files from `/scratch` and writing data to files
   in `/scratch`.
3. When your code execution completes, move the output files from
   your area in `/scratch` to some directory under `/projects`.

#### Localscratch

Localscratch is not a dedicated physical drive, per se, as are the other 
file systems.

The storage is right on the compute node, making it much faster than
`/scratch` for I/O operations during program execution.

The lifetime of files in localscratch is the duration of a slurm job.

Therefore, if one looks at the 3-step process in the previous subsection,
then to use localscratch instead of scratch:
- substitute "`$TMPDIR`" for `/scratch`.
- note that all three steps must be done inside of the slurm scipt.

The second bullet makes sense:  if you write new output files, and
wait until after the slurm job is over to move them, then they are
already gone because localscratch ends with the slurm job.

There is a video on how to construct slurm sbatch scripts for
running jobs out of local scratch:
[section of videos doc page](https://docs.arc.vt.edu/usage/video.html#how-to-run-codes-your-own-or-commercial-open-software)
and select the video "**Batch jobs using volatile resources**".

It is recommended that you attempt to first run your job with
files in scratch, because it can store larger files.
Then, if you have heavy I/O needs, you can try localscratch
and can determine whether the files will fit into localscratch.
That is, get your job to run successfully first and then
focus on optimizations (in this case, by using localscratch).

Finally, there is an entire workshop where file systems are a main focus.
Recordings (current and from the past) can be accessed from the
[Workshops ARC Docs page](https://docs.arc.vt.edu/usage/workshops.html),
and the workshop is typically named "Managing Data on ARC Resources" (or similar).
Look at a row entry in the tables of workshops, under column "Recording."
The workshop notes are at
[Data Management Workshop Materials](https://github.com/AdvancedResearchComputing/Workshops/tree/main/data_management).


7. [Next: ➡️ Longer running jobs](./longer-running-jobs.md)
