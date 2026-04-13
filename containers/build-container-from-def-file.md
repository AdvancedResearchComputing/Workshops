# Containers on ARC Clusters

# ---- IN PROGRESS ----

## Build Container From a Definition File


#### Construct the Definition file:  moo-me.def.


```
Bootstrap: docker
From: ubuntu:22.04

%post
    apt-get update
    apt-get install -y cowsay

%environment
    export PATH=$PATH:/usr/games

%runscript
    cowsay "Hello from inside Apptainer!"
```

Key Components of a `.def` File:
- Bootstrap: The source of the base image (e.g., docker, library, localimage).
- %post: Shell commands run during the build process to install software.
- %environment: Environment variables available inside the container at runtime.
- %files: Used to copy files from your host machine into the container.
- %runscript: Defines what happens when you run the container as an executable. 


#### Build the Image

```
# Build the .sif image from the definition file
apptainer build --fakeroot moo-me.sif moo-me.def
```
If this command is issued from an Owl or TC head node
then the result will be this error:

```
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
INFO:    The %post section will be run under the fakeroot command
INFO:    Starting build...
INFO:    Fetching OCI image...
28.4MiB / 28.4MiB [=========================================================================================================================================================] 100 % 0.0 b/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Running post scriptlet
FATAL:   container creation failed: failed to resolve session directory /localscratch/apptainer/mnt/session: lstat /localscratch/apptainer/mnt: permission denied
INFO:    If error was from fakeroot, try --ignore-fakeroot-command and
INFO:      maybe use fakeroot inside the %post section as described at
INFO:      https://apptainer.org/docs/user/latest/fakeroot.html#fakeroot-inside-def
FATAL:   While performing build: while running engine: while running %post section: exit status 255
```

**Question**:  What is wrong?

**Answer**:  You are running this on a head node and
you do not have proper permissions.
Run on a compute node.


#### Request Resources On A Compute Node:

Option 1 (Preferred)

```
salloc --partition=normal_q  --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```

<< Do Work >>

When done with work, exit off the compute node.

```
exit
```

Option 2 (Not Preferred---Because when done, **YOU** 
have to remember to relinquish resources with **exit** command.)

```
salloc --partition=normal_q  --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```

<< Do Work >> 

Then when done with work:

1. exit
   1. (to get off of the compute node).
2. squeue -u $USER
   1. (to get the PID of the salloc job).
3. scancel PID
   1. (to give back the resources that you have been granted by slurm that you used to do your work).




#### Run the Image As-Is

```
./moo-me.sif
```

#### Run the Image With Tailored Input

```
apptainer exec moo-me.sif cowsay "Moooo to youuuuuu"
```


---------------------------------

---------------------------------

---------------------------------

---------------------------------

---------------------------------

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help from VT ARC and access to information, and links to those resources, are provided.  Examples:
- determine and attend office hours
- submit help tickets (for errors, problems, or request a consultation)
- obtain listings of workshops (and video recordings and notes files)
- view video tutorials
- run example codes
- understand overall cluster status and performance, as well as those of your jobs, via dashboards
- more

## Container Overview

### Definition

- A **container** is a software file
  that houses
applications and
all supporting software needed to run those applications.
- Often a container will have one major application,
but could have multiple applications.
- Because a container also houses all supporting
software needed
to run the application, including an operating
system (OS), a container is
self-contained and stand-alone.
- The applications within the container are
called from outside the container,
but they run inside the container.
- So a major feature of containers is that they can
  reside
on computer systems that are completely unrelated to
the environment within the container, and the applications
within the container will still run.

Example:  You can create a container on a Linux OS machine
and move it to a Windows machine, and the applications
within the container will run on the Windows machine inside
the container.

Since a container houses a complete environment,
a container file can be huge:  TBs in some/many cases.

Based on this information, you can readily see that
major strengths of containers include:
1. portability:  a container will run anywhere.
2. customized:  you can tailor an environment for
   yourself and colleagues
3. unified work environment:  in sharing with colleagues
   be assured that everyone has the exact same setup.
 
## ARC Docs Page On Containers (Apptainer)

- There is an [ARC Docs page](https://docs.arc.vt.edu/software/apptainer.html#container-runtimes-may-not-be-available-on-login-nodes)
that contains a lot of information.

- We will often refer to that page, but will refrain from repeating content to the maximum extent possible (for maintainability).

- We will use the example from that page.

### Approaches to creating containers

There are two industry and academic defacto standard ways to construct containers:
- using Docker
- using Apptainer (formerly Singularity)

Docker requires a person to have root access for its use on a computer (system).
For cluster use, one does not have root privileges
because there are many users and hence security issues that preclude root privileges.
Hence, Singlularity was born.
Singularity is now **Apptainer**.


## Structure and Anatomy of a Container

---- TODO ----

## Docker as a Starting Point for Apptainer

Often is it efficient and convenient to start an
Apptainer container using a Docker image that is
then automatically converted to an Apptainer instance.

## Examples


## Acknowledgments

Alberto Cano and Saikat Dey are gratefully acknowledged for
constructing the [ARC Docs page on Containers](https://docs.arc.vt.edu/software/apptainer.html#singularity), on which
this workshop is largely based.


Sofia Lima has provided another example at
[VT ARC git container example](https://github.com/AdvancedResearchComputing/examples/tree/master/apptainer/1.4.0).

-------------------------------------

-------------------------------------

"TO DELETE" things below.

-------------------------------------

-------------------------------------



These tools are at various levels of software.  These include:

- UNIX/Linux tools.
- Slurm tools.
- POSIX tools.
- PL constructs.
- Software libraries.
- Software frameworks. 

> [!NOTE]
By _**concurrency**_ we mean that multiple sequences of code are executing simultaneously.
Herein, we use "concurrency" synonymously with "parallel execution."
We are not interested in, for example, two "threads of control" or sequences of commands
being alive or active at the same time but not executing at the same time.
This behavior is either time-slicing or akin to it.
We have one or two examples of this, but they are only to recognize the limitations of
such approaches---they are not advocated.
Rather, we are interested in multiple threads of control executing code at the same 
moment in time.

> [!NOTE]
_**Notes on example codes**_.
- Examples are the backbone of this document.  The idea is to save you time and energy
by providing examples for how codes run on ARC systems.
- The approach used here is that the source code for examples is embedded right in the 
text files.
- Put each set of files for the execution of one code (we call them "examples") in one
directory.
- To run these codes---and they have been tested on ARC clusters---simply copy the contents
and paste them into a file (on the clusters).
- For each code or slurm script or bash script or makefile or whatever, a file _**name**_ is
provided.  You can use your own filenames, but very often, those names appear within other 
code files.  For example (and this happens a LOT), say:  code A invokes code B.
If you give a different name to code B than what is specified in these pages, then you have
to modify the contents of code A so that it calls code "whatever-new-name-you-used" rather
than code B.
- So it is most straight-forward to use the file names provided.
- Since there are few files for each example and the files are small to keep examples 
minimalistic, the time required to paste contents of these pages into files using
a text editor is almost zero.
- Also, the reason the codes are placed here and not in some github repo is because 
one can realize a LOT of value by SEEING the codes even if you do not execute them.
(It is recommended that you execute them.)
- This approach makes the text and the code integrated in one place.


## Outline

1. [Overview](overview/concur-overview.md)
2. [Concurrent Paradigms:  Concepts](paradigms/concur-paradigms.md)
3. [Concurrency:  How To Get Into Trouble](trouble/concur-trouble.md)
4. [Concurrency Tools](tools/concur-tools.md)
5. [srun Tool](srun/srun.md)
6. [GNU Parallel Tool](gnu-parallel/gnu-parallel.md)
7. [srun and GNU Parallel Combined](srun-and-parallel/srun-and-parallel.md)
8. [Slurm Job Arrays](slurm-job-arrays/slurm-job-arrays.md)
9. [Python Multiprocessing](python-multiprocessing/python-multiprocessing.md)
10. [Java Threading](java-threading/java-threading.md)
11. [Pthreads](pthreads/pthreads.md)
12. [OpenMP](open-mp/openmp.md)
13. [MPI (Message Passing Interface) Patterns](mpi-patterns/mpi-patterns.md)
14. [Open MPI](open-mpi/open-mpi.md)
15. [MPICH (MPI)](mpich-mpi/mpich-mpi.md)
16. [Intel MPI](intel-mpi/intel-mpi.md)
17. [Python MPI (MPI4Py)](mpi-python/mpi-python.md)
18. [TCP Sockets](sockets-tcp/sockets-tcp.md)
19. [UDP Sockets](sockets-udp/sockets-udp.md)
