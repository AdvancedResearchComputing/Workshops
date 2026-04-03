
## Use of srun and GNU parallel Together

We will demonstrate two jobs.
The jobs are almost identical.
In the first job, all executions of a code
are run on one compute node.
In the second job, with very small modifications,
how all executions of a code are run on more
than one compute node.

Consistent with the notes above, `srun` is the tool
that enables us to run, within one slurm job, many
code executions on multiple compute nodes.

Also, you will see the code run with the same inputs.
This naturally and frequently happens when a code
is stochastic:  one wants to assess variability in
results for the same inputs.
Here, we use a simple deterministic code in the examples.


### Patterns With GNU Parallel and srun

Patterns are code designs and implementations that are used over and over
again for different types of problems.

1. Use `parallel` with `srun` to execute a code.
    - `parallel` handles cases where different inputs are specified.
    - `srun` handles execution across tasks or nodes, and where inputs are the same.
        - Stochasticity of inputs is a reason to run the same code with same inputs multiple times.
2. The graphics below illustrate this.
    - There is one sbatch slurm script.
    - But the values for switches `--ntasks-per-node` and `--nodes`, for srun,
      and `--cpus-per-task`, for parallel, work in combination to complete the executions.

[pattern3a](figures/slide-2-parallel-n-srun.pdf)
![patter3a](figures/slide-2-parallel-n-srun.png)

[pattern3b](figures/slide-3-parallel-n-srun.pdf)
![patter3b](figures/slide-3-parallel-n-srun.png)


### Example 1


We are running `parallel` as an outer loop.
And `srun` as an inner loop.

We run `parallel` a total of 16 times, see `--cpus-per-task`,
using all combinations (i.e., the Cartesian product) of the two values
for each of four parameters:  2^4=16.

For each of the 16 combinations of the four input parameters,
we run test_args.R three times.
(We make believe that test_args.R is a stoachistic code so that
we want to run it four times.)

#### Files

The sbatch slurm script is _sbatch.one.node.slurm_.


```bash
#!/bin/bash


#SBATCH -J rPara

## Account.
## Enter your own account.
#SBATCH --account arcadm

## Time.
#SBATCH --time 00:05:00

## Partition.
#SBATCH --partition normal_q

## Num compute nodes, executing tasks, compute cores.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=16

## Slurm output and error files.
#SBATCH --output r.para.parallel.srun.%j.out
#SBATCH --error r.para.parallel.srun.%j.err


echo "date: `date`"
echo "hostname: $HOSTNAME"; echo
echo -e "\nChecking job details for CPU_IDs..."
scontrol show job --details $SLURM_JOB_ID


# R module.
module load R/4.4.2-gfbf-2024a


my_num_parallel=$SLURM_CPUS_PER_TASK
my_num_srun=$SLURM_NTASKS


# the script will be executed ${SLURM_NTASKS} times
echo "slurm_ntasks (total number of tasks across all nodes):  $SLURM_NTASKS"
echo "slurm_job_num_nodes: $SLURM_JOB_NUM_NODES"
echo "slurm_job_num_tasks: $SLURM_JOB_NTASKS"
echo "slurm_tasks_per_node: $SLURM_TASKS_PER_NODE"
echo "slurm_cpus_per_task: $SLURM_CPUS_PER_TASK"
echo " "
echo "my_num_parallel  ${my_num_parallel}"
echo "my_num_srun  ${my_num_srun}"
echo " "
echo "output"
echo " "



# This is going to run 48 instances of the R code.
sh run.07  ${my_num_parallel}  ${my_num_srun}
```

The _run.07_ bash script is below.

```bash
## Using GNU parallel for outer loop and srun for inner loop.

## Command line arguments.
num_parallel=$1
num_srun=$2

parallel  --jobs ${num_parallel}  echo values :  {1}  {2} {3}  {4}   ';'  srun --ntasks=${num_srun} Rscript test_args.R  {1}  {2} {3}  {4}  :::  12 -12  ::: 14  -14  :::  16 -16 :::  18 -18
```

The _test_args.R_ file is below.

```R
args = commandArgs(trailingOnly=TRUE)

fmt_str = paste("Tag, from ", Sys.info()["nodename"], "...   Arguments: ")
for (a in args) {fmt_str <- paste(fmt_str, " ",  a)}
print(fmt_str)
```

#### Job Submission

To submit the batch job:

```bash
sbatch sbatch.one.node.slurm
```

#### Output

The output is below (time information and compute node information will vary).

Notes:  In the output below:

1. There are 16 lines with `values : 12 14 16 18`, per `parallel`.
2. There are three lines per parallel statement, per `srun`.


```
date: Tue Oct 21 08:54:34 AM EDT 2025
hostname: owl036


Checking job details for CPU_IDs...
JobId=181322 JobName=rPara
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1015 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:01 TimeLimit=00:05:00 TimeMin=N/A
   SubmitTime=2025-10-21T08:54:33 EligibleTime=2025-10-21T08:54:33
   AccrueTime=2025-10-21T08:54:33
   StartTime=2025-10-21T08:54:33 EndTime=2025-10-21T08:59:33 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-21T08:54:33 Scheduler=Main
   Partition=normal_q AllocNode:Sid=owl1:2541903
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl036
   BatchHost=owl036
   NumNodes=1 NumCPUs=48 NumTasks=3 CPUs/Task=16 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=48,mem=380544M,node=1,billing=95
   AllocTRES=cpu=48,mem=380544M,node=1,billing=95
   Socks/Node=* NtasksPerN:B:S:C=3:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl036 CPU_IDs=0-47 Mem=380544 GRES=
   MinCPUsNode=48 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/gnu-parallel/ex-04/sbatch.for.R.parallel.srun.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/gnu-parallel/ex-04
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/gnu-parallel/ex-04/r.para.parallel.181322.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/gnu-parallel/ex-04/r.para.parallel.181322.out
   TresPerTask=cpu=16


slurm_ntasks (total number of tasks across all nodes):  3
slurm_job_num_nodes: 1
slurm_job_num_tasks: 3
slurm_tasks_per_node: 3
slurm_cpus_per_task: 16

my_num_parallel  16
echo my_num_srun 3

 output

values : 12 14 16 18
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   18"
values : 12 14 16 -18
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   16   -18"
values : -12 14 16 -18
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   -18"
values : 12 -14 -16 18
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   18"
values : -12 -14 16 -18
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   -18"
values : -12 14 16 18
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   16   18"
values : -12 -14 -16 -18
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   -18"
values : -12 14 -16 18
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   18"
values : -12 -14 -16 18
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   -16   18"
values : 12 14 -16 -18
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   -18"
values : -12 14 -16 -18
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    -12   14   -16   -18"
values : -12 -14 16 18
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    -12   -14   16   18"
values : 12 -14 16 -18
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   -18"
values : 12 -14 -16 -18
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   -18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   -16   -18"
values : 12 -14 16 18
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   -14   16   18"
values : 12 14 -16 18
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   18"
[1] "Tag, from  owl036 ...   Arguments:    12   14   -16   18"
```


### Example 2

This example is just like the last except now we run the code
instances on multiple (three) compute nodes.

Steps:

1. Make a copy of `sbatch.one.node.slurm` and call it `sbatch.three.nodes.slurm`.
2. In file `sbatch.three.nodes.slurm`, take out the following two lines
```bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
```
3. In their place, insert the following two lines.
Here we have three tasks, one on each of three nodes:

```bash
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
```

You may also want to change the names of the output and error files
in:
1. `#SBATCH --output`
2. `#SBATCH --error`


Then submit the job:

```
sbatch sbatch.three.nodes.slurm
```
---

⬅️ [Previous: GNU pararllel](03_parallel.md) | [Next: Job Arrays ➡️](05_job_arrays.md)

## Outline
0. [Welcome](./0-intro.md)
1. [Slurm job options overview](./1-slurm.md)
2. [Common parallelization for launching](./2-patterns.md)
3. [MPI launching with `srun` or `mpirun`](./3-mpi.md)
4. [GNU `parallel` overview](./4-parallel.md)
5. [`srun` + `parallel` ](./5-srun_parallel.md)