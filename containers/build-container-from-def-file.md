# Containers on ARC Clusters

# ---- IN PROGRESS ----

##### Navigate

[Back to Main Page](./main-containers.md)



## Build Container From a Definition File


#### Construct the Definition file:  moo-me.def.

Create this file in a clean directory on an ARC cluster.
Call it "moo-me.def."


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
have to remember to relinquish resources with **scancel** command.)

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


#### Build the Apptain On a Compute Node

Reissue the command:

```
# Build the .sif image from the definition file
apptainer build --fakeroot moo-me.sif moo-me.def
```

#### Run the Image As-Is

On the compute node:

```
./moo-me.sif
```

#### Run the Image With Tailored Input

On the compute node, overwrite the text to 
print out:

```
apptainer exec moo-me.sif cowsay "Moooo to youuuuuu"
```

##### Finished

We are finished, so you can
1. exit (off the compute node).
2. scancel (if you use the `salloc` command).


##### Navigate

[Back to Main Page](./main-containers.md)


