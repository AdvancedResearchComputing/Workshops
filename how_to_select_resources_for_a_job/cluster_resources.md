## Differences in Cluster Resources

ARC documentation contains details on the components (compute elements, volatile memory,
etc.) of clusters.
Be familiar with them.
(Also, in the late summer/fall 2026 timeframe, new resources will come online.)

The resource pages are:

- TC:  [tc resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
- Owl:  [owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
- Falcon:  [falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  

#### Example 1.

_Requirement_:

You have a CPU-based job.
It implements parallelism through threading.
I want as many workers as possible.
My memory requirements are pretty light (i.e., low).

_Solution_:

You can only run on one compute node because the code has no distributed
processing capabilities.

By looking at the clusters, we see that Falcon has no CPU-only nodes.
It is a GPU-based cluster.
You cannot just use the CPUs of a GPU node because that can potentially
cut off users from using the GPUs---which is the purpose of having a GPU-based
cluster.

So your choices are to run on Owl or TC.
We see that the maximum number of cores on conventional CPU nodes
is 128.
On Owl, it is 96.
I would choose to run my code on TC AMD EPYC 7702 nodes, with 128 cores
per node.

This is not the end of the story.
Be prepared to wait in queue a long(er) time to run a job that uses all cores
of a compute node.
It takes slurm time to free these resources.
It might well be better to specify say, 100 or 70 cores of the 128, and
then increase your "time" parameter (because your job will presumably
take longer with 70 cores than 128 cores [but not always]).

Also, you see large and huge memory nodes with 128 cores.
We do not want to specify a 128 core job to run on a large or 
high memory node when our memory requirements are small.
This is using resources that are in demand (there are few large and high
memory nodes) for a purpose not that is inconsistent with their
features.


#### Example 2

_Requirement_:

Like Example 1, you have a CPU-based job.
It implements parallelism through threading.
But now, I do not need a great number of threads;
rather, I need memory because each thread requires
significant memory for processing.


_Solution_:

Much of the early part of this solution is the same as for Example 1.
But at the end, we are driven to the opposite conclusion.

As before:
- We need one compute node.
- We cannot use the Falcon cluster.
- The choice is either Owl or Falcon.
  
We see that the maximum memory per compute node on conventional
TC CPU nodes is 368 GB per node.
And there are only 16 of these nodes.
On Owl, the maximum memory is greater than 2x that of TC:  747 GB per node.
I would choose to run my code on Owl "AMD EPYC 9454 - Genoa" nodes.
Also, there are 96 of these nodes (relatively soon to be doubled).

If you run a job and you get an OOM error (Out of Memory error),
then you can either decrease the number of cores (threads)
or you can go to the large or huge memory nodes.

When you have choices as to what resources you run on, all other things
being equal, choose the resource type that is most plentiful.
It gives the best chance that more of these resources will be available
over time (again, all else being equal), so your job is likely to start
sooner.
If, on the other hand, you want the precious few resources, you 
may have to wait longer.
Again, the dashboards (below) are useful for reasoning about these
issues.

#### Example 3

_Requirement_:

I have a need to do HPC computing with GPUs.

Which GPUs should I use.

_Solution_

We address this in Section XXXX below.


---
[Next: File systems ➡️](02_file_systems.md)
