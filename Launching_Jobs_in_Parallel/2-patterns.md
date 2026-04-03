# Job Patterns for concurrency


| Code or Command  |  Type of Packing     |
| ---------------- | -------------- | 
|    srun     |  Many executions of the same code with perhaps different inputs.   Is a cornerstone of MPI launching, but useful beyond that.  It, for example, is tightly woven into Slurm.  |
|    GNU parallel      |  Many executions of the same code with perhaps different inputs. |
|    Slurm Job Array      |  This is specific to Slurm, ARC's batch job submission system.  It is more flexible, inherently, than srun or GNU parallel.  Operates at a higher level of granularity.  |
|    Scripting      |  Using Linux/UNIX shells, like bash and tcsh.  (Some others:  csh, sh, ksh, tsh, zsh.) These scripting languages are used for a LOT of things; the context of this workshop is just one of many.  Here, too, the selling point is flexibility.  Scripting and job arrays are quite similar in concept. |

Examples
 - process each file in a list of files
 - parameter sweep, multiparameter combinations, random sampling
 - co-dependent processes that require all processes running concurrently and possibly inter-process communication (MPI, NCCL)

Exceptions
 - inherently serialized patterns like iterative optimizations or state-evolution sequences

## Outline
0. [Welcome](./0-intro.md)
1. [Slurm job options overview](./1-slurm.md)
2. [Common parallelization for launching](./2-patterns.md)
3. [MPI launching with `srun` or `mpirun`](./3-mpi.md)
4. [GNU `parallel` overview](./4-parallel.md)
5. [`srun` + `parallel` ](./5-srun_parallel.md)