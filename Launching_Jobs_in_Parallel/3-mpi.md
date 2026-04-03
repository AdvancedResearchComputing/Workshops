# MPI launching

`srun` and `mpirun` are used to launch concurrent tasks which are presumed to be co-dependent and intercommunicating, such as for MPI jobs.

Their distinct utility includes:
 - ability to pull tasks counts, arrangement, and available resources from Slurm
 - enforcing task-to-resource binding and constraint as defined in the job input
 - ability to launch processes on the other nodes allocated to the job without having to define mechanisms to detect and manage these

Those features can be useful for other types of parallel launching as well.

From a login node:
`srun --ntasks=10 --nodes=3-5 --account=<slurm account> hostname`


In a batch script:
```bash
#!/bin/bash
#SBATCH --nodes=3-5
#SBATCH --ntasks=10
#SBATCH --account=<slurm account>

echo launching from lead node `hostname`

srun hostname
```

## Outline
0. [Welcome](./0-intro.md)
1. [Slurm job options overview](./1-slurm.md)
2. [Common parallelization for launching](./2-patterns.md)
3. [MPI launching with `srun` or `mpirun`](./3-mpi.md)
4. [GNU `parallel` overview](./4-parallel.md)
5. [`srun` + `parallel` ](./5-srun_parallel.md)