1. [Motivation ⬅️ Previous:](./motivation.md)

## Differences in Cluster Resources

ARC provides documentation that contains details on the components (compute elements, volatile memory,
etc.) of clusters.
Use these as a reference when designing your workloads and assessing which cluster(s)/partition(s) to run on.
Additions, updates, and changes are communicated through several channels:
 - emails to the ARC users email list
 - ARC Town Hall sessions (3x each semester)
 - ARC documentation site: https://docs.arc.vt.edu

The resource pages for the main three current clusters are:

- Tinkercliffs:  [TC resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
- Owl:  [Owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
- Falcon:  [Falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  

#### Example 1.

_Requirement_:

You have a CPU-based job.
It implements parallelism through threading.
I want as many workers as possible.
My memory requirements are pretty light (i.e., low).

_Implications_:
1. Single node jobs: The workload can only run on one compute node because the code has no distributed processing capabilities.
2. A GPU will not help and asking for one would be wasteful in several ways (wait time, idle resource)

_Solution_:
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
You may decide to try to *minimize time-to-completion* (queue time + processing time):
ARC clusters are always busy. It takes Slurm time to free these resources and
It might well be better to specify say, 96 or 64 cores of the 128, and
then increase your "time" parameter (because your job will presumably
take longer with 64 cores than 128 cores [but not always]).

Also, you see large and huge memory nodes with 128 cores.
We do not want to specify a 128 core job to run on a large or 
high memory node when our memory requirements are small.
This is using resources that are in demand (there are few large and high
memory nodes) for a purpose not that is inconsistent with their
features.

```
# Targeting Tinkercliffs for large pool of nodes with 128 cores
#SBATCH --partition=normal_q
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --memory=25G
```

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

Which GPUs should I use?

_Solution_

We address this in Section XXXX below.


---
3. [Next: ➡️ Reduce time your job spends in queue](./reduce_job_queued_time.md)
