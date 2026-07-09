# Longer-Running Jobs

Key ideas:

- "Normal" jobs on ARC clusters can run up to seven days.
- There is a way to run longer jobs, up to 14 days.
- This is through the use of the "long" QoS.

There is a normal QoS which is used to run jobs on each cluster
and partition.
However, there is also a "long QoS" which enables
jobs to run for longer durations, up to 14 days.

The QoS options for each cluster are given below:
- [TC QoS Table](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html#quality-of-service-qos)  
- [Owl QoS Table](https://docs.arc.vt.edu/resources/compute/01owl.html#quality-of-service-qos)
- [Falcon QoS Table](https://docs.arc.vt.edu/resources/compute/02falcon.html#quality-of-service-qos)  

Note that jobs run with the long QoS have the same billing factor
as do jobs run with the normal QoS, but the job priority is lesser.
Also, the amount of resources (numbers of CPUs and GPUs,
amount of memory) that you request must be below
specified limits and these limits are _LESS THAN_
those for the "normal QoS."
Typically, the resource limits for long QoS are about
1/4 those for the normal QoS.
See the links above.

There are additional limitations on resources at the account
level; again, see the links above.

To run with the long QoS, your specified job duration
(with, e.g., `#SBATCH --time=14-00:00:00) must be no more
than 14 days.

Examples showing the syntax for QoS specification in an sbatch slurm script:
- `#SBATCH --qos=tc_h200_normal_long`
- `#SBATCH --qos=owl_normal_long`
- `#SBATCH --qos=fal_a30_normal_long`
  