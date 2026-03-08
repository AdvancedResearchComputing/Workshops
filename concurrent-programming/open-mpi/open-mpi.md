# Open MPI

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



## Documentation

Be sure to check for more current releases.

<a href="https://www.open-mpi.org/doc/" target="_blank">https://www.open-mpi.org/doc/</a>



## Overview


These jobs were run on Owl using OpenMPI.

The directions here are for use on Owl.

To run the exact same codes on Tinkercliffs (TC), then in the **sbatch slurm scripts**, do the following.

For Example 1:

1. Delete the line: `#SBATCH --constraint=genoa&avx512`.
2. Insert the line: `#SBATCH --constraint=amd`.

For Example 2:

1. Delete the line: `#SBATCH --constraint=genoa&avx512`.
2. Insert the line: `#SBATCH --constraint=amd`.

For Example 3:

The directions below may not run.  This is because these runs use a lot more
memory and there may be insufficient memory on TC, or it may require further alternations
of the sbatch slurm script.

1. Delete the line: `#SBATCH --constraint=genoa&avx512`.
2. Insert the line: `#SBATCH --constraint=amd`.

## Compilation Via an Interactive Job

There are sections below with heading "C++ Code Compilation" for each of the three examples.

Those give the commands to:

1. reset modules.
2. load module(s).
3. issues a `make` command.

These should all be done on the the type of compute node on which you are going to run.

Since we are running on the Owl cluster and Genoa nodes, that is where we want to create the
binary executable.

So the commands are:

_**Option 1:  The preferred option**_:

Option 1 is preferred because the interactive job will be cleaned up automatically.

~~~bash
## From the owl head node, issues this command to start your interactive job:
interact --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=genoa&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2  
~~~


_**Option 2:  The not-preferred option**_:


~~~bash
## From the owl head node, issues this command to start your interactive job:
salloc --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=genoa&avx512
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

This example is about as simple a code as you can write.
There are three MPI processes, two of which are worker processes
and one is the master process,
in a master-worker relationship.
The two workers each send their rank to the master process and the master prints these ranks.
Process rank 0 is typically the master (or initial) process
created.

What this examples shows, importantly, is the mechanics of 
specifying a sbatch slurm script, a makefile, the source code,
building the source code, and executing a code across compute nodes.

### Inputs

Each of these files should be created on Owl and put in the 
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

Note that you can use `--nodes` instead of `--ntasks`.
You can get one from the other as long as `--ntasks-per-node` is specified.

Make copies of the following files on the cluster, in one directory, by copying the
text here and pasting it into a file with the specified name.



The sbatch slurm script is _job.01.slurm_.

~~~
#!/bin/bash


## openmpi.

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=1:00:00

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
#SBATCH --constraint=genoa
#SBATCH --constraint=avx512


## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.open.mpi.%j.out
#SBATCH -e slurm.open.mpi.%j.err


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
## MEMORY.
## Example if you want/need to specify memory per node.
##SBATCH --mem=122368


## -----------------------
## MODULES.
module reset
module load foss/2023b


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
THE_EXEC="./mpi-simple01"
THE_INPUT=""
srun --mpi=pmix  $THE_EXEC  $THE_INPUT
~~~
{:  .language-bash}


This C++ code just has the worker MPI processes print their ranks.
The C code is _main.C_.

~~~
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
{:  .language-cpp}


The makefile to build the C++ executable is _makefile.owl.open.mpi_.


__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple01: main.C`
3. `clean:` 



~~~
#### Aug 2024.
#### At VT, on TC cluster.
#### Process:
####     1. module load foss/2023b
####     2. make -f makefile.XXX clean
####     3. make -f makefile.XXX

### For development or running compilations:
### MPICXX=mpicxx -g -fopenmp -pthread
### For production mode.
MPICXX=mpicxx -O2 -fopenmp -pthread

### MPICXX=mpicxx -O3 -fopenmp -pthread 
CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.
## Load these modules on the command line, on terminals.
## where this makefile is executed.
## On TC for Open MPI:  module load foss/2023b

### ------------------------------

.C.o:
        $(MPICXX) $(CPPFLAGS) -c $(LDFLAGS) $<

mpi-simple01: main.C
        $(MPICXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS)
##      mv $@ ../bin/

clean:
        rm mpi-simple01 *.o
~~~
{:  .language-bash}

### C++ Code Compilation

The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.

~~~
module reset
module load foss/2023b
~~~
{:  .language-bash}


The compile is through the makefile above called _makefile.tc.open.mpi_.
Invoke like this:

~~~
make -f makefile.owl.open.mpi
~~~
{:  .language-bash}

The executable should be _mpi-simple01_.


### Slurm Sbatch Job Submission

~~~
sbatch job.01.slurm
~~~
{:  .language-bash}


### Output

The output in the specified slurm output file, with SLURM JOB ID 104999,
is _slurm.open.mpi.104999.out_.
Your output will vary, but the same types of information will be output. 

~~~
slurm scontrol
JobId=104999 JobName=job.01.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=5102 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:02 TimeLimit=01:00:00 TimeMin=N/A
   SubmitTime=2025-06-25T16:13:22 EligibleTime=2025-06-25T16:13:22
   AccrueTime=2025-06-25T16:13:22
   StartTime=2025-06-25T16:13:22 EndTime=2025-06-25T17:13:22 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-06-25T16:13:22 Scheduler=Main
   Partition=normal_q AllocNode:Sid=owl1:24305
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl[001-003]
   BatchHost=owl001
   NumNodes=3 NumCPUs=3 NumTasks=3 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=3,mem=23784M,node=3,billing=5
   AllocTRES=cpu=3,mem=23784M,node=3,billing=5
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl[001-003] CPU_IDs=0 Mem=7928 GRES=
   MinCPUsNode=1 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try01/job.01.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try01
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try01/slurm.open.mpi.104999.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try01/slurm.open.mpi.104999.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  3
  num procs total: 3
hello world from sending process 2
  num procs total: 3
hello world from sending process 1
  num procs total: 3
hello world from receiving process 0 (my_rank); received from process 1
hello world from receiving process 0 (my_rank); received from process 2
~~~
{:  .output}



## Example 2

There are two MPI processes.
There are several iterations (8).
In each iteration, one process sends the iteration number to the
other process.
So now the processes are transferring data.
The two processes switch roles on each consecutive iteration:
1. in iteration i, process 0 sends and process 1 receives.
2. in iteration (i+1), process 1 sends and process 0 receives.


### Input

This is the sbatch slurm job submission script _job.02.slurm_.

~~~
#!/bin/bash


## openmpi.


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=1:00:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.

## Total number compute nodes
## is derived from next two parameters.
## Total number of MPI processes in the entire job.
#SBATCH --ntasks=2

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=2

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## -----------------------
## MEMORY.
## #SBATCH --mem=122MB
## #SBATCH --mem-per-cpu=100000000
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## CONSTRAINTS
#SBATCH --constraint=genoa
#SBATCH --constraint=avx512


## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.open.mpi.%j.out
#SBATCH -e slurm.open.mpi.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q


## -----------------------
## ACCOUNT.
## The account (A) to charge to.
#SBATCH --account arcadm


## -----------------------
## MODULES.
module reset
module load foss/2023b



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
THE_INPUT=""
THE_EXEC="./mpi-simple02"
srun --mpi=pmix  $THE_EXEC  $THE_INPUT
~~~
{:  .language-bash}

The C++ code is next.
Notice that the variable that constitutes the message
passed is the single integer iteration_count.
Only the sender updates the iteration_count; the 
receiver RECEIVES and prints this updated iteration_count
value.

This is the C++ code _main02.C_.


~~~
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
{:  .language-cpp}

The makefile for compiling the C++ code is _makefile.owl.02.open.mpi_:

__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple01: main.C`
3. `clean:` 


~~~
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
MPICXX=mpicxx -O2 -fopenmp -pthread

CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.

### On TC for Open MPI:  module load foss/2023b
### (or later)
### On Owl for Open MPI:  module load foss/2023b
### (or later)


### ------------------------------
.C.o:
        $(MPICXX) $(CPPFLAGS) -c $(LDFLAGS) $<

mpi-simple02: main02.C
        $(MPICXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS)
##      mv $@ ../bin/

clean:
        rm mpi-simple02 *.o
~~~
{:  .language-bash}



### Code Compilation

Reset and load the appropriate module.

~~~
module reset
module load foss/2023b
~~~
{:  .language-bash}

To compile the C++ code, we use the makefile above as follows:

~~~
make -f makefile.owl.02.open.mpi
~~~
{:  .language-bash}



### Slurm Sbatch Job Submission

To submit this job to the slurm scheduler, we execute:

~~~
sbatch job.02.slurm
~~~
{:  .language-bash}


### Output

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

The output may not be in the same order in your *.out file because there is 
non-determinism as far as what process writes output when.



~~~
slurm scontrol
JobId=105002 JobName=job.02.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=5097 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:02 TimeLimit=01:00:00 TimeMin=N/A
   SubmitTime=2025-06-25T16:22:18 EligibleTime=2025-06-25T16:22:18
   AccrueTime=2025-06-25T16:22:18
   StartTime=2025-06-25T16:22:18 EndTime=2025-06-25T17:22:18 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-06-25T16:22:18 Scheduler=Main
   Partition=normal_q AllocNode:Sid=owl1:24305
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl001
   BatchHost=owl001
   NumNodes=1 NumCPUs=2 NumTasks=2 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=2,mem=15856M,node=1,billing=3
   AllocTRES=cpu=2,mem=15856M,node=1,billing=3
   Socks/Node=* NtasksPerN:B:S:C=2:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl001 CPU_IDs=0-1 Mem=15856 GRES=
   MinCPUsNode=2 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try02/job.02.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try02
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try02/slurm.open.mpi.105002.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-07/mpi/try02/slurm.open.mpi.105002.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  2
  my rank: 0
  num procs total: 2
 ------------------
iteration counter: 1;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 2;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 3;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 4;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 5;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 6;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
 ------------------
iteration counter: 7;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 8;  MY_RANK: 0;   RECEIVED by rank: 0;   FROM rank 1
  my rank: 1
  num procs total: 2
iteration counter: 1;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 2;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 3;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 4;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 5;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 6;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
iteration counter: 7;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 8;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
~~~
{:  .output}


## Example 3:  Simple Strong Scaling Operation


### Matrix Multiply

The CPP code, the makfile to compile it to machine code, and the sbatch slurm script
are given below.


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



File main08.C


~~~
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
    // start_overall_time = MPI_Wtime();
    start_overall_time = std::chrono::high_resolution_clock::now();

    cout << " Matrix and vector length : " << matrixLength << endl;

    // MPI initialize.
    MPI_Init(&argc, &argv);

    int rank, num_procs;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &num_procs);

    cout << " Number of MPI processes : " << num_procs << endl;
    cout << " " << endl;

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
        // start_multiply_time = MPI_Wtime();
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
{:  .language-cpp}

File makefile.owl.08.open.mpi.

__THIS IS ONE PLACE WHERE THE IDEA OF COPYING TEXT FROM THESE WEB PAGES AND PASTING THEM INTO FILES FALLS DOWN.__

The line AFTER each of these three lines in the file below must start with a tab
(i.e., the tab is what is moving the characters over:

1. `.C.o:`
2. `mpi-simple05: main05.C`
3. `clean:` 


~~~
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
MPICXX=mpicxx -O2 -fopenmp -pthread

CPPFLAGS=-DX86 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES=1

#### ----------------------------------
## Modules needed to compile.

### On TC for Open MPI:  module load foss/2023b
### (or later)
### On Owl for Open MPI:  module load foss/2023b
### (or later)


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


## openmpi.


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
#SBATCH --constraint=genoa
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
#SBATCH -o slurm.open.mpi.np.100.%j.out
#SBATCH -e slurm.open.mpi.np.100.%j.err


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
module load foss/2023b



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
srun --mpi=pmix  $THE_EXEC  $THE_INPUT
~~~
{:   .language-bash}


### C++ Code Compilation

~~~
module reset
module load foss/2023b
make -f makefile.owl.08.open.mpi.
~~~
{:  .language-bash}


### Slurm Sbatch Job Submission

~~~
sbatch job.05.np.1000.slurm
~~~
{:  .language-bash}


**Other Files**

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
            - #SBATCH --ntasks=1000
            - #SBATCH --ntasks-per-node=50
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

~~~
sbatch job.05.np.1000.slurm
sbatch job.05.np.10.slurm
sbatch job.05.np.1.slurm
~~~
{:  .language-bash}

The above four jobs will provide four data points of execution time,
all for a matix size of 10000x10000.
In the above, we use a square matrix that is 10000 x 10000 elements.
This is specified in the sbatch slurm script as line:  `THE_INPUT="10000"`.


We want to run four more jobs with the square matrix increased to 
40000x40000.

You need four new sbatch slurm scripts to run these four new jobs.
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

And in each new file, add the line right below the `#SBATCH --constraint` commands:
-   file job.06.np.1000.slurm:  add `#SBATCH --mem=700G`
-   file job.06.np.100.slurm:  add `#SBATCH --mem=700G`
-   file job.06.np.10.slurm:  add `#SBATCH --mem=700G`
-   file job.06.np.1.slurm:  add `#SBATCH --mem=700G`

This last edition is to accommodate the larger matrix size with more memory.

Submit four jobs, where the size of the matrix is 40000x40000:

~~~
sbatch job.06.np.1000.slurm
sbatch job.06.np.100.slurm
sbatch job.06.np.10.slurm
sbatch job.06.np.1.slurm
~~~
{:  .language-bash}

The above four jobs will provide four data points of execution time.


Results follow.


**Matrix-vector multiply.  Matrix is sxs where s=10000**

Using MPI method to obtain time.

| ------------- | ------------- | ------------------ | ------------ |
| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1         |   0.922435  |  0.326278    |    0.0814236    |
|     10        |   1.81415, 1.86014  |  0.852709, 0.905757    |  0.0106227, 0.0112718      |
|     100       |   3.44933, 3.66874  |  0.462347, 0.619035   |   0.000917126, 0.000934276      |
|     1000      |   4.72815  |  1.12942  |   0.000088713  |

Using C++ method to obtain time.

| ------------- | ------------- | ------------------ | ------------ |
| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1         |  0.874863    |  0.325708    |  0.081417     |
|     10        |  1.32538  |     0.466252   |  0.009836    |
|     100       |  2.99168   |    0.421061 |  0.002127     |
|     1000       |  4.72815   |  1.12942   |   8.8713e-05     |


There is a lot of scatter in the data because the execution times are short.
There is overhead associated with setting up MPI and processes, and this is why the
total EXECUTION time (run time) increases as numbers of processes increases.
For real problems, the amount of computations will dwarf these setup costs, and
overall time will (should) go down as np (number of processors) increases---up to a point.
Look at the last column for the MPI method of obtaining time:  parallel execution time.
If you allow that
- 0.0814236 is roughly 0.1
- 0.0106227 is roughly 0.01
- 0.000917126 is roughly 0.001
- 0.000088713 is roughly 0.0001

... then you see that the parallel matrix-vector multiply does behave according to the
increases in numbers of processors:  as number of MPI processes increases by an order
of magnitude, the execution time (parallel loop) goes down by an order of magnitude.

The same behavior holds for time obtained via a C++ method.

All of the times recorded for OpenMPI, for s=10000, and np=1000 are (MPI time method):

1. total execution time (s) : 4.72815
2. total compute execution time (s) : 1.12942
3. initialize time (s) : 2.59687
4. scatter time (s) : 0.81089
5. bcast time (s) : 0.00191573
6. multiply time (s) : 8.8713e-05
7. gather time (s) : 0.0387748

You see the overhead in comparing times #1 and #2.

**Matrix-vector multiply.  Matrix is sxs where s=40000**

| ------------- | ------------- | ------------------ | ------------ |
| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1         |   5.95987  |   5.24455   |  1.29852     |
|     10        |   8.91727  |   7.88568   |  0.153379    |
|     100       |   20.4053  |   17.1742   |  0.0145024     |
|     1000      |   47.5239  |   41.9713   |  0.00130627   |



Notes:
1. Putting the following command in your sbatch slurm script, after all of the `#SBATCH` directives have
been specified, will print out the hardware that is being used:
`scontrol show job --details <SLURM JOB ID>`.


{% include links.md %}

