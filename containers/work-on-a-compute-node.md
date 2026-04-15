# Preliminaries

##### Navigate

[Back to Main Page](./main-containers.md)


#### Basic Operations

In generating a container, there are operations 
that are common to set up:

1. Start an interactive job to get resources on a compute node.
2. Load the apptainer module in terminal windows where you 
   will issue apptainer commands.
3. Relinquish/release the compute node resources
   when you are done with your container work.

Each of these is discussed below.

#### Trying to Run on a Head Node

On a head node, you do not have proper permissions
to run apptainer.
Run on a compute node.
You will most likely generate errors if you try
to build a container on a head node.

#### Request Resources On A Compute Node:


Option 1 (Preferred)

```
interact --partition=normal_q  --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
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

On the node where you are doing container work, 
issue these module commands to set up your basic environment.


```
module reset
```

```
module load apptainer
```



##### Finished

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



