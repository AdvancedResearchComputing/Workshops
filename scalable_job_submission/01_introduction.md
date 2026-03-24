# Scalable Job Submission


## Ideas Behind This Workshop

1. There are limits as to how many SLURM batch jobs that you can submit
     at one time.
2. There are ways to "pack" multiple executions of a code into one sbatch script.
3. Thus, you can stay under the limit.
4. This is not trickery.
5. There are times when you need to run a lot of jobs and they are small;
   submitting each job individually actually generates more overhead for slurm.
   So these small jobs can be packed.
6. Even collections of larger jobs can be grouped together.
7. The purpose of this workshop is to present and demonstrate tools to 
   enable job "packing."

## Motivation

There is a limit on the number of jobs that you can submit
to different partitions (i.e., queues) on the ARC clusters.

The current limit is 5000 submitted jobs (jobs queued and jobs running, combined).

This limit is not hard to reach:
roughly 10,000 quite large jobs can be submitted and run overnight
if a cluster is not heavily used.


Ideally one would submit all 10000 jobs
(each slurm job is a separate slurm script and a single
"sbatch" invocation) at one time and let
slurm handle execution of these and other users' jobs.
But the above limit prevents this.

What can be done?

One can "pack" jobs into one `sbatch` submission to slurm.

How can this be done?

There are several ways to do this.

These ways are the subjects of this workshop.

We note that there is also a limit on the maximum number of steps
that can be executed in slurm jobs, and this issue will also
appear in these notes.

There is also an issue of wall-clock time.
A standard job is allowed to run for a maximum of seven days.
So it does not matter how many code executions that you pack into one
sbatch slurm job submission, they will run for at most seven days
(this time is an input field in a slurm sbatch script, but you
cannot go over seven days, equals 168 hours).


## Learning Objectives

1. Techniques for submitting multiple codes within one slurm job.
2. Examples using each of these techniques.


## Overview

We will be looking at these types of "job collections."
The "type of packing" field below should be taken loosely;
one can always find creative ways to use these tools that
perhaps no one has thought of or documented.
So do not view this column as "the final word."

Also, all of these techniques essentially assume that each
execution of your code (a collection is a group of such
executions), are independent, so the order of execution of
the elements of the collection is not important.

One can say that within each slurm sbatch job submission,
the executions are "embarrassingly parallel".

**In most cases, you will want to use job arrays.**

**You may have particular users for "srun" and "parallel".**


| Code or Command  |  Type of Packing     |
| ---------------- | -------------- | 
|    srun     |  Many executions of the same code with perhaps different inputs.   Is a cornerstone of MPI launching, but useful beyond that.  It, for example, is tightly woven into Slurm.  |
|    GNU parallel      |  Many executions of the same code with perhaps different inputs. |
|    Slurm Job Array      |  This is specific to Slurm, ARC's batch job submission system.  It is more flexible, inherently, than srun or GNU parallel.  Operates at a higher level of granularity.  |
|    Scripting      |  Using Linux/UNIX shells, like bash and tcsh.  (Some others:  csh, sh, ksh, tsh, zsh.) These scripting languages are used for a LOT of things; the context of this workshop is just one of many.  Here, too, the selling point is flexibility.  Scripting and job arrays are quite similar in concept. |


These are not the only ways of doing this type of work.
They are just the most common or standard ways.

But there are all sorts of possibilities.
For example, one could write a job submission system, in say, Java or C++,
that will orchestrate the construction of (configuration) files and
compose an sbatch slurm job submission script and then submit it.
But this would be highly uncommon/nonstandard.

### Prerequisites

- You will need an ARC account to follow along and set up these tools.
- Access to a VT network (e.g., on campus or connected to VPN)

### Applicability

These procedures apply to Tinkercliffs (TC), Owl, and Falcon clusters.

### Acknowledgment

Several of the examples were provided by Sofia Lima.  We appreciate her help.


---
[Next: Srun ➡️](02_srun.md)
