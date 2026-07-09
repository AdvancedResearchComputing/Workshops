# How to Get Your Jobs to Spend Less Time in Queued State

There are multiple things to try:

- Using partial nodes rather than full nodes.
- Inspect partition wait times on Grafana.
- Use short QoS.

Each is presented below.

###  Using Full Nodes Versus Parts of Nodes

#### Backing Away From a Full Node

This was covered in an example above, but because the
effect---at times--can be so large, we separate it out here.

When you select all of the resources on a compute node, 
it can take slurm (the job scheduler) a long time to 
free up a complete compute node.
If possible, instead, specify a (large) fraction of a node's
resources; this might reduce the time your job remains queued
(before it starts to run).


#### Specifying Pieces of Many Nodes

**<< MATT, I DON'T KNOW IF I HAVE THIS RIGHT; IF I'VE UNDERSTOOD YOUR OBSERVATIONS>>**

A significant fraction of jobs are scheduled by slurm
using a technique called "backfill."
Slurm essentially schedules jobs by a formula that 
produces a priority ranking for each job.
It then runs jobs in that order.

But when this is done, as you might imagine, there are
(small) "holes" left in the schedule where resources are
idle.
A simplified example:  in scheduling high priority jobs,
there are three CPUs that are not being used for four
hours each.

Slurm will go back to the jobs submitted and waiting to be run
and find (smaller) jobs that will fit into these vacant
"resource slots."

The upshot is that small jobs have a better chance of 
being chose to fill these unused resources, i.e.,
small jobs are often better candidates for backfill.

As a result of this concept, consider the following.
You have a distributed CPU job or a distributed GPU job.
Rather than specify that all of the resources 
you need be run on one compute node, specify that the
resources can come from multiple compute nodes.
In this way, you are telling slurm that it can run 
your job using "small hunks of resources" from a
combination of several compute nodes.

Another example using the same setup.
Suppose you have a parallel job, but it can be run
in an embarrassingly parallel fashion.
If you "carve up" the data so that each piece of data can
be run (operated on) by a single CPU as an individual job, you may
be able to get lots of individual CPU jobs done before
many CPUs become available, at one time, to do all of your work as 
one job.

### Use of Grafana Dashboards to Select Partitions

ARC provides many different dashboards to obtain
cluster information.

See the [root page of the dashboards](https://dashboard.arc.vt.edu/)
for a full listing.

For our purposes here, we view the
[time wait dashboard](https://dashboard.arc.vt.edu/d/fej6n6nqfytc0f/arc-cluster-wait-times?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=$__all&var-partition=$__all&var-timelimit=$__all&refresh=1m)
that contains
HISTORICAL wait times
(versus predicted future wait times) for jobs in cluster partitions
and the number of jobs currently waiting to run in each partition.

### Short QoS

There is a normal QoS which is used to run jobs on each cluster
and partition.
However, there is also a "short QoS" which gives
higher priority to jobs (so that they start sooner).
The QoS options for each cluster are given below:
- [TC QoS Table](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html#quality-of-service-qos)  
- [Owl QoS Table](https://docs.arc.vt.edu/resources/compute/01owl.html#quality-of-service-qos)
- [Falcon QoS Table](https://docs.arc.vt.edu/resources/compute/02falcon.html#quality-of-service-qos)  

Note that jobs run with the short QoS have a greater billing factor
(by a factor of two) than do jobs run with the normal QoS.
But if you do not use all of your monthly compute units
(or even if you do), then this may be a viable option.
Also, the amount of resources (numbers of CPUs and GPUs,
amount of memory) that you request must be below
specified limits but these limits are _GREATER THAN_
the "normal QoS" limits; see the links above.

There are additional limitations on resources at the account
level; again, see the links above.


To run with the short QoS, your specified job duration
(with `#SBATCH --time=1-00:00:00) must be no more
than one day, which is less than the 7-day "normal QoS"
time limit.

Examples showing the syntax for QoS specification in an sbatch slurm script:
- `#SBATCH --qos=tc_h200_normal_short`
- `#SBATCH --qos=owl_normal_short`
- `#SBATCH --qos=fal_a30_normal_short`
