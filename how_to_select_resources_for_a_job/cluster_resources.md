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

- Tinkercliffs (TC):  [TC resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
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
2. A GPU will not help and asking for one would be wasteful in several ways (wait time, idle resource).

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

We need to dig a little deeper.  On the Tinkercliffs resources page,
you see in the first table TWO types of CPU-based compute nodes:
1. Base Compute Nodes
2. Intel Nodes 

It is only the former that have 128 cores.
So we cannot accept ANY compute node from the normal_q
(the normal_q is the partition that contains the CPU-based compute nodes).
Rather, we need the "base compute nodes," which are AMD nodes
(see in the table "AMD EPYC 7702").

When a partition has more than one type of compute node, you need to 
use the `--constraint` switch to specify which type of compute node,
if you require a particular type of compute node for your computations.
Here, the constraint would be:

`#SBATCH --constraint=amd`

and this line would go near the `#SBATCH --partition` command 
(not because it has to from a correctness point of view, but because
the two switches are highly related from a logical point of view).

This is not the end of the story.
Be prepared to wait in queue a long(er) time to run a job that uses all cores
of a compute node. 
You may decide to try to *minimize time-to-completion* (queue time + processing time):
ARC clusters are always busy. It takes Slurm time to free these resources and
it might well be better to specify say, 96 or 64 cores of the 128, and
then increase your "time" parameter (because your job will presumably
take longer with 64 cores than 128 cores [but not always]).

Also, you see large and huge memory nodes with 128 cores.
We do not want to specify a 128 core job to run on a large or 
high memory node when our memory requirements are small.
This is using resources that are in demand (there are few large and high
memory nodes) for a purpose not that is inconsistent with their
features.

So if we use some of this advice and specify only 64 cores,
then both types of compute nodes (the AMD nodes and the Intel nodes) have
64 cores and 25G of memory, and therefore we can use either type.
Hence, in the snippet below from an sbatch slurm script, we
do not have to use a `--constraint` switch.


```
# Targeting Tinkercliffs for large pool of nodes with 128 cores
#SBATCH --partition=normal_q
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --memory=25G
```

With all of the preceding discussion of resources and possible use of `--constraint`,
one may wonder why we have all of this nuance.
The answer is:  because it increases job and computational throughput on
the clusters.
By combining CPU-based nodes into one partition, and letting Slurm
choose the type of compute node to use---in cases where the type
of compute node does not matter---then Slurm has more options to run
your job faster.
The data show this.






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
- We need one compute node (because we are using threads).
- We cannot use the Falcon cluster (no CPU-based nodes).
- The choice is either TC or Owl.
  
We see that the maximum memory per compute node on conventional
TC CPU nodes is 368 GB per node.
And there are only 16 of these nodes.
On Owl, the maximum memory is greater than 2x that of TC:  747 GB per node.
I would choose to run my code on Owl "AMD EPYC 9454 - Genoa" nodes.
Also, there are 160 of these nodes.

So a snippet of your sbatch slurm script,for Owl, will look like:

```
#SBATCH --partition=normal_q
#SBATCH --constraint=avx512
```

Now, what if you need more memory than what TC standard nodes
(i.e., NOT high memory nodes) can provide, say 480G?
In this case, BOTH types of standard Owl nodes (AMD Genoa
and AMD Milan) can provide 480G of memory.
Hence, we can use either type of compute node.
Thefore, we do NOT specify a constraint.
We simply specify the partition, immediately below, and do
not specify a constraint so that Slurm knows that it 
can allocate any type of normal_q compute node to your job,
thereby potentially reducing its wait time.

 
```
#SBATCH --partition=normal_q
```



If you run a job and you get an OOM error (Out of Memory error),
then you can do any of:

1. decrease the number of cores (threads).
2. rearrange your work to demand less memory (may be impossible).
3. you can go to the large or huge memory nodes.

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

See [GPU Essentials Workshop](https://github.com/AdvancedResearchComputing/Workshops/tree/main/GPU_Essentials)


#### Final Notes

There are many ARC resources for partitions and constraints.
See:
1. [ARC docs page on constraints](https://docs.arc.vt.edu/usage/job_scheduling/02_slurm_options.html).
2. [several videos on how to submit sbatch jobs](https://docs.arc.vt.edu/usage/video.html#how-to-run-codes-your-own-or-commercial-open-software)
:  simple jobs and those with constraints. 
---
3. [Next: ➡️ Reduce time your job spends in queue](./reduce_job_queued_time.md)
