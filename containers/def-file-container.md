# A Basic And Often-Used Use Case (Using a Definition File) in Building and Executing a Container

##### Navigate

[Back to Main Page](./main-containers.md)


## Summary of this Lesson

1. We introduce an apptainer definition file.
2. We show how to build the container.
   - Use of `fakeroot` utility to "obtain" the permissions
     to build the container.
3. We use this container as a vehicle to emphasize the 
   three main ways to execute a container (or execute code
   or an environment inside the container):
   - `run`:  runs the "default" code (i.e., the code that
     is in the container).
   - `exec`:  to use the container environment to run
     codes specifically not in the container (but it uses
     the container's environment).
   - `shell`:  to get into the container and execute within
     it (very crudely, it is like invoking the python interpreter,
     via `python`, on the command line, so that you can enter
     individual python commands and they will be executed).
4. There are other ways to execute/use a container, including `test` and
   `instance start` but these are not covered here.


## Build Container From a Definition File

Preconditions:  You are on a compute node.


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
- %app:  Defines the separate codes that you can run within
  a container.




#### Build the Apptainer *.sif On a Compute Node

Issue the command, which builds the container 
based on the above defintion file:

```
# Build the container (.sif) image from the definition file
apptainer build --fakeroot moo-me.sif moo-me.def
```

### Three Ways to Run Within an Apptainer Image (*.sif File)

You can run a container in one of three ways:

1. Run the default command (the one under `%runscript`) with
   the `run` command.
2. Run a customized command with `exec` (overriding the 
   command(s) under `%runscript`)
3. Enter the container interactively for manual execution
   using the `shell` command.

#### Method 1:  Run the Image As-Is (i.e., With the Default Command)

On the compute node, run the predefined command within the image:

```
apptainer run moo-me.sif
```
or

```
./moo-me.sif
```


#### Method 2:  Run the Image With Tailored Input

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
up from the current directory where the container
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
three directories and one file (README.txt) **ON THE HOST MACHINE.
But the only directories and files that the container
can access (i.e., knows about) are those in the container.
It only
knows about the single directory that is part of the path
to this container.

#### Method 3:  Run Within The Container

Issuing the command 

```
apptainer shell moo-me.sif
```

will give you a shell inside the container, as noted by the "**Apptainer>**" prompt.

Issue this command:

```
cowsay "I'm inside; let me out."
```

and it will be printed to screen.

when finished, type "exit" to exit the container.

##### Finished

We are finished, so you can
1. exit (off the compute node).
2. scancel (if you use the `salloc` command).

> [!NOTE]
> Over all ARC systems, not `scancel`ing (i.e., giving back) 
> resources from interactive jobs when you
> are done with them is a HUGE source of wasted resources.

> [!NOTE]
> This is a waste of resources for you and for all users.


##### Navigate

[Back to Main Page](./main-containers.md)


