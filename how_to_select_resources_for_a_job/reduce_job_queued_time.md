2. [Resource differences across clusters ⬅️ Previous:](./cluster_resources.md)

# How to Get Your Jobs to Spend Less Time in Queued State

## Cluster Dynamics and Slurm Job Priority Calculation
Think of the clusters as resource pools that are constantly under high demand for resources. 
ARC actively assesses the aggregate workload characteristics and attempts to tune job scheduling 
to maintain a sense of "fairness" among job types. The clusters handle over 1M jobs each year: thousands every day. 

Jobs in the queue are assigned a priority score which takes into account several factors:
 1. QOS: "Quality of service"
 2. Fairshare: recent scale of usage by your account
 3. Job age: how long the job has been "eligible"
 4. Job size: larger jobs have slightly higher priority

Commands to understand cluster, partition, QOS, and scheduling dynamics and limits:
1. `showqos`
2. `sprio`
3. `squeue --start`
4. `sjstat -c`

## Options to Reduce Wait time

There are multiple things to try:

- Using partial nodes rather than full nodes.
- Avoid job arrays and pack workloads into a single job where possible
- Inspect partition wait times on Grafana.
- Use short QoS.

Each is presented below.

###  Using Partial Nodes 

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

Example: MPI distributed memory, parallelized with 128 tasks

```
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --mem=196G
```

Giving Slurm flexibility will usually shorten the wait time:
```
#SBATCH --nodes=1-8
#SBATCH --ntasks=128
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-task=1500M
```

### Avoid Job Arrays

Submitting an array job is an easy way to drop hundres or even thousands of identical jobs on the queue all at once.
Each job in the array is considered an independent job for priority and usage calculations. 
If job scheduling was strictly FIFO, then large job arrays would always allow a single person to eventually monopololize a cluster resource.

Use job arrays for the convenience, but be aware that:
 - only a limited number will accrue age-based priority at any given time: Slurm's configuration is "flattening the curve"
 - later jobs in the array will suffer from steadily declining fairshare

In light of those limitations, it will often be beneficial to "move the loop inside the script". Job arrays are often used to run the same workflow on a set of enumerated inputs based on the array ID. A single non-array job with a bash loop would easily do the same thing.

### Use of Dashboards to Assess Partitions

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

4. [Next: ➡️Partitions](./partitions.md)