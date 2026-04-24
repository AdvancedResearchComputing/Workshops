# Using Multiple `%runscript`s in a Container

##### Navigate

[Back to Main Page](./main-containers.md)


## Summary of this Lesson

1. This lesson starts with the definition file
   from the previous example and simply adds more `%runscript`s
   to it.
2. This demonstrates that a pipeline of commands can 
   reside in one container.

## Preconditions

Do the preconditions in the [Preliminaries](./preliminaries.md) page.



## Build Container From a Definition File



#### Construct the Definition file:  multi_runscript.def.

Create this file in a clean directory on an ARC cluster.
Call it _multi_runscript.def_.

Notes:

1. We bootstrap from continuumio/miniconda3, instead
   of ubuntu:22.04, because we now have python code in the
   container.
2. We copy the _local_ file _tokenize.py_ into the container,
   keeping the same name.
3. In addition to updating apptainer get and installing
   cowsay as before, we now also update conda and change
   the version of python to 3.13 (I think the default
   version is 3.10).
4. We export an updated path for the sake of cowsay.
5. Lastly, under `%runscript` we give not just one command,
   but several (three of the commands are `echo`s).
   These are executed in the order that they appear.
   This is a pipeline.
6. We can also run python in a "script" (`%runscript`) section.
7. The `"$@"` illustrates how a container can take in inputs.
   

```
Bootstrap: docker
# From: ubuntu:22.04
From: continuumio/miniconda3

%files
    # Copy files into container.
    tokenize.py   tokenize.py

%post
    apt-get update
    apt-get install -y cowsay
    conda update -y conda
    conda install -y python=3.13

%environment
    export PATH=$PATH:/usr/games

%runscript
    cowsay "Hello from inside Apptainer!"
    echo " "
    echo "The inputted argument(s) are  $@"
    echo " "
    python tokenize.py    "$@"

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

Issue the command, which uses the above *.def file to
prescribe the build:

```
# Build the .sif image from the definition file
apptainer   build   --fakeroot   pipeline.sif    multi_runscript.def
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
apptainer run  pipeline.sif    "I'm hoping this works ..."
```
or

```
./pipeline.sif   "I'm hoping this works ..."
```

The output should be:

```
 ______________________________
< Hello from inside Apptainer! >
 ------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
 
The inputted argument(s) are  I'm hoping this works ...
 
  The inputted string :  I'm hoping this works ...
  The tokens in the inputted string are:
I'm
hoping
this
works
...
```

#### Method 2:  Run the Image With Tailored Input

On the compute node, run a custom command within the container (here, overriding the input to script cowsay):

```
apptainer exec  pipeline.sif  cowsay   "Did you see the size of that moose?"
```

Note that the `exec` command overrides _all_ of the pipeline:
not only the `cowsay` command, but also the `echo` and `python` commands.
So the pipeline, in this sense, is atomic.

The output is:

```
 _____________________________________
< Did you see the size of that moose? >
 -------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```


Another alterative is to use a completely different 
valid command, such as `ls`:

```
apptainer exec pipeline.sif ls
```

The output for me is:

```
__pycache__  multi_runscript.def  pipeline.sif	run.base.pipeline  run.build.sif  run.container.itself	run.sif.directly  tokenize.py
```


#### Method 3:  Run Within The Container

Issuing the command `shell` command to go inside the container:

```
apptainer shell pipeline.sif
```

will give you a shell inside the container, as noted by the "**Apptainer>**" prompt.

Issue this command:

```
Apptainer> cowsay "hi"
```

... and the response is:

```
 ____
< hi >
 ----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Now enter the python tokenize.py command below (we are still inside the container):

```
Apptainer> python tokenize.py  "Man, it sure is dark in this container."
```
... and the output will be:

```
  The inputted string :  Man, it sure is dark in this container.
  The tokens in the inputted string are:
Man,
it
sure
is
dark
in
this
container.
```


when finished, type `exit` to exit the container.
The command prompt should go back to your normal 
command prompt based on your shell.

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



#### Source Code Files

File _tokenize.py_

```
import sys

my_string=sys.argv[1]
tokens = my_string.strip().split()
num_tokens = len(tokens)

print("  The inputted string : ",my_string)
print("  The tokens in the inputted string are:")

for itime in range(0, num_tokens):
    print(tokens[itime])
```

##### Navigate

[Back to Main Page](./main-containers.md)

[previous lesson:  basic definition file](./def-file-container.md)

[next lesson:  sandbox](./sandbox-and-sif.md)
