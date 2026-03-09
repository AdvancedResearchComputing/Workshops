# Intel MPI

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



## Documentation


The manual for Intel MPI is here (this may change over time) and more current releases may be available.

<a href="https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-16/overview.html" target="_blank">https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-16/overview.html</a>






## Overview

These jobs were run on Tinkercliffs (TC) using Intel MPI with the Intel multicore compute nodes.

The directions here are for use on TC.


Also, on the previous episode, we studied OpenMPI and MPICH.  Now we are using the Intel implementation of MPI.
Using OneAPI.

Therefore, what are the big changes between this episode and the previous one?

1. Modules. Note we use these at the command line for compiling and in the sbatch slurm scripts.
    - For OpenMpi, we used `foss/2023b`.
    - For MPICH, we used `MPICH/4.3.0-GCC-14.2.0` or just `MPICH`.
    - For Intel, we are using `intel/2024a` or just `intel`.
2. Compilation. The makefile is now different.
    - For OpenMpi, we used same makefile as for MPICH, i.e., the compiler was `mpicxx`.
    - For Intel, we are using `mpiicpx` (the oneAPI compiler).   The flag for linking OpenMP is different, too.
3. We change the names of the slurm-generated output and error files in the sbatch slurm script.
    - For OpenMpi, we use "open.mpi"
    - For MPICH, we use "mpich"
    - for Intel MPI, we use "intel"
4. The invocation of the MPI code is different.
    - For OpenMpi, we use `srun`.
    - For MPICH, we use `mpiexec`.
    - For Intel, we use `mpirun`.
    - Each of these keywords has an additional switch (at least one).

But the makefiles and the C++ source code do not change.

This makes it clear how the **environment** changes (through modules) but the operations are otherwise
the same.

It is best to run these examples in a completely separate directory from that used for the
preceding episode.

## Compilation Via an Interactive Job

There are sections below with heading "C++ Code Compilation" for each of the three examples.

Those give the commands to:

1. reset modules.
2. load module(s).
3. issues a `make` command.

These should all be done on the the type of compute node on which you are going to run.

Since we are running on the TC cluster and Intel nodes, that is where we want to create the 
binary executable. 
 
You are on the TC cluster.

So the commands are:

_**Option 1:  The preferred option**_:

Option 1 is preferred because the interactive job will be cleaned up automatically.

~~~bash
## From the owl head node, issues this command to start your interactive job:
interact --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=intel&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2  
~~~


_**Option 2:  The not-preferred option**_:


~~~bash
## From the owl head node, issues this command to start your interactive job:
salloc --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=intel&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2  

## The results returned by slurm for the above command will include an owl compute node id, <cnode-id>
ssh <cnode-id>
~~~

where you have to supply your own account.

Now you can enter the compile commands.

When finished compiling:

1. `exit` off of the compute node.
2. If you use Option 2 (which is not recommended), use `scancel` to cancel this interactive job.



## Example 1

There are three MPI processes, two of which are worker processes
and one is the master process,
in a master-worker relationship.
The two workers each send their rank to the master process and the master prints these ranks.
Process rank 0 is typically the master (or initial) process
created.

But what this examples shows, importantly, is the mechanics of 
specifying a sbatch slurm script, a makefile, the source code,
building the source code, and executing a code across compute nodes.

### Files (Scripts and Codes)

Each of these files should be created on TC and put in the 
same directory.
Just copy this text for each file and paste it into an open file
on the cluster filesystem.


The sbatch slurm script is first.
Note the use of `--ntasks`, `--ntasks-per-node`, and `--cpus-per-task`.
We urge you to consider this style and way of thinking for all MPI jobs.
It may be counterintuitive to NOT specify the number of compute
nodes in a job (with `--nodes`), but this number is computed automatically from the 
first two parameters above.
The reason to think this way is that this specification of resources
maps onto how MPI assigns processes to compute nodes.
Specifically:

1. `--ntasks`:  how many TOTAL MPI processes will be created over the entire job.
2. `--ntasks-per-node`:  how many of these MPI processes will run on each compute node.
3. `--cpus-per-task`:  how many cores (and most likely, threads) each MPI process will have.

The above is only a suggestion.
Note that you can use `--nodes` instead of `--ntasks`.
You can get one from the other as long as `--ntasks-per-node` is specified.

Make copies of the following files on the cluster, in one directory, by copying the
text here and pasting it into a file with the specified name.

The sbatch slurm script is _job.01.slurm_.

~~~bash
#!/bin/bash


## Intel MPI

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:30:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.
## From this, the number of compute nodes is automatically calculated.

## Total number of MPI processes in the entire job.
#SBATCH --ntasks=3

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1


## -----------------------
## CONSTRAINTS
#SBATCH --constraint=intel&avx512


## -----------------------
## MEMORY.
## Example if you want/need to specify memory per node.
##SBATCH --mem=122368
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.intel.mpi.%j.out
#SBATCH --error slurm.intel.mpi.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q


## -----------------------
## ACCOUNT.
## The account to charge to.
## You will have your own accounts.
#SBATCH --account arcadm


## -----------------------
## MODULES.
module reset
module load intel


## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR



## -----------------------
## Record slurm conditions.
echo " "
echo "slurm scontrol" 
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo "<< end slurm scontrol >>" 
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
THE_EXEC="./mpi-simple01"
THE_INPUT=""
mpirun -n  $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
~~~



This C++ code just has the worker MPI processes print their ranks.
The C code is _main.C_.

~~~cpp
#include <stdio.h>
#include "mpi.h"

int main(int argc,char* argv[])
{
    int my_rank;
    int num_proc;
    int dest= 0;
    int tag= 0;
    int tmp,i;
    MPI_Status status;

    MPI_Init(&argc, &argv);
    /* get my_rank */
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    /* find out how many processes there are */
    MPI_Comm_size(MPI_COMM_WORLD, &num_proc);
    printf("  num procs total: %d\n",num_proc);
    if( my_rank != 0 ) {
        MPI_Send(&my_rank,1,MPI_INT,dest,tag,MPI_COMM_WORLD);
        printf("hello world from sending process %d \n",my_rank);
    }
    else {
        for(i=1; i < num_proc; i++) {
            MPI_Recv(&tmp,1,MPI_INT,i,tag,MPI_COMM_WORLD,&status);
            printf("hello world from receiving process %d (my_rank); received from process %d \n",my_rank,tmp);
        }
    }
    MPI_Finalize();
    return 0;
}
~~~



The makefile to build the C++ executable is _makefile.tc.intel.mpiicpx_.


__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple01: main.C`
3. `clean:` 



~~~bash
#### Aug 2024.
#### At VT, on TC cluster.
#### Process:
####     1. module load foss/2023b
####     2. make -f makefile.XXX clean
####     3. make -f makefile.XXX

### For development or running compilations:
### MPICXX=mpicxx -g -fopenmp -pthread
### For production mode.
### MPICXX=mpicxx -O2 -fopenmp -pthread

## To get OpenMP with compile, do:  mpiicc /Qopenmp test.c
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/compiling-an-mpi-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/running-an-mpi-openmp-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-16/overview.html

## Some sayuse -pthread and some -lpthread.??

MPICXX=mpiicpx -O2 -qopenmp -lpthread

CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.
## Load outside of this makefile.

### ------------------------------
.C.o:
        $(MPICXX) $(CPPFLAGS) -c $(LDFLAGS) $<

mpi-simple01: main.C
        $(MPICXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS)
##      mv $@ ../bin/

clean:
        rm mpi-simple01 *.o
~~~


#### C++ Code Compilation

You should be on the Intel compute node by issuing the `interact` command
near the beginning of this file.

The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.

~~~bash
module reset
module load intel 
~~~



The compile is through the makefile above called _makefile.tc.intel.mpiicpx_.
Invoke like this:

~~~bash
make -f makefile.tc.intel.mpiicpx
~~~


The executable should be _mpi-simple01_.


#### Slurm Sbatch Job Submission

Now you are back on a head node.

Enter:

~~~
sbatch job.01.slurm
~~~
{:  .language-bash}


#### Output

The output in the specified slurm output file, with job id 3495069,
is _slurm.intel.mpi.3495069.out_.
Your output will vary, but the same types of information will be output. 
The code output lines will all be there, but perhaps in different order.

__This output was generated on TC.__

~~~output
slurm scontrol
JobId=3495069 JobName=job.01.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1095 Nice=0 Account=arcadm QOS=tc_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:04 TimeLimit=00:30:00 TimeMin=N/A
   SubmitTime=2025-10-08T16:04:49 EligibleTime=2025-10-08T16:04:49
   AccrueTime=2025-10-08T16:04:49
   StartTime=2025-10-08T16:04:55 EndTime=2025-10-08T16:34:55 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-08T16:04:55 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=tinkercliffs1:3290721
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=tc-intel[002-004]
   BatchHost=tc-intel002
   NumNodes=3 NumCPUs=3 NumTasks=3 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=3,mem=5832M,node=3,billing=3
   AllocTRES=cpu=3,mem=5832M,node=3,billing=3
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=tc-intel002 CPU_IDs=32 Mem=1944 GRES=
     Nodes=tc-intel003 CPU_IDs=12 Mem=1944 GRES=
     Nodes=tc-intel004 CPU_IDs=32 Mem=1944 GRES=
   MinCPUsNode=1 MinMemoryCPU=1944M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex01/job.01.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex01
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex01/slurm.intel.mpi.3495069.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex01/slurm.intel.mpi.3495069.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  3
  num procs total: 3
  num procs total: 3
hello world from sending process 2
  num procs total: 3
hello world from receiving process 0 (my_rank); received from process 1
hello world from sending process 1
hello world from receiving process 0 (my_rank); received from process 2
~~~




## Example 2

There are two MPI processes.
There are several iterations (8).
In each iteration, one process sends the iteration number to the
other process.
So now the processes are transferring data.
The two processes switch roles on each consecutive iteration:
1. in iteration i, process 0 sends and process 1 receives.
2. in iteration (i+1), process 1 sends and process 0 receives.


#### Files (Scripts and Codes)

This is the sbatch slurm job submission script _job.02.slurm_.

~~~bash
#!/bin/bash


## Intel MPI

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:30:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.
## From this, the number of compute nodes is automatically calculated.

## Total number of MPI processes in the entire job.
#SBATCH --ntasks=2

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1


## -----------------------
## CONSTRAINTS
#SBATCH --constraint=intel
#SBATCH --constraint=avx512


## -----------------------
## MEMORY.
## Example if you want/need to specify memory per node.
##SBATCH --mem=122368
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.intel.02.mpi.%j.out
#SBATCH --error  slurm.intel.02.mpi.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q


## -----------------------
## ACCOUNT.
## The account to charge to.
## You will have your own accounts.
#SBATCH --account arcadm


## -----------------------
## MODULES.
module reset
module load intel


## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR



## -----------------------
## Record slurm conditions.
echo "slurm scontrol" 
scontrol show job --details $SLURM_JOB_ID
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
THE_EXEC="./mpi-simple02"
THE_INPUT=""
mpirun -n  $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
~~~



The C++ code is next.
Notice that the variable that constitutes the message
passed is the single integer iteration_count.
Only the sender updates the iteration_count; the 
receiver RECEIVES and prints this updated iteration_count
value.

This is the C++ code _main02.C_.


~~~cpp
#include <stdio.h>
#include "mpi.h"

int main(int argc,char* argv[])
{
    int my_rank;
    int num_proc;
    int dest= 0;
    int tag= 0;
    int tmp,i;
    MPI_Status status;
    int iteration_limit=8;

    MPI_Init(&argc, &argv);
    /* get my_rank */

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    printf("  my rank: %d\n",my_rank);
    /* find out how many processes there are */
    MPI_Comm_size(MPI_COMM_WORLD, &num_proc);
    printf("  num procs total: %d\n",num_proc);


    int iteration_count = 0;
    int partner_rank = (my_rank + 1) % 2;
    while (iteration_count < iteration_limit) {
        // Increment the iteration count before you send it.
        // iteration_count++;

        if (my_rank == iteration_count % 2) {
            printf(" ------------------ \n");
            // Increment the iteration count before you send it.
            iteration_count++;
            MPI_Send(&iteration_count, 1, MPI_INT, partner_rank, 0,
                     MPI_COMM_WORLD);
            printf("iteration counter: %d;  MY_RANK: %d;   SENT from rank: %d;  TO rank %d \n",
                   iteration_count, my_rank, my_rank, partner_rank);
        }
        else {
            MPI_Recv(&iteration_count, 1, MPI_INT, partner_rank, 0,
                     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("iteration counter: %d;  MY_RANK: %d;   RECEIVED by rank: %d;   FROM rank %d \n",
                   iteration_count, my_rank,  my_rank, partner_rank);
        }
    }
    MPI_Finalize();
    return 0;
}
~~~



The makefile for compiling the C++ code is _makefile.tc.02.intel_:

__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple01: main.C`
3. `clean:` 


~~~bash
#### Aug 2024.
#### At VT, on TC cluster.
#### Process:
####     1. module load foss/2023b
####     2. make -f makefile.XXX clean
####     3. make -f makefile.XXX

### For development or running compilations:
### MPICXX=mpicxx -g -fopenmp -pthread
### For production mode.
### MPICXX=mpicxx -O2 -fopenmp -pthread

## To get OpenMP with compile, do:  mpiicc /Qopenmp test.c
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/compiling-an-mpi-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/running-an-mpi-openmp-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-16/overview.html

## Some sayuse -pthread and some -lpthread.??

MPICXX=mpiicpx -O2 -qopenmp -lpthread

CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.
## Load module(s) outside of this makefile.

### ------------------------------
.C.o:
        $(MPICXX) $(CPPFLAGS) -c $(LDFLAGS) $<

mpi-simple02: main02.C
        $(MPICXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS)
##      mv $@ ../bin/

clean:
        rm mpi-simple02 *.o
~~~




#### Code Compilation

You have to be on an Intel compute node on TC to compile the code.
C/C++ or any other compiled code has to be compiled on the machine
it will run on.
We need the `interact` command above to get an interactive job on
an Intel compute node.

We assume that we are in the same session as for Example 1, 
so we still have
loaded the intel module.
If not, repeat the `module reset` and `module load intel` commands above.

To compile the C++ code (on an Intel compute node), we use the makefile above as follows:

~~~
make -f makefile.tc.02.intel
~~~
{:  .language-bash}



#### Slurm Sbatch Job Submission

Now we are back on a head node.

To submit this job to the slurm scheduler, we execute:

~~~
sbatch job.02.slurm
~~~
{:  .language-bash}


#### Output

The output file contains the following.
The first prints are from the sbatch slurm script.
The remaining lines are from the C++ code.

Note that reading this file is a bit wonky, as is almost
always the case when there is one output file for multiple
MPI processes.

The lines with the same value of "iteration counter" at the 
beginning are pairs of data.
Take the case `iteration counter: 6`.
We examine the two lines in the output file that start with this text.
Consider this line:
`iteration counter: 6;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1`.
For the rank=0 process (i.e., for `MY_RANK: 0`), 
it is receiving the message (because of `RECEIVED by rank: 0;`)
and 
the message is sent by rank=1 (because of `FROM rank 1`).
For this same iteration, we get the pairing process that sends the
message.
Looking further down in the file for this line:
`iteration counter: 6;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0`.
This says that rank=1 process, that is printing the message, (from `MY_RANK: 1;`)
is sending the message (`SENT from rank: 1;`) and it sent the message
to the rank=0 MPI proces (`TO rank 0`).

Notice that for the next iterations, with the two lines starting
with
`iteration counter: 7;`,
the MPI rank=0 process sends the message, and in this way the two processes,
0 and 1, switch roles on consecutive iterations.

Also, specifically note the subtlety:
only the sending process updates the value of the `iteration_count` variable.
The receiver gets its value of `iteration_count` updated because
it receives the UPDATED value from the sender via MPI message passing.
This is because for each of MPI processes 0 and 1, variable
`iteration_count` is a LOCAL variable---these processes are not getting
updated `iteration_count` variable values from being a global variable.

__This output was generated on TC.__

The output may not be in the same order in your *.out file because there is 
non-determinism as far as what process writes output when.

~~~output
slurm scontrol
JobId=3540870 JobName=job.02.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1200 Nice=0 Account=arcadm QOS=tc_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:03 TimeLimit=00:30:00 TimeMin=N/A
   SubmitTime=2025-10-21T15:39:54 EligibleTime=2025-10-21T15:39:54
   AccrueTime=2025-10-21T15:39:54
   StartTime=2025-10-21T15:39:57 EndTime=2025-10-21T16:09:57 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-21T15:39:57 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=tinkercliffs1:122617
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=tc-intel[009-010]
   BatchHost=tc-intel009
   NumNodes=2 NumCPUs=2 NumTasks=2 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=2,mem=3888M,node=2,billing=2
   AllocTRES=cpu=2,mem=3888M,node=2,billing=2
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=tc-intel009 CPU_IDs=85 Mem=1944 GRES=
     Nodes=tc-intel010 CPU_IDs=88 Mem=1944 GRES=
   MinCPUsNode=1 MinMemoryCPU=1944M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex02/job.02.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex02
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex02/slurm.intel.02.mpi.3540870.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/intel-mpi/ex02/slurm.intel.02.mpi.3540870.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  2
  my rank: 1
  num procs total: 2
  my rank: 0
  num procs total: 2
 ------------------
iteration counter: 1;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 2;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 1;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 2;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 3;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 3;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 4;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 4;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 5;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 5;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 6;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 6;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 7;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 7;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 8;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 8;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
~~~
{:  .output}



## Example 3:  Simple Strong Scaling Operation


Strong scaling:  keep problem size fixed and solve problem with different number of compute cores.

### Matrix Multiply

We are going to run eight slurm jobs.
Four jobs are going to be on a 10000 x 10000 matrix, where the number of MPI processes is

    - 1000
    - 100
    - 10
    - 1

Then, the matrix will be increased to 40000 x 40000, where the number of MPI proceses are again:

    - 1000
    - 100
    - 10
    - 1



The CPP code, the makfile to compile it to machine code, and the sbatch slurm script
are given below.
Make copies of these files on TC by copying the text here in these pages and pasting
it into files with the specified names.

File _main08.C_ code.

~~~cpp
#include <iostream>
#include <vector>
#include <mpi.h>
#include <cstdlib> // For strtol and errno
#include <chrono> // For std::chrono

using namespace std;

// Function to print a vector for demonstration purposes
void printVector(const std::vector<double>& vec, int size) {
    for (int i = 0; i < size; ++i) {
        std::cout << vec[i] << " ";
    }
    std::cout << std::endl;
}

int main(int argc, char** argv) {

    // Pring start
    cout << " " << endl;
    cout << " Starting MPI matrix-vector multiply code" << endl;
    cout << " " << endl;

    // Get size of square matrix (and length of vector).
    // Using strtol for C-style robust conversion
    char* endptr;
    long int matrixLength = strtol(argv[1], &endptr, 10); // Base 10 for decimal numbers

    std::chrono::time_point<std::chrono::high_resolution_clock> overall_time, end_overall_time, start_overall_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> overall_compute_time, end_overall_compute_time, start_overall_compute_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> initialize_time, end_initialize_time, start_initialize_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> scatter_time, end_scatter_time, start_scatter_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> bcast_time, end_bcast_time, start_bcast_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> multiply_time, end_multiply_time, start_multiply_time;
    std::chrono::time_point<std::chrono::high_resolution_clock> gather_time, end_gather_time, start_gather_time;

    // Get overall start time.
    start_overall_time = std::chrono::high_resolution_clock::now();

    cout << " Matrix and vector length : " << matrixLength << endl;

    // MPI initialize.
    MPI_Init(&argc, &argv);

    int rank, num_procs;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &num_procs);

    cout << " Number of MPI processes : " << num_procs << endl;
    cout << " " << endl;

    // const int N = 12; // Matrix and vector size. Must be divisible by num_procs.
    const int N = matrixLength; // Matrix and vector size. Must be divisible by num_procs.
    if (N % num_procs != 0) {
        if (rank == 0) {
            std::cerr << "Matrix size must be divisible by the number of processes." << std::endl;
        }
        MPI_Finalize();
        return 1;
    }

    if (rank==0) {
        start_overall_compute_time = std::chrono::high_resolution_clock::now();
    }

    int rows_per_proc = N / num_procs;

    // --- Data on the root process (rank 0) ---
    std::vector<double> A_full(N * N);
    std::vector<double> x_full(N);

    if (rank == 0) {
        start_initialize_time = std::chrono::high_resolution_clock::now();
        // Initialize the full matrix A and vector x on the root
        for (int i = 0; i < N * N; ++i) {
            A_full[i] = i + 1.0; // Example values
        }
        for (int i = 0; i < N; ++i) {
            x_full[i] = 1.0; // Example values
        }
        std::cout << "Initial full vector x: ";
        printVector(x_full, N);
        end_initialize_time = std::chrono::high_resolution_clock::now();
    }

    // --- Distributed data for each process ---
    std::vector<double> A_local(rows_per_proc * N);
    std::vector<double> x_local(N);
    std::vector<double> y_local(rows_per_proc, 0.0);
    std::vector<double> y_full(N);

    // Step 2: Scatter the matrix A to all processes
    if (rank==0) {
        start_scatter_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Scatter(A_full.data(), rows_per_proc * N, MPI_DOUBLE,
                A_local.data(), rows_per_proc * N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        end_scatter_time = std::chrono::high_resolution_clock::now();
    }

    // Step 3: Broadcast the full vector x to all processes
    if (rank==0) {
        start_bcast_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Bcast(x_full.data(), N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        end_bcast_time = std::chrono::high_resolution_clock::now();
    }

    // Step 4: Perform local matrix-vector multiplication
    if (rank==0) {
        start_multiply_time = std::chrono::high_resolution_clock::now();
    }
    for (int i = 0; i < rows_per_proc; ++i) {
        for (int j = 0; j < N; ++j) {
            y_local[i] += A_local[i * N + j] * x_full[j];
        }
    }
    if (rank==0) {
        end_multiply_time = std::chrono::high_resolution_clock::now();
    }

    // Step 5: Gather the partial results back to the root process
    if (rank==0) {
        start_gather_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Gather(y_local.data(), rows_per_proc, MPI_DOUBLE,
               y_full.data(), rows_per_proc, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        end_gather_time = std::chrono::high_resolution_clock::now();
    }


    // end_overall_compute_time = MPI_Wtime();
    end_overall_compute_time = std::chrono::high_resolution_clock::now();

    // Step 6: Print the final result on the root process
    if (rank == 0) {
        std::cout << "Final result vector y (A * x): ";
        printVector(y_full, N);
    }


    MPI_Finalize();

    // end_overall_time = MPI_Wtime();
    end_overall_time = std::chrono::high_resolution_clock::now();

    // Print execution time components.
    if (rank==0) {
        auto overall_time = std::chrono::duration_cast<std::chrono::microseconds>(end_overall_time - start_overall_time);
        auto overall_compute_time = std::chrono::duration_cast<std::chrono::microseconds>(end_overall_compute_time - start_overall_compute_time);
        auto initialize_time = std::chrono::duration_cast<std::chrono::microseconds>(end_initialize_time - start_initialize_time);
        auto scatter_time = std::chrono::duration_cast<std::chrono::microseconds>(end_scatter_time - start_scatter_time);
        auto bcast_time = std::chrono::duration_cast<std::chrono::microseconds>(end_bcast_time - start_bcast_time);
        auto multiply_time = std::chrono::duration_cast<std::chrono::microseconds>(end_multiply_time - start_multiply_time);
        auto gather_time = std::chrono::duration_cast<std::chrono::microseconds>(end_gather_time - start_gather_time);


        cout << " " << endl;
        cout << "  EXECUTION TIMES" << endl;
        cout << " " << endl;
        cout << " total execution time (s) : " << (overall_time.count() / 1000000.0) << endl;
        cout << " total compute execution time (s) : " << (overall_compute_time.count() / 1000000.0) << endl;
        cout << " initialize time (s) : " << (initialize_time.count() / 1000000.0) << endl;
        cout << " scatter time (s) : " << (scatter_time.count() / 1000000.0)  << endl;
        cout << " bcast time (s) : " << (bcast_time.count() / 1000000.0)  << endl;
        cout << " multiply time (s) : " << (multiply_time.count() / 1000000.0)<< endl;
        cout << " gather time (s) : " << (gather_time.count() / 1000000.0) << endl;
    }

    return 0;
}
~~~


The makefile _makefile.tc.intel.mpiicpx_.

__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple05: main05.C`
3. `clean:`


~~~bash
#### Aug 2024.
#### At VT, on TC cluster.
#### Process:
####     1. module load foss/2023b
####     2. make -f makefile.XXX clean
####     3. make -f makefile.XXX

### For development or running compilations:
### MPICXX=mpicxx -g -fopenmp -pthread
### For production mode.
### MPICXX=mpicxx -O2 -fopenmp -pthread

## To get OpenMP with compile, do:  mpiicc /Qopenmp test.c
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/compiling-an-mpi-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-guide-windows/2021-6/running-an-mpi-openmp-program.html
## See https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-16/overview.html

## Some sayuse -pthread and some -lpthread.??

MPICXX=mpiicpx -O2 -qopenmp -lpthread

CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.
## Load modules outside of this makefile.


### ------------------------------
.C.o:
        $(MPICXX) $(CPPFLAGS) -c $(LDFLAGS) $<

mpi-simple08: main08.C
        $(MPICXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS)
##      mv $@ ../bin/

clean:
        rm mpi-simple08 *.o
~~~
{:  .language-bash}

File job.05.np.100.slurm

Here, "np" means number of processes, i.e., number of MPI processes, which for this file is 100.

~~~
#!/bin/bash


## TC intel MPI.


## -----------------------
# SLURM JOB SCRIPT OPTIONS:
#SBATCH -J intel100

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:30:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.

## Total number compute nodes
## is derived from next two parameters.
## Total number of MPI processes in the entire job.
#SBATCH --ntasks=100

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=50

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## -----------------------
## CONSTRAINTS
#SBATCH --constraint=intel
#SBATCH --constraint=avx512


## -----------------------
## MEMORY.
## #SBATCH --mem=122MB
## #SBATCH --mem-per-cpu=100000000
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.intel.np.100.%j.out
#SBATCH -e slurm.intel.np.100.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
## #SBATCH --partition=parallel
#SBATCH --partition=normal_q


## -----------------------
## ACCOUNT.
## The account (A) to charge to.
#SBATCH --account arcadm


## -----------------------
## MODULES.
module reset
module load intel


## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR


## -----------------------
## Record slurm conditions.
echo "slurm scontrol" 
scontrol show job --details $SLURM_JOB_ID
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
THE_INPUT="10000"
THE_EXEC="./mpi-simple08"
mpirun -n $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
~~~




#### C++ Code Compilation

You have to compile the source code on the same kind of compute node that
you run the code on.
So use the `interact` command at the top of this file to 
obtain an interactive session on an Intel compute node.

~~~bash
module reset
module load intel
make -f makefile.tc.intel.mpiicpx
~~~


#### Slurm Sbatch Job Submission

On a head node, enter: 

~~~bash
sbatch job.05.np.100.slurm
~~~


#### Other Files

The above three files are for one execution, involving
100 MPI processes.

To run jobs with 1000, 10, and 1 MPI process (i.e., this number
of cores [one process per core]):

1.  Make three copies of the sbatch slurm script job.05.np.100.slurm
    - Name them job.05.np.1000.slurm, job.05.np.10.slurm, and job.05.np.1.slurm.
    - For the np=100 slurm script:
        - Change:
            - #SBATCH --ntasks=100
            - #SBATCH --ntasks-per-node=50
        - ... to:
            - #SBATCH --ntasks=1005
            - #SBATCH --ntasks-per-node=67
        - Change all other occurrences of 100 to 1000.
    - For the np=10 slurm script:
        - Change:
            - #SBATCH --ntasks=100
            - #SBATCH --ntasks-per-node=50
        - ... to:
            - #SBATCH --ntasks=10
            - #SBATCH --ntasks-per-node=10
        - Change all other occurrences of 100 to 10.
    - For the np=1 slurm script:
        - Change:
            - #SBATCH --ntasks=100
            - #SBATCH --ntasks-per-node=50
        - ... to:
            - #SBATCH --ntasks=1
            - #SBATCH --ntasks-per-node=1
        - Change all other occurrences of 100 to 1.


Submit the three other sbatch slurm scripts:

~~~bash
sbatch job.05.np.1000.slurm
sbatch job.05.np.10.slurm
sbatch job.05.np.1.slurm
~~~

The above four jobs will provide four data points of execution time,
all for a matix size of 10000x10000.
In the above, we use a square matrix that is 10000 x 10000 elements.
This is specified in the sbatch slurm script as line:  `THE_INPUT="10000"`.


We want to run four more jobs with the square matrix increased to
40000x40000.

You need four sbatch slurm scripts to run these four new jobs.
Make a copy of each of
- job.05.np.1000.slurm to job.06.np.1000.slurm.
- job.05.np.100.slurm to job.06.np.100.slurm.
- job.05.np.10.slurm to job.06.np.10.slurm.
- job.05.np.1.slurm to job.06.np.1.slurm.


And in each new file, change:
-   file job.06.np.1000.slurm:  change `THE_INPUT="10000"`  to `THE_INPUT="40000"`.
-   file job.06.np.100.slurm:  change `THE_INPUT="10000"`  to `THE_INPUT="40000"`.
-   file job.06.np.10.slurm:  change `THE_INPUT="10000"`  to `THE_INPUT="40000"`.
-   file job.06.np.1.slurm:  change `THE_INPUT="10000"`  to `THE_INPUT="40000"`.



Submit four jobs, where the size of the matrix is 40000x40000:


~~~bash
sbatch job.06.np.1000.slurm
sbatch job.06.np.100.slurm
sbatch job.06.np.10.slurm
sbatch job.06.np.1.slurm
~~~


The above four jobs will provide four data points of execution time,
all of which are the execution times when the matrix is 40000x40000.

#### Output

Results follow.


Time obtained via C++ method.

**Matrix-vector multiply.  Matrix is sxs where s=10000**



| ------------- | ------------- | ------------------ | ------------ |
| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1       |   1.9766    |  0.756688   |  0.082368    |
|     10       |  1.71662   |  0.420504   |  0.008596    |
|     100       | 3.30639    | 0.755309    | 0.001578     |
|     1000      |   IN PROGRESS  |   |     |


There is overhead associated with setting up MPI and processes, and this is why the
total EXECUTION time (run time) increases as numbers of processes increases.
For real problems, the amount of computations will dwarf these setup costs, and
overall time will (should) go down as np (number of processors) increases---up to a point.
Look at the last column for the MPI method of obtaining time:  parallel execution time.
If you allow, very crudely, that 
- 0.082368 is roughly 0.1
- 0.008596 is roughly 0.01
- 0.001578 is roughly 0.001
- XXXX is roughly 0.0001

... then you see that the parallel matrix-vector multiply does behave according to the
increases in numbers of processors:  as number of MPI processes increases by an order
of magnitude, the execution time (parallel loop) goes down by an order of magnitude.


All of the times recorded for Intel MPI, for s=10000, and np=100 are (C++ time method):


1. total execution time (s) : 3.30639
2. total compute execution time (s) : 0.755309
3. initialize time (s) : 0.116301
4. scatter time (s) : 0.053076
5. bcast time (s) : 0.000472
6. multiply time (s) : 0.001578
7. gather time (s) : 0.001486


You see the overhead in comparing times #1 and #2.

**Matrix-vector multiply.  Matrix is sxs where s=40000**


| ------------- | ------------- | ------------------ | ------------ |
| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1       |    12.9247  |   11.7783  |  2.26989    |
|     10       |   11.408  |    10.0656  |  0.738681    |
|     100       |  25.4049   |  23.0476   |  0.074034    |
|     1000      |   IN PROGRESS  |   |     |


Again, the parallel multiply time decreases "more-or-less" by an order of magnitude
(not so great for np=1 to np=10)
as the number of MPI processes increases by an order of magnitude.
But the calculations are of such short duration that total execution
and computation times do not decrease with increasing numbers of MPI processes.



Notes:
1. Putting the following command in your sbatch slurm script, after all of the `#SBATCH` directives have
been specified, will print out the hardware that is being used:
`scontrol show job --details <SLURM JOB ID>`.

