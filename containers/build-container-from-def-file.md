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


#### Load Module on the Compute Node

```
module reset
```

```
module load apptainer
```

#### Build the Apptainer *.sif On a Compute Node

Reissue the command:

```
# Build the .sif image from the definition file
apptainer build --fakeroot moo-me.sif moo-me.def
```

### Three Ways to Run Within an Apptainer Image (*.sif File)

You can run a container in one of three ways:

1. Run the default command (the one under `%runscript`) with
   the `run` command.
2. Run a customized command with `exec` (overriding the 
   command under `%runscript`)
3. Enter the container interactively for manual execution
   using the `shell` command.

#### Run the Image As-Is

On the compute node, run the predefined command within the image:

```
apptainer run moo-me.sif
```
or

```
./moo-me.sif
```


#### Run the Image With Tailored Input

On the compute node, run a custom command within the container (here, overriding the input to script cowsay):

```
apptainer exec moo-me.sif cowsay "Moooo to youuuuuu"
```

Another alterative is to use a completely different 
valid command, such as `ls`:

```
apptainer exec moo-me.sif ls
```

The following command is an illustration of 
the difference between the contents of the
container and the host machine on which the
container is running:

```
apptainer exec moo-me.sif ls ../..
```

The output from this command, on my machine is

```
simple-from-def-file
```

This directory is the name of the second parent directory
from the current directory where the container
resides.

If we issue this almost-identical command (but now
with `*`):

```
apptainer exec moo-me.sif ls ../../*
```

we get:

```
/usr/bin/ls: cannot access '../../README.txt': No such file or directory
/usr/bin/ls: cannot access '../../simple-from-apptainer-library': No such file or directory
/usr/bin/ls: cannot access '../../simple-from-docker-hub': No such file or directory
../../simple-from-def-file:
try01
```

In fact, at two parent directories up, there are a total of
three directories and one file (README.txt).
But the only directories and files that the container
can access are those in the container, it only
knows about the single directory that is part of the path
to this container.


##### Finished

We are finished, so you can
1. exit (off the compute node).
2. scancel (if you use the `salloc` command).


##### Navigate

[Back to Main Page](./main-containers.md)


