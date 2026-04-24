# Useful Commands

These are commands beyond the standard commands we have been using,
which are also useful.


##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. We list here generic commands that can be used with
   all/most containers.
2. The list is small now, but we intend it to grow.


###### To see the directory structure within a container

```
apptainer exec <container_name.sif>  ls -l /
```


###### For a container that houses a virtual environment

To see the packages in a conda virtual environment

```
apptainer exec <container_name.sif> conda list
```


##### Navigate

[Back to Main Page](./main-containers.md)


[previous lesson:  container and Slurm batch jobs](./slurm-jobs.md)
