# MPICH (MPI)

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



## Documentation


The manual for MPICH is here (this may change over time) and more current releases may be available.

<a href="https://www.mpich.org/static/downloads/4.3.1/mpich-4.3.1-userguide.pdf" target="_blank">https://www.mpich.org/static/downloads/4.3.1/mpich-4.3.1-userguide.pdf</a>




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



Also, on the previous episode, we studied OpenMPI.  Now we are using the MPICH implementation of MPI.

Therefore, what are the big changes between this episode and the previous one?

1. Modules. Note we use these at the command line for compiling and in the sbatch slurm scripts.
    - For OpenMpi, we used `foss/2023b`.
    - For MPICH, we are using `MPICH/4.3.0-GCC-14.2.0` or just `MPICH`.
    - To confirm this module for MPICH, go to a cluster like Owl and type `module spider MPICH` and
      see what versions of MPICH are available.  If a different vintage of MPICH is given, simply
      substitute that new module for the `MPICH/4.3.0-GCC-14.2.0` specified. 
2. We change the names of the slurm-generated output and error files in the sbatch slurm script.
    - For OpenMpi, we use "open.mpi"
    - For MPICH, we use "mpich"
3. The invocation of the MPI code is different.
    - For OpenMpi, we use `srun`.
    - For MPICH, we use `mpiexec`.
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
2. If you used the not-recommended Option 2, then use `scancel` to cancel this interactive job.


## Example 1

This example is about as simple a code as you can write.
There are three MPI processes, two of which are worker processes
and one is the master process,
in a master-worker relationship.
The two workers each send their rank to the master process and the master prints these ranks.
Process rank 0 is typically the master (or initial) process
created.

But what this examples shows, importantly, is the mechanics of 
specifying a sbatch slurm script, a makefile, the source code,
building the source code, and executing a code across compute nodes.

#### Files (Scripts and Codes)

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

Note that you can use `--nodes` instead of `--ntasks`.
You can get one from the other as long as `--ntasks-per-node` is specified.

Make copies of the following files on the cluster, in one directory, by copying the
text here and pasting it into a file with the specified name.

The sbatch slurm script is _job.01.slurm_.

~~~bash
#!/bin/bash


## MPICH.

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

#SBATCH --constraint=genoa&avx512


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
#SBATCH --output slurm.mpich.%j.out
#SBATCH --error slurm.mpich.%j.err


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
## For OpemMPI.
## module load foss/2023b
## For MPICH
module load MPICH/4.3.0-GCC-14.2.0


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
echo "Number of tasks:  $SLURM_NTASKS"



## -----------------------
## JOB.
THE_EXEC="./mpi-simple01"
THE_INPUT=""
## For OpenMpi.
## srun --mpi=pmix  $THE_EXEC  $THE_INPUT
## For MPICH.
mpiexec -n $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
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



The makefile to build the C++ executable is _makefile.owl.mpich_.


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


#### C++ Code Compilation

The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.

~~~bash
module reset
module load MPICH/4.3.0-GCC-14.2.0
~~~



The compile is through the makefile above called _makefile.owl.mpich_.
Invoke like this:

~~~bash
make -f makefile.owl.mpich
~~~

The executable should be _mpi-simple01_.


### Slurm Sbatch Job Submission

~~~bash
sbatch job.01.slurm
~~~


#### Output

The output in the specified slurm output file, with SLURM JOB ID 104999,
is _slurm.mpich.104999.out_.
Your output will vary, but the same types of information will be output. 

__This output was generated on Owl.__

~~~output
slurm scontrol
JobId=169299 JobName=job.01.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1032 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:02 TimeLimit=01:00:00 TimeMin=N/A
   SubmitTime=2025-10-01T16:06:18 EligibleTime=2025-10-01T16:06:18
   AccrueTime=2025-10-01T16:06:18
   StartTime=2025-10-01T16:06:19 EndTime=2025-10-01T17:06:19 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-01T16:06:19 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:1848695
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl[004-006]
   BatchHost=owl004
   NumNodes=3 NumCPUs=3 NumTasks=3 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=3,mem=23784M,node=3,billing=5
   AllocTRES=cpu=3,mem=23784M,node=3,billing=5
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl004 CPU_IDs=0 Mem=7928 GRES=
     Nodes=owl005 CPU_IDs=32 Mem=7928 GRES=
     Nodes=owl006 CPU_IDs=0 Mem=7928 GRES=
   MinCPUsNode=1 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex01/job.01.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex01
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex01/slurm.mpich.169299.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex01/slurm.mpich.169299.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  3
Number of tasks:  3
  num procs total: 3
  num procs total: 3
  num procs total: 3
hello world from sending process 2
hello world from sending process 1
hello world from receiving process 0 (my_rank); received from process 1
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


## MPICH.


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
## CONSTRAINTS
#SBATCH --constraint=genoa&avx512



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
#SBATCH --output slurm.mpich.%j.out
#SBATCH --error slurm.mpich.%j.err


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
module load MPICH/4.3.0-GCC-14.2.0



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
echo "   Number of tasks:  $SLURM_NTASKS"


## -----------------------
## JOB.
THE_INPUT=""
THE_EXEC="./mpi-simple02"
## For OpenMpi.
## srun --mpi=pmix  $THE_EXEC  $THE_INPUT
## For MPICH.
mpiexec -n $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
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


The makefile for compiling the C++ code is _makefile.owl.02.mpich_:

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




#### Code Compilation

We assume that we are in the same session as for Example 1, so we still have
loaded the MPICH module.
If not, repeat the `module reset` and `module load MPICH` commands above.

To compile the C++ code, we use the makefile above as follows:

~~~bash
make -f makefile.owl.02.mpich
~~~

The generated executable file should be _mpi-simple02_.


#### Slurm Sbatch Job Submission

To submit this job to the slurm scheduler, we execute:

~~~bash
sbatch job.02.slurm
~~~


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

__This output was generated on Owl.__

The output may not be in the same order in your *.out file because there is 
non-determinism as far as what process writes output when.

~~~output
slurm scontrol
JobId=169370 JobName=job.02.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1026 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:03 TimeLimit=01:00:00 TimeMin=N/A
   SubmitTime=2025-10-01T16:29:55 EligibleTime=2025-10-01T16:29:55
   AccrueTime=2025-10-01T16:29:55
   StartTime=2025-10-01T16:30:19 EndTime=2025-10-01T17:30:19 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-01T16:30:19 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:1848695
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl042
   BatchHost=owl042
   NumNodes=1 NumCPUs=2 NumTasks=2 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=2,mem=15856M,node=1,billing=3
   AllocTRES=cpu=2,mem=15856M,node=1,billing=3
   Socks/Node=* NtasksPerN:B:S:C=2:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl042 CPU_IDs=0-1 Mem=15856 GRES=
   MinCPUsNode=2 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex02/job.02.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex02
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex02/slurm.mpich.169370.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/mpich/ex02/slurm.mpich.169370.out
   TresPerTask=cpu=1



   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   MV2_ENABLE_AFFINITY:  0
   SLURM_NTASKS:  2
   Number of tasks:  2
  my rank: 0
  num procs total: 2
 ------------------   my rank: 1
  num procs total: 2

iteration counter: 1;  MY_RANK: 0;   SENT from rank: 0;  TO rank 1
iteration counter: 1;  MY_RANK: 1;   RECEIVED by rank: 1;   FROM rank 0
 ------------------
iteration counter: 2;  MY_RANK: 1;   SENT from rank: 1;  TO rank 0
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
Make copies of these files on Owl by copying the text here in these pages and pasting
it into files with the specified names.

#### Files (Scripts and Codes)


File _main08.C_ C++ code.

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
        // start_overall_compute_time = MPI_Wtime();
        start_overall_compute_time = std::chrono::high_resolution_clock::now();
    }

    int rows_per_proc = N / num_procs;

    // --- Data on the root process (rank 0) ---
    std::vector<double> A_full(N * N);
    std::vector<double> x_full(N);

    if (rank == 0) {
        // start_initialize_time = MPI_Wtime();
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
        // end_initialize_time = MPI_Wtime();
        end_initialize_time = std::chrono::high_resolution_clock::now();
    }

    // --- Distributed data for each process ---
    std::vector<double> A_local(rows_per_proc * N);
    std::vector<double> x_local(N);
    std::vector<double> y_local(rows_per_proc, 0.0);
    std::vector<double> y_full(N);

    // Step 2: Scatter the matrix A to all processes
    if (rank==0) {
        // start_scatter_time = MPI_Wtime();
        start_scatter_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Scatter(A_full.data(), rows_per_proc * N, MPI_DOUBLE,
                A_local.data(), rows_per_proc * N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        // end_scatter_time = MPI_Wtime();
        end_scatter_time = std::chrono::high_resolution_clock::now();
    }

    // Step 3: Broadcast the full vector x to all processes
    if (rank==0) {
        // start_bcast_time = MPI_Wtime();
        start_bcast_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Bcast(x_full.data(), N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        // end_bcast_time = MPI_Wtime();
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
        // end_multiply_time = MPI_Wtime();
        end_multiply_time = std::chrono::high_resolution_clock::now();
    }

    // Step 5: Gather the partial results back to the root process
    if (rank==0) {
        // start_gather_time = MPI_Wtime();
        start_gather_time = std::chrono::high_resolution_clock::now();
    }
    MPI_Gather(y_local.data(), rows_per_proc, MPI_DOUBLE,
               y_full.data(), rows_per_proc, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    if (rank==0) {
        // end_gather_time = MPI_Wtime();
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
        // overall_time = end_overall_time - start_overall_time;
        // overall_compute_time = end_overall_compute_time - start_overall_compute_time;
        // initialize_time = end_initialize_time = start_initialize_time;
        // scatter_time = end_scatter_time - start_scatter_time;
        // bcast_time = end_bcast_time - start_bcast_time;
        // multiply_time = end_multiply_time - start_multiply_time;
        // gather_time = end_gather_time - start_gather_time;
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
        // cout << " total execution time (s) : " << overall_time << endl;
        // cout << " total compute execution time (s) : " << overall_compute_time << endl;
        // cout << " initialize time (s) : " << initialize_time << endl;
        // cout << " scatter time (s) : " << scatter_time << endl;
        // cout << " bcast time (s) : " << bcast_time << endl;
        // cout << " multiply time (s) : " << multiply_time << endl;
        // cout << " gather time (s) : " << gather_time << endl;
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


The makefile is _makefile.owl.08.mpich_.

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


The sbatch slurm script file is _job.05.np.100.slurm_:

Here, "np" means number of processes, i.e., number of MPI processes, which for this file is 100.

~~~bash
#!/bin/bash


## MPICH.


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
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512


## -----------------------
## MEMORY.
#SBATCH --mem=400G
## #SBATCH --mem-per-cpu=100000000
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.mpich.np.100.%j.out
#SBATCH --error slurm.mpich.np.100.%j.err


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
module load MPICH/4.3.0-GCC-14.2.0



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
echo "   Number of tasks:  $SLURM_NTASKS"


## -----------------------
## JOB.
THE_INPUT="10000"
THE_EXEC="./mpi-simple08"
## For OpenMpi.
## srun --mpi=pmix  $THE_EXEC  $THE_INPUT
## For MPICH.
mpiexec -n $SLURM_NTASKS  $THE_EXEC  $THE_INPUT
~~~



#### C++ Code Compilation

~~~bash
module reset
module load MPICH/4.3.0-GCC-14.2.0
make -f makefile.owl.08.mpich
~~~

This should produce the executable code _mpi-simple08_.

#### Slurm Sbatch Job Submission

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

And in each new file, add the line right below the `#SBATCH --constraint` commands:
-   file job.06.np.1000.slurm:  change `#SBATCH --mem=400G` to `#SBATCH --mem=740G`
-   file job.06.np.100.slurm:  change `#SBATCH --mem=400G` to `#SBATCH --mem=740G`
-   file job.06.np.10.slurm:  change `#SBATCH --mem=400G` to `#SBATCH --mem=740G`
-   file job.06.np.1.slurm:  change `#SBATCH --mem=400G` to `#SBATCH --mem=740G`

This last change is to accommodate the larger matrix size with more memory.

Submit four jobs, where the size of the matrix is 40000x40000:


~~~bash
sbatch job.06.np.1000.slurm
sbatch job.06.np.100.slurm
sbatch job.06.np.10.slurm
sbatch job.06.np.1.slurm
~~~

The above four jobs will provide four data points of execution time,
all of which are the execution times when the matrix is 40000x40000.

#### Results

Results follow.


Time obtained via C++ method.

**Matrix-vector multiply.  Matrix is sxs where s=10000**



| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1         |   0.963119 |  0.383029   |   0.079726   |
|     10        |   1.80591  |  0.637299   |   0.008141   |
|     100       |   3.91785  |  0.607564   |   0.00096    |
|     1000      |   4.6155   |  0.770686   |   0.000104   |


There is overhead associated with setting up MPI and processes, and this is why the
total EXECUTION time (run time) increases as numbers of processes increases.
For real problems, the amount of computations will dwarf these setup costs, and
overall time will (should) go down as np (number of processors) increases---up to a point.
Look at the last column for the MPI method of obtaining time:  parallel execution time.
If you allow that 
- 0.079726 is roughly 0.08
- 0.008141 is roughly 0.008
- 0.00096 is roughly 0.0008
- 0.000104 is roughly 0.00008

... then you see that the parallel matrix-vector multiply does behave according to the
increases in numbers of processors:  as number of MPI processes increases by an order
of magnitude, the execution time (parallel loop) goes down by an order of magnitude.


All of the times recorded for MPICH, for s=10000, and np=100 are (C++ time method):

1. total execution time (s) : 3.91785
2. total compute execution time (s) : 0.607564
3. initialize time (s) : 0.097103
4. scatter time (s) : 0.210621
5. bcast time (s) : 0.071208
6. multiply time (s) : 0.00096
7. gather time (s) : 0.001861

You see the overhead in comparing times #1 and #2.

**Matrix-vector multiply.  Matrix is sxs where s=40000**


| Number of Processes | Total Execution Time (s) |  Total Compute Time (s)  |  Parallel Multiply Time (s) |
| ------------- | ------------- | ------------------ | ------------ |
|     1         |   7.3215   |  6.69962  |  1.33984     |
|     10        |   13.9103  | 12.5458   | 0.154305     |
|     100       |   23.6254  | 20.082    |  0.020446    |
|     1000      |   21.6054  | 17.7154   |  0.005492    |


Again, the parallel multiply time decreases "more-or-less" by an order of magnitude
as the number of MPI processes increases by an order of magnitude.
But the calculations are of such short duration that total execution
and computation times do not decrease with increasing numbers of MPI processes.


Notes:
1. Putting the following command in your sbatch slurm script, after all of the `#SBATCH` directives have
been specified, will print out the hardware that is being used:
`scontrol show job --details <SLURM JOB ID>`.


