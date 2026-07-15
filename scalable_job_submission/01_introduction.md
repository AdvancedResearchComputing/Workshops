# Scalable Job Submission

## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help and access to information, and links to those resources, are provided.  Examples:

- ARC Docs (documentation) pages
- determine and attend office hours
- submit help tickets (for errors, problems, or request a consultation)
- obtain listings of workshops (and video recordings and notes files)
- view video tutorials
- run example codes
- understand overall cluster status and performance, as well as those of your jobs, via dashboards
- more


## Motivation

Typically, one slurm sbatch slurm script contains commands to run some 
code one time.

However, once you are allocated resources, you can run any number of codes
any number of times, as long as you stay within the resources assigned to you.

Herein, we refer to the process of specifying more than one code execution
within one slurm batch job 
(i.e., within one sbatch slurm script)
as _**packing**_.

The purpose of this workshop is to present and demonstrate tools and approaches to enable job packing.

How can packing be done?

There are several ways to do this.
1. request sufficient resources where multiple
   codes can be run in parallel
   (embarrassingly parallel).
2. request sufficient resources for one job,
   but increase the time (`#SBATCH --time=`)
   so that there is sufficient time to run
   `n` jobs.
   Run, in sequence, one at a time,
   `n` jobs.
3. use job arrays (embarrasingly parallel potentially).


## Learning Objectives

1. Learn techniques for submitting multiple codes within one slurm job.
2. Understand examples using each of these techniques.


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



| Code or Command  |  Type of Packing     |
| ---------------- | -------------- | 
|    srun     |  Many executions of the same code with perhaps different inputs.   Is a cornerstone of MPI launching, but useful beyond that.  It, for example, is tightly woven into Slurm.  |
|    GNU parallel      |  Many executions of the same code with perhaps different inputs. |
|  srun and GNU parallel together | Complementary strengths:  srun at task level; parallel at cpu level. |
|    Scripting: loops      |  Using Linux/UNIX shells, like bash and tcsh.  (Some others:  csh, sh, ksh, tsh, zsh.) These scripting languages are used for a LOT of things; the context of this workshop is just one of many.  Here, too, the selling point is flexibility.|
|    Slurm Job Array      |  This is specific to Slurm, ARC's batch job submission system.  It is more flexible, inherently, than srun or GNU parallel.  Operates at a higher level of granularity.  |



These are not the only ways of doing this type of work.
They are just some of the most common or standard ways.


### Critical Note About Examples

There are perhaps 10 or so example codes that you can run.
All source code files are right in the notes:  you
simply use the copy button and copy the contents into
files on the ARC cluster using your favorite editor
(vi, nano, etc.).
All examples are CPU-based examples.
That is, there are no GPU-based examples.
Therefore, the Falcon cluster should not be used.
These examples have been run many times, so they should
work for you.
It is recommended that you run these codes on the
Tinkercliffs cluster just because these examples have
all been successfully run most recently on the 
Tinkercliffs cluster.


### Prerequisites

- You will need an ARC account to follow along and set up these tools.
- Access to a VT network (e.g., on campus or connected to VPN)

### Applicability

These procedures apply to Tinkercliffs (TC), Owl, and Falcon clusters.

### Outline


1. [srun](./02_srun.md)
2. [GNU Parallel](./03_parallel.md)
3. [GNU Parallel and srun](./04_srun_parallel.md)
4. [(Bash) scripting loops](./05_bash_loops.md)
5. [Job arrays](./06_job_arrays.md)



### Acknowledgment

Several of the examples were provided by Sofia Lima.  We appreciate her help.


---
[Next: Srun ➡️](02_srun.md)
