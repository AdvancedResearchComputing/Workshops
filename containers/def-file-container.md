# Building a Basic Container Using a Definition File

##### Navigate

[Back to Main Page](./main-containers.md)


## Summary of this Lesson

1. We introduce an apptainer definition file.
2. We show how to build the container.
   - Use of `fakeroot` utility to "obtain" the permissions
     to build the container.
3. Another major way is to use `sandbox`es, which we cover later.


## Build Container From a Definition File

Do the preconditions in the [Preliminaries](./preliminaries.md) page.


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
based on the above defintion file.

When invoking the following command to build the container
`moo-me.sif` from the definition file `moo-me.def`, you
might want to watch the build output from apptainer.
It can be instructive to see how these containers are built.

```
apptainer build --fakeroot moo-me.sif moo-me.def
```

Notice the use of `--fakeroot`.
This is a utility that obtains a
state that enables apptainer to think that you have
the necessary permissions to complete apptainer tasks.


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

[previous lesson:  concepts](./preliminaries.md)

[next lesson:  executing containers](./ways-to-execute-containers.md)
