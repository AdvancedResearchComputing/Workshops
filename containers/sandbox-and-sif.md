# Creating Sandbox and Converting to Container

##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. Demonstrate how to build and insert software into a sandbox.
   1. The sandbox is intentionally `writable` so that you can 
      build up the software in it.
2. Demonstrate how to convert the sandbox to a container.
3. Illustrating how to run codes outside of the container.
   1. Use the `exec` and `bind` commands.

## Preconditions

1. You are on a compute node.
2. You have loaded the apptainer module:
   1. `module reset`
   2. `module load apptainer`.


#### Create a Sandbox

The command to create the sandbox called _my_sandbox_, that 
starts with ubuntu v22.04:

```
apptainer build --sandbox my_sandbox/ docker://ubuntu:22.04
```

#### Enter the Sandbox

Note that we use:
1. `writable` to change the contents of the sandbox.
2. `fakeroot` in case we need elevated privileges to add software.

```
apptainer shell --writable --fakeroot my_sandbox/
```

#### Update the `apt-get` Command That is Used to Install Software

```
apt-get update && apt-get upgrade -y
```

#### Install the Software That We Want

We will only install python3 here.

```
apt-get install -y python3
```

Check the python3 version that is installed in the sandbox.

```
python3 --version
```

#### Exit Out of the Container


```
exit
```

#### Convert the Editable Sandbox into a Read-Only Container

Build the read-only container _my_py310_container.sif_ from
the sandbox.

```
apptainer build   my_py310_container.sif    my_sandbox/
```

#### Run a Python Code

We have the file _main.02.py_ in _/scratch/ckuhlman_ from a previous lesson.
This code just adds _c = 2 + 3 = 5_ and prints the result to screen.

```
apptainer exec --bind /scratch/ckuhlman my_py310_container.sif python3 /scratch/ckuhlman/main.02.py
```

Note that if we leave off the `bind` command and instead use

```
apptainer exec my_py310_container.sif python3 /scratch/ckuhlman/main.02.py
```

then an error will result because the container cannot see the _/scratch/ckuhlman_ directory.








#### Finished

We are finished your container work, so you can:

1. exit (off the compute node).
2. scancel (if you use the `salloc` command; the `interact`
   command will release compute resources automatically).


> [!NOTE]
> Over all ARC systems, not `scancel`ing (i.e., giving back) 
> resources from interactive jobs when you
> are done with them is a HUGE source of wasted resources.

> [!NOTE]
> This is a waste of resources for you and for all users.



