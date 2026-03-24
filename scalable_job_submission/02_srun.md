

## Use of srun


### Example 1:  Sbatch Slurm Job Submission


#### Background

Some characteristics of srun that will mean more after the demonstrations.

srun attempts to preserve your environment.
Works well with slurm.
- srun can coordinate execution of processes across compute nodes.
- srun leverages ‘slurmstepd’ on every compute node
to launch jobs.
- srun will capture your environment at time of
submission and pass to all child processes.
- Slurmstepd will configure things such as C-groups or
attaching to the correct GPU.
- If you load a module, those applications & libs will be
available to all processes.
- You can safely use relative paths in your application.


srun, and the next topic, GNU parallel, can:

1. do some similar things.
2. do some different things.
3. can work in concert to get work done.

We will give examples of each, but right now, we focus on srun.
We just wanted to set up an overall context here.


This example runs on Tinkercliffs (TC).

The context here is "embarrassingly parallel" computing.

#### Inputs

Please copy the contents of the files below into files on the cluster, using the same names.

All files should be put in one directory.


The sbatch slurm script is _slurm.01.sbatch_.

```bash
#!/bin/bash


#SBATCH -J rPara

## Account.
## Enter your own account.
#SBATCH --account arcadm

## Time.
#SBATCH --time 01:00:00

## Partition.
#SBATCH --partition normal_q

## Num compute nodes, executing tasks, compute cores.
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1

## Slurm output and error files.
#SBATCH -o r.para.srun.%j.out
#SBATCH -e r.para.srun.%j.err


echo "date: `date`"
echo "hostname: $HOSTNAME"; echo
echo -e "\nChecking job details for CPU_IDs..."
scontrol show job --details $SLURM_JOB_ID


# R module.
module load R/4.4.2-gfbf-2024a

# the script will be executed ${SLURM_NTASKS} times
echo "slurm_ntasks (total number of tasks across all nodes):  $SLURM_NTASKS"
echo "slurm_job_num_nodes: $SLURM_JOB_NUM_NODES"

# This is going to run 32 instances of the R code.
srun --ntasks=$SLURM_NTASKS Rscript test_args.R  12 14 16 18 test_args.R
```


The R code _test_args.R_.
This code just prints out the command line, but clearly, more work
can be put into the R script.

```R
args = commandArgs(trailingOnly=TRUE)

fmt_str = paste("Tag, from ", Sys.info()["nodename"], "...   Arguments: ")
for (a in args) {fmt_str <- paste(fmt_str, " ",  a)}
print(fmt_str)
```


#### Slurm Sbatch Job Submission

To submit the job to the Slurm scheduler on ARC clusters, type:

```
sbatch slurm.01.sbatch
```

#### Output

First, note our main objective:  to run many executions of a code
from one sbatch slurm script.
Here, we ran 32 executions in one slurm script.


Two files will be generated.
Because output of the code is text that is written to screen,
the information will be written to file `r.para.srun.2967761.out`
(the JOB_ID is 2967761).

That is, slurm redirects all text that would otherwise
be written to screen and redirects to the output file.
There is also a slurm-generated error file `r.para.srun.2967761.err`.


The last part of the *.out file contains lines like this:
`"Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"`.
There are 32 such lines because, as you see in the second line below,
there are 32 total tasks (2 nodes, 16 tasks per node) in the slurm job.
Each execution of srun is one task.



```output
slurm_ntasks (total number of tasks across all nodes):  32
slurm_job_num_nodes: 2
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc034 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
[1] "Tag, from  tc035 ...   Arguments:    12   14   16   18   test_args.R"
```

To build intuition about the performance of your codes,
always run `seff` on your job after it completes:

```bash
seff  SLURM_JOB_ID
```

to see the use of CPUs and memory.

---

⬅️ [Previous: Introduction](01_introduction.md) | [Next: GNU pararllel ➡️](03_parallel.md)
