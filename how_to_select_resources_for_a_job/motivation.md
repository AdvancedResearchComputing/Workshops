# Motivation:  Resources That Can be Requested for a Job

---
1. [Motivation ⬅️ Previous:](./motivation.md)
3. [Next: ➡️ Reduce time your job spends in queue](./reduce_job_queued_time.md)


Below are sections from two job scripts, which are used to 
submit batch jobs on a cluster with `sbatch`.

The sections provided show how resources for the job are specified.
These examples give a sense of what resources are typically
specified and what features of the cluster a job may need to request.


*Example 1:* Resources for a job requesting a GPU on the Tinkercliffs ("TC" or "tc").
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
#SBATCH --output slurm.tc.a100.namd.01.%j.out
#SBATCH --error slurm.tc.a100.namd.01.%j.err
#
# Load modules
# Invoke your code
```

*Example 2:* Resources for a CPU-only job
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

Note that an batch script is often created for a particular cluster.
Then the resources specified in the script
are used to identify particular resource needs (CPU, GPU, memory, layout) to run your job.

Some questions motivated by these examples:

1. Is my code a serial code or a parallel code?
   - If a serial code, I will use one core (CPU) of one compute node.
   - If a parallel code ...
     - Am I using CPUs to achieve parallelism?
     - Am I using GPUs to achieve parallelism?
     - Am I using both?
2. How many processes will I have?
   - If a serial code, there will usually be one process.
   - A parallel code may have one process or many.
     - A purely threaded code will have one process.
     - A distributed code will have at least two processes.
     - Again, here, you can have both:  threading and distribution.
3. How much memory do I need?
   - If it is a serial code, I might specify twice the size of my input data, as a start.
   - If it is a parallel code, I might run my code across several compute nodes
     and specify memory on a per-compute-node basis (as is done with `#SBATCH --mem=100GB` above). 

These three categories of questions above have impacts on all of the parameters listed in the
two examples above:  time, partition, constraint, nodes or ntasks, ntasks-per-node,
cpus-per-task, mem, and gres.

**And in turn, these parameters and their values affect which resources you should
choose to run your jobs.**

Best practices:  many of these Slurm job parameters have defaults.
Explicity specify what you need to get to exercise full control of the job environment.



---
1. [Motivation ⬅️ Previous:](./motivation.md)
3. [Next: ➡️ Reduce time your job spends in queue](./reduce_job_queued_time.md)
