# Motivation:  Resources That Can be Requested for a Job

---
[Next: File systems ➡️](02_file_systems.md)


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
#SBATCH --output slurm.tc.a100.namd.01.%j.out
#SBATCH --error slurm.tc.a100.namd.01.%j.err
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

Note that an sbatch slurm script is created for a particular cluster.
Then the resources specified in the sbatch slurm script
are used to identify particular resource needs to run your job.

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

**And in turn, these parameters and their values affect which resources you should
choose to run your jobs.**

Best practices:  many of these sbatch slurm script parameters have defaults.
Do not use the defaults.  Specify everything.



---
[Next: File systems ➡️](02_file_systems.md)
