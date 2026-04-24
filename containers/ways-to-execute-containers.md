# Primary Ways for Executing a Container

##### Navigate

[Back to Main Page](./main-containers.md)


## Summary of this Lesson

1. We use the container built in the previous lesson
   as a vehicle to emphasize the 
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
2. There are other ways to execute/use a container, including `test` and
   `instance start` but these are not covered here.


## Build Container From a Definition File

Do the preconditions in the [Preliminaries](./preliminaries.md) page.

Build the container on the [previous lesson](./def-file-container.md).




## Three Ways to Run Within an Apptainer Image (*.sif File)

(*.sif file, container, and [Apptainer] image are all ways to 
refer to a container.)

You can run a container in one of three ways:

1. Run the default command (the one under `%runscript`) with
   the `run` command.
2. Run a customized command with `exec` (overriding the 
   command(s) under `%runscript`)
3. Enter the container interactively for manual execution
   using the `shell` command.

#### Method 1:  Run the Image As-Is (i.e., With the Default Command)

On the compute node, run the predefined command within the image.

This way is preferred.

```
apptainer run moo-me.sif
```

This way will work, but is less desirable because it does not
fit the format for invoking containers in more exotic ways.

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

[previous lesson:  build container with definition file](./def-file-container.md)

[next lesson:  multiple %runscript's](./multiple-runscripts.md)
