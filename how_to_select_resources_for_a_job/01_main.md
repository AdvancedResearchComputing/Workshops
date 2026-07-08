# How to Select (Compute) Resources for a (Slurm) Job

---
[Next: File systems ➡️](02_file_systems.md)

## Topics

## Resources That Can be Requested for a Job

Below are sections from two sbatch slurm scripts, which are used to 
submit batch jobs on a cluster.

The sections provided are where resources are specified.
These give a sense of what resources can (or have to) be
specified, and hence what features of the cluster to understand.


Illustrative resources for a GPU-based slurm job
(for the Tinkercliffs [TC or tc] cluster).
Other cluster resource specifications are similar.

```
#!/bin/bash
#SBATCH --account=arcadm
#SBATCH --job-name=mliap
#SBATCH --time=2-1:00:00
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#
# Load modules
# Invoke your code
```

Illustrative resources for a CPU-based slurm job
(again for TC, but are similiar for other nodes).

```
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --account=arcadm
#SBATCH --job-name=MPI-job
#SBATCH --time=14:00:00
#SBATCH --partition=normal_q
#SBATCH --constraint=amd
#SBATCH --ntasks=10
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output slurm.tc.amd.open.mpi.01.%j.out
#SBATCH --error slurm.tc.amd.open.mpi.01.%j.err
#SBATCH --mem=100GB
#
# Load modules
# Invoke your code
``` 

Note that an sbatch slurm script is created for a particular cluster.
Then the resources specified in the sbatch slurm script
are used to identify particular resource needs to run your job.

Some questions motivated by these data above.

1. Is my code a serial code or a parallel code.
   - If a serial code, I will use one core (CPU) of one compute node.
   - If a parallel code ...
     - Am I using CPUs to achieve parallelism?
     - Am I using GPUs to achieve parallelism?
     - Am I using both?
2. How many processes will I have?
   - If a serial code, there will be one process.
   - A parallel code may have one process or many.
     - A purely threaded code will have one process.
     - A distributed code will have at least two processes.
     - Again, here, you can have both:  threading and distribution.
3. How much memory do I need?
   - If it is a serial code, I might specify twice the size of my input data, as a start.
   - If it is a parallel code, I might run my code across several compute nodes
     and specify memory on a per-compute-node basis (as is done with `#SBATCH --mem=100GB` above). 

This is not a workshop on how to design codes, but these three categories 
of questions above have impacts on all of the parameters listed in the
two examples above:  time, partition, constraint, nodes or ntasks, ntasks-per-node,
cpus-per-task, mem, and gres.

**And in turn, these parameters and their values affect which resources you should
choose to run your jobs.**

Best practices:  many of these sbatch slurm script parameters have defaults.
Do not use the defaults.  Specify everything.

## Illustrative Examples of Resource Difference Across Clusters

ARC documentation contains details on the components (compute elements, volatile memory,
etc.) of clusters.
Be familiar with them.
(Also, in the late summer/fall 2026 timeframe, new resources will come online.)

The resource pages are:

- TC:  [tc resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
- Owl:  [owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
- Falcon:  [falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  

#### Example 1.

_Requirement_:

You have a CPU-based job.
It implements parallelism through threading.
I want as many workers as possible.
My memory requirements are pretty light (i.e., low).

_Solution_:

You can only run on one compute node because the code has no distributed
processing capabilities.

By looking at the clusters, we see that Falcon has no CPU-only nodes.
It is a GPU-based cluster.
You cannot just use the CPUs of a GPU node because that can potentially
cut off users from using the GPUs---which is the purpose of having a GPU-based
cluster.

So your choices are to run on Owl or TC.
We see that the maximum number of cores on conventional CPU nodes
is 128.
On Owl, it is 96.
I would choose to run my code on TC AMD EPYC 7702 nodes, with 128 cores
per node.

This is not the end of the story.
Be prepared to wait in queue a long(er) time to run a job that uses all cores
of a compute node.
It takes slurm time to free these resources.
It might well be better to specify say, 100 or 70 cores of the 128, and
then increase your "time" parameter (because your job will presumably
take longer with 70 cores than 128 cores [but not always]).

Also, you see large and huge memory nodes with 128 cores.
We do not want to specify a 128 core job to run on a large or 
high memory node when our memory requirements are small.
This is using resources that are in demand (there are few large and high
memory nodes) for a purpose not that is inconsistent with their
features.


#### Example 2

_Requirement_:

Like Example 1, you have a CPU-based job.
It implements parallelism through threading.
But now, I do not need a great number of threads;
rather, I need memory because each thread requires
significant memory for processing.


_Solution_:

Much of the early part of this solution is the same as for Example 1.
But at the end, we are driven to the opposite conclusion.

As before:
- We need one compute node.
- We cannot use the Falcon cluster.
- The choice is either Owl or Falcon.
  
We see that the maximum memory per compute node on conventional
TC CPU nodes is 368 GB per node.
And there are only 16 of these nodes.
On Owl, the maximum memory is greater than 2x that of TC:  747 GB per node.
I would choose to run my code on Owl "AMD EPYC 9454 - Genoa" nodes.
Also, there are 96 of these nodes (relatively soon to be doubled).

If you run a job and you get an OOM error (Out of Memory error),
then you can either decrease the number of cores (threads)
or you can go to the large or huge memory nodes.

When you have choices as to what resources you run on, all other things
being equal, choose the resource type that is most plentiful.
It gives the best chance that more of these resources will be available
over time (again, all else being equal), so your job is likely to start
sooner.
If, on the other hand, you want the precious few resources, you 
may have to wait longer.
Again, the dashboards (below) are useful for reasoning about these
issues.

#### Example 3

_Requirement_:

I have a need to do HPC computing with GPUs.

Which GPUs should I use.

_Solution_

We address this in Section XXXX below.


## Beyond Pure Compute Considerations

Sometimes there are factors to consider beyond the execution of a job.

One is the use of Python and the use of virtual environments.

To run Python codes with virtual environments (VEs), the 
virtual environments should be built on the same type 
of compute node on which you are going to run your job.

Example 1:

_Requirement_:

I have a Python code that uses GPUs.
I can run on any of the four types of GPUs on the Falcon cluster.
And I want that flexibility to run on any of these compute node
types, because before I submit my job, I will look at the 
ARC-provided dashboards to see which nodes are least used, thinking
that my jobs will start sooner on that type of node.

_Solution (Partial)_:

This means that I have to create the VE that I will need on each
of the four types of compute nodes of Falcon.

## Using Full Nodes Versus Parts of Nodes

#### Backing Away From a Full Node

This was covered in an example above, but because the
effect---at times--can be so large, we separate it out here.

When you select all of the resources on a compute node, 
it can take slurm (the job scheduler) a long time to 
free up a complete compute node.
If possible, instead, specify a (large) fraction of a node's
resources; this might reduce the time your job remains queued
(before it starts to run).


#### Specifying Pieces of Many Nodes

**<< MATT, I DON'T KNOW IF I HAVE THIS RIGHT; IF I'VE UNDERSTOOD YOUR OBSERVATIONS>>**

A significant fraction of jobs are scheduled by slurm
using a technique called "backfill."
Slurm essentially schedules jobs by a formula that 
produces a priority ranking for each job.
It then runs jobs in that order.

But when this is done, as you might imagine, there are
(small) "holes" left in the schedule where resources are
idle.
A simplified example:  in scheduling high priority jobs,
there are three CPUs that are not being used for four
hours each.

Slurm will go back to the jobs submitted and waiting to be run
and find (smaller) jobs that will fit into these vacant
"resource slots."

The upshot is that small jobs have a better chance of 
being chose to fill these unused resources, i.e.,
small jobs are often better candidates for backfill.

As a result of this concept, consider the following.
You have a distributed CPU job or a distributed GPU job.
Rather than specify that all of the resources 
you need be run on one compute node, specify that the
resources can come from multiple compute nodes.
In this way, you are telling slurm that it can run 
your job using "small hunks of resources" from a
combination of several compute nodes.

Another example using the same setup.
Suppose you have a parallel job, but it can be run
in an embarrassingly parallel fashion.
If you "carve up" the data so that each piece of data can
be run (operated on) by a single CPU as an individual job, you may
be able to get lots of individual CPU jobs done before
many CPUs become available, at one time, to do all of your work as 
one job.

## Partitions:  The Compute Nodes on Which Your Job Runs

A partition is a collection of compute nodes.
A partition must be specified in an sbatch slurm script
(or interactive job from the command line).

Often, this collection of compute nodes
is of one type (i.e., one specific architecture),
say a particular class of GPU nodes.
But this is not always the case.
Partitions may have more than one type of compute node, e.g.,
to increase job throughput (which is a driver for ARC).

The partitions of all one node type are given below.
Specifying the partition completely specifies the type of 
compute node.

|  Cluster   | Partition |   Type of Compute Node  |
|    ---     |    ---    |      ---                |
|   TC       |    h200_normal_q   |  H200 GPUs     |
|   Falcon   |    l40s_normal_q   |   L40S GPUs    |
|   Falcon   |    a30_normal_q    |   A30 GPUs     |
|   Falcon   |    v100_normal_q   |   V100 GPUs    |
|   Falcon   |    t4_normal_q     |   T4 GPUs      |


The partitions with more than one node type are given
below.
In these cases, if one wants to specify uniquely
the type of compute node, then specifying only the
partition is not sufficient.


|  Cluster   | Partition |   Types of Compute Node  |
|    ---     |    ---    |      ---                |
|   TC       |    normal_q       |  CPUs:  AMD and Intel nodes.    |
|   TC       |    a100_normal_q  |  GPUs:  Nvidia and HPE nodes.      |
|   Owl      |    normal_q       |  CPUs: Genoa and Milan.     |

We note that for many jobs, the type of compute node is
not important.
For example, one may want to run an app that will 
execute on CPUs, and it may run fine on either of the
two CPU types on the TC normal_q and on either of the
two CPU types on the Owl normal_q.

If the type of compute node is important, then in addition
to a partition, one specifies a constraint as a slurm
switch (see initial examples of sbatch slurm scripts).
Expanding the previous table, the mapping is:

|  Cluster   | Partition |   Compute Node Type; Constraint  | Compute Node Type; Constraint  |
|    ---     |    ---    |      ---                |    ---                |
|   TC       |    normal_q       |  AMD; `--constraint=amd`.    | Intel; `constraint=avx512`.    |
|   TC       |    a100_normal_q  |  Nvidia; `--constraint=a100-dgx`.    |  HPE;  `constraint=a100-hpe`.      |
|   Owl      |    normal_q       |  Genoa; `--constraint=avx512`.     |    Milan; `--constraint=milan`. |

As given in an earlier example, one situation in 
which constraints are required is when your code
uses a virtual environment.
This is because the virtual environment must be built
on the same type of compute node on which the 
environment is used.
So you must specify the same constraint in creating
the VE and running your job.

Another situation is profiling your code for performance evaluation.


## All GPU-Based Compute Nodes Are Not Created Equal

ARC has six (soon to be seven) types of GPUs.

Some are particularly well-suited for particular types of jobs.

It is important to know these mappings because GPU resources
are scarce.

It is in everyone's interest to use resources in wise ways so
that you as an individual and VT as a collective run as many
jobs as possible in some unit of time.

**<<Matt, I got this off of the internet; please inspect.>>**

|     Use              | Cluster   | GPU Node Type   |
|   ---                |     ---   |  ---            |
|   `&` LLM inference; AI training; data analytics; HPC/RC  |   TC   |    A100    |
|   memory-intensive, large-scale AI and HPC/RC           |    TC      |     H200     |
|   `*` AI workloads       |    Owl       |  B200 |
|   AI inference; visualization; video and media processing         |    Falcon  |    L40S      |
|   AI inference; data analytics; HPC/RC        |    Falcon  |    A30       |
|   Deep learning (training and inference); data analytics; HPC/RC         |    Falcon  |    v100      |
|   `$` NLP; single precision computations        |    Falcon  |    T4        |

`&` HPC = high performance computing; RC = research computing.

`*` coming in late summer/fall 2026.

`$` NLP = natural language processing.


## Storage

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


## An Estimate of When Your Job Will Start


There are at least two ways to get an estimate.

#### Option 1:  Command Line (Terminal) Invocation "scontrol show job <slurm-job-id>"



#### Option 2:  Use Grafana Dashboards


================================================

================================================

================================================



1. X Parameters that you can specify for a job
   - number nodes, cpus, num gpus, memory, etc.
2. X How these parameters vary across clusters
   - The ARC web pages:
     - TC:  [tc resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
     - Owl:  [owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
     - Falcon:  [falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  
   - Examples
     - show some features from ARC docs.
   - Comparisons
     - Memory per CPU node:  Owl up to 3x that of TC.
     - Numbers of nodes:  On TC, there are 19x more AMD CPU nodes than Intel nodes
       - So if you are using python code and virtual environments (VEs), then consider
         making the VE on an AMD node.
         This way, when you need to run your code---using the same type of compute node used
         to make the VE---you will have 19x the number of compute nodes to run your jobs.
3. Unique features of clusters
   - Owl has large (4 TB) and huge (8 TB) memory CPU-based nodes for "large memory" computing jobs.
   - OTHERS?????
4. X Know the types of GPUs that are best suited for your jobs
   - Examples:
     - A30 (Falcon):  best for XXXXX.
     - L40S (Falcon):  best for XXXXX.
     - H200 (TC):  best for XXXX.
     - B200 (Owl) [coming]:  best for XXXX.
5. Attempting to minimize your job's wait time.
   - That is, the time from job submission until it begins to run.
   - See the Grafana dashboards to see the most heavily used clusters/partitions, and historical wait times.
     - [time wait dashboard](https://dashboard.arc.vt.edu/d/fej6n6nqfytc0f/arc-cluster-wait-times?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=$__all&var-partition=$__all&var-timelimit=$__all&refresh=1m)
6. Input/output (I/O) Speeds
   - If you have a lot of disk/storage access,
     read from and write to `/scratch`; much faster than `/projects`
   - If your code is small enough, use "localscratch";
     faster than `/scratch`.
7.  Using different storage, lifetime of data
   - `/projects`:  permanent.
   - `/scratch`:  only 90 days.
   - "localscratch":  only for the life of slurm job.
     - This means, for localscratch, that _**as part of the batch job**_,
       you must move data into local scratch and copy out results.
       - Why?
         - Because before the job starts, there is no localscratch,
           so you cannot bring data in ahead of time.
         - Because after the job finishes, the localscratch memory disappears,
           so if you do not copy out your results files, they will be deleted.
8.  Delays in obtaining a full node.  Can you go with fewer resources,
    e.g., fewer CPUs?  Job may take longer, but it may start much sooner.
9.  User QoS
   - There is a QoS table on each of the cluster's pages, given above.
   - Can run jobs up to 14 days with "long" QoS.
   - If your group consistently does not use its monthly computing units budget,
     you can increase your job priority by using "short" QoS.
      - But the billing rate is double the "normal" QoS, by design.
      - But the maximum duration of a job is one day; for "normal" QoS, it is seven days, by design.  
10. Choosing type of job:  interactive or batch
   - General guidelines
     - Interactive jobs 
       - You are doing scoping studies and you want to:
          - determine what the analysis steps are
          - see intermediate results
          - (e.g., you are exploring and uncertain.)
       - You need visualization.
       - You have very few jobs to run.
     - Slurm batch jobs.
       - You know your analysis steps, or you may have only one or two issues to resolve.
       - You are doing scoping studies, but you do not need to see 
         on-the-fly intermediate results; only the results are sufficient.
       - You do not need visualization in the job.
       - You have many, many jobs to run (say, 15 or more)
   - Maximum-benefit choice for you and for everyone else.
     - If you can run either way:  interactive or batch.
       - Choose batch job.
         - Why?
           - The slurm scheduler can make far better use of resources.
           - EVERYONE benefits when this happens.
           - Specifics
             - (1) Interactive jobs may not start when you are around.
               - In this case, resources are assigned to you but you are not using them.
               - So the resources sit idle waiting for you; others cannot use these resources.
             - (2) When a person is done with an interactive job, they must explicitly give back the resources.
               - If a user does not give the resources back, then until the job wall time 
                 is reached.
               - So the resources sit idle waiting for you; others cannot use these resources.
           - Batch jobs, by their nature, do not suffer these inefficiencies.
       - You should choose the job type that you need:  if you need interactive jobs, then use them.   
11. Caution about specifying whole nodes for jobs.
   - This can take time for slurm to achieve and provide to you.
   - Example alternative
12. If using GPUs in your job, use the grafana dashboards to ensure that your code is using the GPUs.
   - These are a limited resources, so their efficient use if important to everyone.
   - Procedure
     - Go to a terminal for the cluster your jobs are on.
     - Type `squeue`.
     - Get the slurm job ID of the job of interest.  Call this `sjid`.
     - On terminal type, `scontrol show job --details sjid`.
       - Get the compute node IDs of the compute nodes that you are using.
       - Get the GPU indexes of the GPUs you are using.
     - You can also do:  on terminal type, `showjobusage sjid`.  Get the compute node IDs from the output.
     - Go to the dashboards below (per cluster).
        - Dashboards
          - [TC dashboard](https://dashboard.arc.vt.edu/d/acfsdp9/arc-cluster-efficiency-tinkercliffs?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-tc-oss&var-partition=$__all)
          - [Owl dashboard](https://dashboard.arc.vt.edu/d/acgv4cq/arc-cluster-efficiency-owl?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-owl-oss&var-partition=$__all)
          - [Falcon dashboard](https://dashboard.arc.vt.edu/d/cej373w7tbmkgd/arc-cluster-efficiency-falcon?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-falcon-oss&var-partition=$__all)
     - Select your compute node ID (the one from the step above).
     - Look at the GPU utilization plot and inspect the utilization of the GPU you are using.
13. Post-job quick evaluation:  build your intuition about what resources you need
   - Commands
     - `seff <slurm job ID>`
     - Will tell you what your utilization of CPU and memory are.
     - If you are using GPUs, then:
        - In your batch script, use the `nvidia-smi` command.
        - An example is in the ARC docs:  [example batch script with nvidia-smi](https://docs.arc.vt.edu/resources/compute/02falcon.html)
   - Example


## Learning Objectives

1. blah
2. blah

## Detailed Topics

1. [File systems](./02_file_systems.md)
2. [File and directory permissions](./03_file_permissions.md)
3. [umask](./04_umask.md)
4. [File and directory ownership](./05_file_ownership.md)
5. [Data recovery and LT storage](./06_data_recovery_and_long_term_storage.md)
6. [Best practices](./07_best_practices.md)


### Prerequisites

- You will need an ARC account to follow along and set up these tools.
- Access to a VT network (e.g., _eduroam_ on campus or _VPN_ off campus)

### Applicability

A very large portion of this content is applicable to 
any compute cluster.

### Acknowledgment

These notes were constructed largely from workshop materials
initially prepared by Matt Brown and Sophia Lima.

---
[Next: File systems ➡️](02_file_systems.md)
