# Creating Sandbox and Converting to Container

##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. Demonstrate how to build and insert software into a sandbox.
   1. The sandbox is intentionally `writable` so that you can 
      build up the software in it.
2. Demonstrate how to convert the sandbox to a container.
   1. The container is then _fixed_.
3. Illustrating how to run codes outside of the container.
   1. Use the `exec` and `bind` commands.

## Preconditions

Do the preconditions in the [Preliminaries](./preliminaries.md) page.


#### Create a Sandbox

The command to create the sandbox called _my_sandbox_, that 
starts with ubuntu v22.04:

```
apptainer build --sandbox my_sandbox/ docker://ubuntu:22.04
```

Specifically,
in the above command, the `docker://ubuntu:22.04` part is a URI
(Uniform Resource Identifier) for a remote Docker image. 
It is a pointer for Apptainer to download the official
`ubuntu:22.04` image from Docker Hub,
convert its layers into the Apptainer format,
and populate the `my_sandbox/` directory.
So it is bootstrapping the contents of the sandbox.

The format is:

```
apptainer build --sandbox <directory_name_for_sandbox>  <initial-docker-image>
```


#### Enter the Sandbox

We enter the sandbox via the apptainer `shell` command.

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



