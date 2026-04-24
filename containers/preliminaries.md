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

In this sections, there are three cases:
- working on Owl cluster.
- working on TC cluster.
- working on Falcon cluster.

The issue that varies for Owl and TC is the use of `--constraint`.
Both use `--constraint` but the value assigned to constraint is
different.
the Falcon cluster does not use `--constrait`.

You can see here for more details:
[working with constraints](https://docs.arc.vt.edu/usage/job_scheduling/01_slurm_overview.html#slurm-constraints),
but the bottom line is this.
The `normal_q` partition on each of the Owl and Tinkercliffs clusters
has more than one type of compute node.
`--constraint` enables you to specify which type of 
compute node architecture you run on.
If you do not care which one you run on, then you do
not have to specify the `--constraint` switch.
In many cases you do not have to care.
But in this case---in building containers---you do have to 
care
(actually, there are cases when you do and do not have to 
care when building containers, but instead of getting into all
of that nuance, just "care" by using `--constraint` and you
can avoid possibly very subtle, hard to find errors).

The constraint values specified below for each of Owl and TC
are designed to give you access to the greatest pool of 
compute nodes.

Currently, Falcon only has homogeneous partitions, so no `--constraint` is
needed.

> [!NOTE]
> Best practice is to always use `--constraint` with `normal_q`
> on TC and Owl.  While for many build processes `--constraint` 
> is not expressly needed, using `--constraint` with
> `normal_q` does no harm.
> And, in the cases where it is needed, like when using
> **sandboxes**, then you are automatically covered.

Also, the difference between Option 1 and Option 2 is `interact` 
versus `alloc`.
ARC prefers you to use `interact` because `interact` automatically
frees resources when you log off a compute node.

> [!NOTE]
> When you use `salloc`, _**YOU**_ have to remember to release those
> resources using `scancel`---for if you do not, then those
> resources sit idle and no one
> else can use them until your reservation expires.

> [!NOTE]
> Resource wastage because of idle resources is one of the 
> biggest sources of waste on the ARC clusters.


##### Working on Owl Cluster

In these options, you have to insert/override the values of `--account`
with an account that you have.

Option 1 (Preferred)

```
interact --partition=normal_q  --constraint=avx512 --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```


Option 2 (Not Preferred---Because when done, **YOU** 
have to remember to relinquish resources with **scancel** command.)

```
salloc --partition=normal_q  --constraint=avx512 --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```

##### Working on Tinkercliffs Cluster

In these options, you have to insert/override the values of `--account`
with an account that you have.

Option 1 (Preferred)

```
interact --partition=normal_q  --constraint=amd --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```


Option 2 (Not Preferred---Because when done, **YOU** 
have to remember to relinquish resources with **scancel** command.)

```
salloc --partition=normal_q  --constraint=amd --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```

##### Working on Falcon Cluster

In these options, you have to insert/override the values of `--account`
with an account that you have.

Option 1 (Preferred)

```
interact --partition=l40s_normal_q  --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```


Option 2 (Not Preferred---Because when done, **YOU** 
have to remember to relinquish resources with **scancel** command.)

```
salloc --partition=l40s_normal_q   --account=arcadm  --nodes=1  --tasks-per-node=1  --cpus-per-task=1  --time=2:00:00
```

<< Do Work >> 

Then when done with work:

1. exit
   1. (to get off of the compute node).
2. squeue -u $USER
   1. (to get the PID of the `salloc` job); this is why `interact` is preferred.
3. scancel PID
   1. (for `salloc` job, to give back the resources that you have been granted by slurm that you used to do your work).


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

We repeat the above notes:


> [!NOTE]
> Over all ARC systems, not `scancel`ing (i.e., giving back) 
> resources from interactive jobs when you
> are done with them is a HUGE source of wasted resources.

> [!NOTE]
> This is a waste of resources for you and for all users.


##### Navigate

[Back to Main Page](./main-containers.md)

[previous lesson:  concepts](./concepts.md)

[next lesson:  definition file container](./def-file-container.md)
