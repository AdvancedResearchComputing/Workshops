# Slurm Options


## More info
Today we only have time for a very brief overview, but there are many more options and tools to know about. Here are some places to look for more information
- Command Line Manuals: `man sbatch`, `man srun`
- Slurm docs on the web: e.g., https://slurm.schedmd.com/sbatch.html
- Other ARC workshops: [Running Jobs on ARC](../Running_Jobs_on_ARC/Running_Jobs_On_ARC.md) [Resource Utilization and Job Monitoring](../Resource_Utilization_and_Job_Monitoring/Resource_Utilization_and_Job_Montiorring.md)

## Common Slurm Options for managing parallel launching

### How many nodes to use
This is an optional parameter. Slurm will make assumptions based on other options that are provided.

`--nodes=N`: run the job on exactly `N` nodes
This option provides explicit control over the job environment. With `N>1`, the job script runs on the lowest numbered allocated node. 

>[!WARNING]
>It's up to the user to make sure processes are launched on the other nodes.

`--nodes=M-N`: run the job on at least `M` and possibly as many as `N` nodes
The range provides Slurm with more flexibility and possibly faster job starting, but resource allocation is likely to be unbalanced and asymmetric. 

### How many concurrent tasks to launch

>[!INFO]
>We use the terms "task", "process", and "rank" almost interchangably.

`--ntasks-per-node=N`: allocate resources expecting that there will be `N` concurrent tasks launched on each allocated node. 
 - most often used with `--nodes=` for explicit and balanced process launching across nodes

 `--ntasks=N`: find and allocate resources to launch `N` concurrent tasks across the partition without any requirement node-level balancing or symmetry
 - any node specification can work
 >[!WARNING]
 > For a large number of tasks, you should usually set some reasonable bounds to avoid spreading too far across the partition.
 > Excessive and persistent cluster fragmentation has a negative impact on scheduling efficiency for some important job patterns.

### Node-level vs. task-level resource requests
Providing both node-level and task-level requests for memory, cpu-cores, and GPUs would likely create contraditory or conflicting requirements, so these patters are mutually exclusive. Choose from one column for each job:

|type|node level|task-level|
|-|-|-|
|memory|`--mem=X`|`--mem-per-task=`|
|cpu-cores|n/a|`--cpus-per-task`|
|gpus|`--gres=gpu:X`|`--gpus-per-task=X`|

- `SLURM_CPUS_PER_TASK`
- `SLURM_CPUS_ON_NODE`
- `SLURM_GPUS`
- `SLURM_GPUS_ON_NODE`
- `SLURM_GPUS_PER_NODE`
- `SLURM_JOB_CPUS_PER_NODE`
- `SLURM_JOB_GPUS`
- `SLURM_JOB_NODELIST`
- `SLURM_JOBID`
- `SLURM_MEM_PER_CPU`

and many more (see `man sbatch` section "OUTPUT ENVIRONMENT VARIABLES")

### Job Arrary
`--array=<spec>`

Examples:
- `--array=0-15` 
- `--array=0,6,16-32`
- `--array=0-15:4` equivalent to `--array=0,4,8,12`
- `--array=0-15%4` limit to 4 running jobs at a time

Output environment variables available in the job
- `SLURM_ARRAY_TASK_ID`
- `SLURM_ARRAY_TASK_MAX`
- `SLURM_ARRAY_TASK_MIN`
- `SLURM_ARRAY_TASK_STEP`

## Outline
0. [Welcome](./0-intro.md)
1. [Slurm job options overview](./1-slurm.md)
2. [Common parallelization for launching](./2-patterns.md)
3. [MPI launching with `srun` or `mpirun`](./3-mpi.md)
4. [GNU `parallel` overview](./4-parallel.md)
5. [`srun` + `parallel` ](./5-srun_parallel.md)