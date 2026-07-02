# How to Select (Compute) Resources for a (Slurm) Job

---
[Next: File systems ➡️](02_file_systems.md)

## Topics

1. Show a cononical sbatch slurm script so that the audience sees all of the
   parameters to specify.  Provides context.
2. Parameters that you can specify for a job
   - number nodes, cpus, num gpus, memory, etc.
3. How these parameters vary across clusters
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
4. Unique features of clusters
   - Owl has large (4 TB) and huge (8 TB) memory CPU-based nodes for "large memory" computing jobs.
   - OTHERS?????
5. Know the types of GPUs that are best suited for your jobs
   - Examples:
     - A30 (Falcon):  best for XXXXX.
     - L40S (Falcon):  best for XXXXX.
     - H200 (TC):  best for XXXX.
     - B200 (Owl) [coming]:  best for XXXX.
6. Attempting to minimize your job's wait time.
   - That is, the time from job submission until it begins to run.
   - See the Grafana dashboards to see the most heavily used clusters/partitions, and historical wait times.
     - [time wait dashboard](https://dashboard.arc.vt.edu/d/fej6n6nqfytc0f/arc-cluster-wait-times?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=$__all&var-partition=$__all&var-timelimit=$__all&refresh=1m)
7. Input/output (I/O) Speeds
   - If you have a lot of disk/storage access,
     read from and write to `/scratch`; much faster than `/projects`
   - If your code is small enough, use "localscratch";
     faster than `/scratch`.
8.  Using different storage, lifetime of data
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
9.  Delays in obtaining a full node.  Can you go with fewer resources,
    e.g., fewer CPUs?  Job may take longer, but it may start much sooner.
10. User QoS
   - There is a QoS table on each of the cluster's pages, given above.
   - Can run jobs up to 14 days with "long" QoS.
   - If your group consistently does not use its monthly computing units budget,
     you can increase your job priority by using "short" QoS.
      - But the billing rate is double the "normal" QoS, by design.
      - But the maximum duration of a job is one day; for "normal" QoS, it is seven days, by design.  
11. Choosing type of job:  interactive or batch
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
12. Caution about specifying whole nodes for jobs.
   - This can take time for slurm to achieve and provide to you.
   - Example alternative
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
