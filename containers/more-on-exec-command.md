# Containers on ARC Clusters

# ---- IN PROGRESS ----

##### Navigate

[Back to Main Page](./main-containers.md)



## More on Exec


Basic Syntax

The core format for a bind mount is src[:dest[:opts]]: 

src: The absolute path to the directory or file on your host system.

dest: (Optional) The path where you want it to appear inside the container.

opts: (Optional) Mounting options like ro (read-only) or rw (read/write). 

apptainer exec --bind <host_path>[:<container_path>] <container_image.sif> <command>


### TODO

We want to show examples where we invoke codes outside of the container, using
and not using "bind."



##### Navigate

[Back to Main Page](./main-containers.md)


