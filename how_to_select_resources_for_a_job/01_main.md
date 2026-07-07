# How to Select (Compute) Resources for a (Slurm) Job

---
[Next: File systems ➡️](02_file_systems.md)

## Topics

## Resources That Can be Requested for a Job

Below are sections from two sbatch slurm scripts, which are used to 
submit batch jobs on a cluster.

The sections provided are where resources are specified.
These give a sense of what resources can (or have to) be
specified, and hence what features of the cluster to understand.


Illustrative resources for a GPU-based slurm job
(for the Tinkercliffs [TC or tc] cluster).
Other cluster resource specifications are similar.

```
#!/bin/bash
#SBATCH --account=arcadm
#SBATCH --job-name=mliap
#SBATCH --time=2-1:00:00
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#
# Load modules
# Invoke your code
```

Illustrative resources for a CPU-based slurm job
(again for TC, but are similiar for other nodes).

```
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --account=arcadm
#SBATCH --job-name=MPI-job
#SBATCH --time=14:00:00
#SBATCH --partition=normal_q
#SBATCH --constraint=amd
#SBATCH --ntasks=10
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output slurm.tc.amd.open.mpi.01.%j.out
#SBATCH --error slurm.tc.amd.open.mpi.01.%j.err
#SBATCH --mem=100GB
#
# Load modules
# Invoke your code
``` 

Some questions motivated by these data above.

1. Is my code a serial code or a parallel code.
   - If a serial code, I will use one core (CPU) of one compute node.
   - If a parallel code ...
     - Am I using CPUs to achieve parallelism?
     - Am I using GPUs to achieve parallelism?
     - Am I using both?
2. How many processes will I have?
   - If a serial code, there will be one process.
   - A parallel code may have one process or many.
     - A purely threaded code will have one process.
     - A distributed code will have at least two processes.
     - Again, here, you can have both:  threading and distribution.
3. How much memory do I need?
   - If it is a serial code, I might specify twice the size of my input data, as a start.
   - If it is a parallel code, I might run my code across several compute nodes
     and specify memory on a per-compute-node basis (as is done with `#SBATCH --mem=100GB` above). 

This is not a workshop on how to design codes, but these three categories 
of questions above have impacts on all of the parameters listed in the
two examples above:  time, partition, constraint, nodes or ntasks, ntasks-per-node,
cpus-per-task, mem, and gres.
And in turn, these parameters and their values affect which resources you should
choose to run your jobs.

Best practices:  many of these sbatch slurm script parameters have defaults.
Do not use the defaults.  Specify everything.

================================================



1. Parameters that you can specify for a job
   - number nodes, cpus, num gpus, memory, etc.
2. How these parameters vary across clusters
   - The ARC web pages:
     - TC:  [tc resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
     - Owl:  [owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
     - Falcon:  [falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  
   - Examples
     - show some features from ARC docs.
   - Comparisons
     - Memory per CPU node:  Owl up to 3x that of TC.
     - Numbers of nodes:  On TC, there are 19x more AMD CPU nodes than Intel nodes
       - So if you are using python code and virtual environments (VEs), then consider
         making the VE on an AMD node.
         This way, when you need to run your code---using the same type of compute node used
         to make the VE---you will have 19x the number of compute nodes to run your jobs.
3. Unique features of clusters
   - Owl has large (4 TB) and huge (8 TB) memory CPU-based nodes for "large memory" computing jobs.
   - OTHERS?????
4. Know the types of GPUs that are best suited for your jobs
   - Examples:
     - A30 (Falcon):  best for XXXXX.
     - L40S (Falcon):  best for XXXXX.
     - H200 (TC):  best for XXXX.
     - B200 (Owl) [coming]:  best for XXXX.
5. Attempting to minimize your job's wait time.
   - That is, the time from job submission until it begins to run.
   - See the Grafana dashboards to see the most heavily used clusters/partitions, and historical wait times.
     - [time wait dashboard](https://dashboard.arc.vt.edu/d/fej6n6nqfytc0f/arc-cluster-wait-times?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=$__all&var-partition=$__all&var-timelimit=$__all&refresh=1m)
6. Input/output (I/O) Speeds
   - If you have a lot of disk/storage access,
     read from and write to `/scratch`; much faster than `/projects`
   - If your code is small enough, use "localscratch";
     faster than `/scratch`.
7.  Using different storage, lifetime of data
   - `/projects`:  permanent.
   - `/scratch`:  only 90 days.
   - "localscratch":  only for the life of slurm job.
     - This means, for localscratch, that _**as part of the batch job**_,
       you must move data into local scratch and copy out results.
       - Why?
         - Because before the job starts, there is no localscratch,
           so you cannot bring data in ahead of time.
         - Because after the job finishes, the localscratch memory disappears,
           so if you do not copy out your results files, they will be deleted.
8.  Delays in obtaining a full node.  Can you go with fewer resources,
    e.g., fewer CPUs?  Job may take longer, but it may start much sooner.
9.  User QoS
   - There is a QoS table on each of the cluster's pages, given above.
   - Can run jobs up to 14 days with "long" QoS.
   - If your group consistently does not use its monthly computing units budget,
     you can increase your job priority by using "short" QoS.
      - But the billing rate is double the "normal" QoS, by design.
      - But the maximum duration of a job is one day; for "normal" QoS, it is seven days, by design.  
10. Choosing type of job:  interactive or batch
   - General guidelines
     - Interactive jobs 
       - You are doing scoping studies and you want to:
          - determine what the analysis steps are
          - see intermediate results
          - (e.g., you are exploring and uncertain.)
       - You need visualization.
       - You have very few jobs to run.
     - Slurm batch jobs.
       - You know your analysis steps, or you may have only one or two issues to resolve.
       - You are doing scoping studies, but you do not need to see 
         on-the-fly intermediate results; only the results are sufficient.
       - You do not need visualization in the job.
       - You have many, many jobs to run (say, 15 or more)
   - Maximum-benefit choice for you and for everyone else.
     - If you can run either way:  interactive or batch.
       - Choose batch job.
         - Why?
           - The slurm scheduler can make far better use of resources.
           - EVERYONE benefits when this happens.
           - Specifics
             - (1) Interactive jobs may not start when you are around.
               - In this case, resources are assigned to you but you are not using them.
               - So the resources sit idle waiting for you; others cannot use these resources.
             - (2) When a person is done with an interactive job, they must explicitly give back the resources.
               - If a user does not give the resources back, then until the job wall time 
                 is reached.
               - So the resources sit idle waiting for you; others cannot use these resources.
           - Batch jobs, by their nature, do not suffer these inefficiencies.
       - You should choose the job type that you need:  if you need interactive jobs, then use them.   
11. Caution about specifying whole nodes for jobs.
   - This can take time for slurm to achieve and provide to you.
   - Example alternative
12. If using GPUs in your job, use the grafana dashboards to ensure that your code is using the GPUs.
   - These are a limited resources, so their efficient use if important to everyone.
   - Procedure
     - Go to a terminal for the cluster your jobs are on.
     - Type `squeue`.
     - Get the slurm job ID of the job of interest.  Call this `sjid`.
     - On terminal type, `scontrol show job --details sjid`.
       - Get the compute node IDs of the compute nodes that you are using.
       - Get the GPU indexes of the GPUs you are using.
     - You can also do:  on terminal type, `showjobusage sjid`.  Get the compute node IDs from the output.
     - Go to the dashboards below (per cluster).
        - Dashboards
          - [TC dashboard](https://dashboard.arc.vt.edu/d/acfsdp9/arc-cluster-efficiency-tinkercliffs?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-tc-oss&var-partition=$__all)
          - [Owl dashboard](https://dashboard.arc.vt.edu/d/acgv4cq/arc-cluster-efficiency-owl?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-owl-oss&var-partition=$__all)
          - [Falcon dashboard](https://dashboard.arc.vt.edu/d/cej373w7tbmkgd/arc-cluster-efficiency-falcon?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-falcon-oss&var-partition=$__all)
     - Select your compute node ID (the one from the step above).
     - Look at the GPU utilization plot and inspect the utilization of the GPU you are using.
13. Post-job quick evaluation:  build your intuition about what resources you need
   - Commands
     - `seff <slurm job ID>`
     - Will tell you what your utilization of CPU and memory are.
     - If you are using GPUs, then:
        - In your batch script, use the `nvidia-smi` command.
        - An example is in the ARC docs:  [example batch script with nvidia-smi](https://docs.arc.vt.edu/resources/compute/02falcon.html)
   - Example


## Learning Objectives

1. blah
2. blah

## Detailed Topics

1. [File systems](./02_file_systems.md)
2. [File and directory permissions](./03_file_permissions.md)
3. [umask](./04_umask.md)
4. [File and directory ownership](./05_file_ownership.md)
5. [Data recovery and LT storage](./06_data_recovery_and_long_term_storage.md)
6. [Best practices](./07_best_practices.md)


### Prerequisites

- You will need an ARC account to follow along and set up these tools.
- Access to a VT network (e.g., _eduroam_ on campus or _VPN_ off campus)

### Applicability

A very large portion of this content is applicable to 
any compute cluster.

### Acknowledgment

These notes were constructed largely from workshop materials
initially prepared by Matt Brown and Sophia Lima.

---
[Next: File systems ➡️](02_file_systems.md)
