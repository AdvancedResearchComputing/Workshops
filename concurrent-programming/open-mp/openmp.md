# OpenMP

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



### Module

Most modern compilers have OpenMP built into them
and to use OpenMP, you simply specify a compile switch.

OpenMP is used with C, C++, and Fortran.

`module GCC`

or 

`module foss`

or others.

### Virtual Environments

None.



### Documentation

There is massive documentation for this tool.
OpenMP is wonderful; it seems an inescapable conclusion.
The manual is huge because it can do so many things.
But like MPI, with only a few commands, you can do realize
great benefits.

<a href="https://www.openmp.org/" target="_blank">https://www.openmp.org/</a>



### Overview


OpenMP (OMP) is a powerful way to introduce concurrency
into your programs via threading.
OpenMP is a thread-based model.
OpenMP abstracts away a lot of the tedious details of threading
and also has sophisticated constructs to help with things
like load balancing.

It focuses on loops (e.g., for loops, do loops) in serial code and
parallelizes these loops by assigning iterations of a loop to different threads.

It also has constructs like critical sections
and scope rules for variables.

It is a high "bang for the buck" 
tool because it brings a lot of capabilities and features
without introducing the complexity of distributed computing:
- threading
- critical sections
- barriers
- multiple techniques for load balancing
- a LOT more.

The manual is huge because OpenMP can do a lot.
Fortunately, there are a lot of powerful things that can
be done with only a little knowledge.

We run some codes 1, 2, or 3 times.
If you were doing serious timing studies, you would want at least
ten instances for every set of conditions tested.

From one person's own experience---and your needs may be different---it
is hard to overstate the power of this framework.

### Patterns for Using OpenMP


1. You know for the problem of interest that you will always have
    - enough cores on one compute node to run your job(s).
    - enough memory on one compute node to run your job(s).
2. You are using some other paradigm and you want to add threading to 
   the processes in your process group.
   Example paradigms that have applicable processes are:
    - Sockets (TCP and UDP).
    - Message queues.
    - MPI.

In #1 immediately above, if you do not have sufficient memory on one compute
node to run your code ... OR ... 
if you do not have sufficient numbers of cores on one compute node to run your code
... then you KNOW that threading is not a viable option.




## Compilation of C++ or Fortran Source Code Via an Interactive Job

There are sections below with heading "C++ Code Compilation" or "Fortran Code Compilation" for each of the examples.

Those give the commands to:

1. reset modules.
2. load module(s).
3. issues a `make` command.

These should all be done on the the type of compute node on which you are going to run.

Since we are running on the Owl cluster and Genoa nodes, that is where we want to create the
binary executables for the various examples.

So the commands to get us onto a compute node (and then relinquish resources at the end), from a head node, are:

~~~bash
## From the owl head node, issues this command to start your interactive job:
salloc --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=genoa&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2

## The results returned by slurm for the above command will include an owl compute node id, <cnode-id>
ssh <cnode-id>
~~~


where you have to supply your own account.
Now you can enter the module and compile commands specified for each example.

When finished compiling:

1. `exit` off of the compute node.
2. `squeue -u $USER` to get the list of your Slurm jobs.
3. Find the interactive job in this list, call it `JOB_ID`, where `JOB_ID` is a number, like 184909.
4. Use `scancel JOB_ID` to cancel this interactive job.




## Examples Listing

This section is getting fairly big.  Lets map out the examples.  Most examples use C; one uses Fortran.

1.  [Example 1](#example-1--openmp-and-c):  how to iterate through a vector and sum up values.
2.  [Example 2](#example-2--get-rid-of-the-total_sum-variable):  how to do #1, but badly.  Emphasizes the disaster of critical sections.
3.  [Example 3](#example-3--compile-code-without-the-openmp-library):  illustrates that you can compile code with OpenMP pragmas (i.e., directives)
    in it and it will compile fine WITHOUT using the OpenMP library and in this case,
    the code will just run in searial mode.
    - Note that only OpenMP directives are ignored; if you have particular OpenMP commands
      in the code, then you must comment them out for successful compile.
4.  [Example 4](#example-4-run-first-code-with-one-thread):  runs the code of Example 1, but whereas Example 1 used 20 cores, this 
    execution uses only one core for threading, meaning it is a serial code. 
    - We can compare the execution times from all four of these examples because the amount
      of work done is the same in the examples, but the number of cores (and threads) and
      the pragmas are different..
5.  [Example 5](#example-5--matrix-matrix--multiplication):  Matrix-matrix multiplication.
    - All of the earlier examples address iterating through a vector (array) of values.
    - This example gives a different kind of example and shows how matrices can be
      handled. 
6.  Examples for how to schedule the iterations of a loop.
    - Loops are the focal point for parallelization (concurrency) when using OpenMP.
    - There are at least three ways to schdule the handling of iterations.
        - static [(Example 6)](#example-6--schedule-loops-with-static)
        - dynamic [Example 7](#example-7--schedule-loops-with-dynamic)
        - guided  [Example 8](#example-8--schedule-loops-with-guided)
7.  [Example 9](#example-9--fortran-and-openmp):  Use of OpenMP with Fortran.  



## Overview of Technologies


The files to use and their contents are given below.
Here we make observations about this problem.

### Sbatch Slurm Script

- The sbatch switch `--cpus-per-task` is used, typically, in `#SBATCH --cpus-per-task` 
  to specify the number of (OpenMP) threads.
- Slurm has a pre-defined variable for each of these switches.
  For the `--cpus-per-task` switch, it is the Slurm variable `SLURM_CPUS_PER_TASK`.
- Note how this value in Slurm (`SLURM_CPUS_PER_TASK`) gets assigned 
  to the variable that defines the number of threads (`OMP_NUM_THREADS`).
  Look for `OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK` near the bottom of the 
  sbatch slurm script.
- Then you have to export this particular variable name (`OMP_NUM_THREADS`)
  so that OMP can see it in the environment that it runs in.
- So the point is that Slurm, through the variable above in the switch, sets up the OMP (OpenMP)
  environment, so that when the code gets to a `#pragma omp` section, it knows how many threads
  to create and use because the number of threads is in `OMP_NUM_THREADS`.

### C++ code

- OpenMP basically operates on loops; it carves up (partitions) loops so that each thread
  operates on some subset of the loop control variable values.
- So you code the entire loop and let OpenMP carve up the loop; YOU do NOT carve up the loop.
- Each OpenMP directive starts with `#pragma omp`, followed by additional keywords and values.
    - Examples
        - `#pragma omp parallel private(partial_Sum) shared(total_Sum)` starts an OMP block.
            - At the end of an OpenMP block is an implied "barrier" where all threads wait for all
              other threads to finish.  So colloquially, all threads "sync up." 
        - `pragma omp for` denotes an OpenMP for loop.
        - `pragma omp critical` denotes an OpenMP critical section.
        - `pragma omp barrier` denotes an instruction where all OMP threads stop and wait for all threads to "get there",
          i.e., to "sync up."
        - `pragma omp single` denotes that only one thread should execute the commands.
- Data sharing clauses (specified at the top of an OpenMP block:
    - `shared`: threads access the exact same variable (default)
         - shared variables come into the `OMP Parallel` section with the value they have
           before the `OMP Parallel` section.
    - `private`: threads access their own copies of the variable (uninitialised)
         - private variables do NOT, upon entering an OMP block, take on the value of the
           variable before the OMP block.
         - therefore, private variables must be initialized inside the OMP block.
    - `firstprivate`: same as private but initialised from value before clause
    - `lastprivate`: same as private but last iteration of loop gives value to variable after the loop ends
    - Examples of `private` and `shared` in Examples 1 and 2.
        - `partial_Sum` is private because each OpenMP (OMP) thread uses it over and over to sum up its part;
          so no thread wants to share this value.  It needs to keep the tally for its own (running) use.
        - `total_Sum` is shared because when each thread finishes its partial sum, it needs to 
          add its `partial_Sum` to the `total_Sum`.
- Data coming out of an OMP block.
    - All variables passed into the OMP block as _shared_ variables are accessible by the code---with updated values---after the block.
    - That is, the scope of shared variables is all the code after the block, in the same routine.
- Load balancing in loops.
    - Use the `schedule` keyword.
    - Values are:
        - `static`:  partition the loop iterations to the threads at the start.
        - `dynamic`:  partition the loop iterations in chunks; when a thread completes on chunk, it goes back for another chunk.
        - `guided`:  like dynamic, but the chunks get smaller as one nears the end of the loop:  large chunks at the beginning, small at end.
    - Applications (maybe; try it):
        - `static`:  matrix-vector, matrix-matrix multiple (or other operations with a very regular structure).
        - `dynamic`:  I don't really know.
        - `guided`:  when you have variable-length iterations, such as those often encountered with analyzing graphs.
    - Syntax
        - `#pragma omp for schedule(static, 8)` means chunk size is eight loop iterations,
          and you keep "round robin"ing.
        - `#pragma omp for schedule(dynamic, 8)` means chunk size is eight loop iterations,
          and a thread gets assigned the next chunk as it becomes available.
        - `#pragma omp for schedule(guided, 7)` means initial chunk size is seven loop iterations and that seven will decrease as
          the end of the iterations nears.

## Example 1:  OpenMP and C++

This example is run on the Owl cluster.


#### Files (Scripts and Code)

The sbatch slurm script is _job.01.slurm_.

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=20

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.01.openmp.20.cores.%j.out
#SBATCH --error   slurm.job.01.openmp.20.cores.%j.err

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## PRINT RESOURCES.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end job resources >>"
echo " "

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.01.sh
~~~


The run script _run.01.sh_.

~~~bash
## invoke:  sh run.01.sh 

## CLA
num_iterations=1000

## Code invocation, CLI
./main.exe  ${num_iterations}
~~~


The C code is _main.C_.

~~~c
#include <stdio.h>
#include <omp.h>
#include <chrono>
#include <iostream>
#include <string>

using namespace std;
using namespace std::chrono;

int main(int argc, char** argv)
{

    // Get starting timepoint
    auto start = high_resolution_clock::now();

    long int partial_sum=0;
    long int total_sum=0;
    long int num_loops=0;

    // The CLI is the number of loops.
    num_loops = std::stol(argv[1]);
    std::cout << "\n  The number of loops is: " <<  num_loops << "\n" << std::endl;

    #pragma omp parallel private(partial_sum) shared(total_sum,num_loops)
    {
        partial_sum = 0;
        long int itime = 0;
        int num_threads = 0;

        // Print number of threads.
        #pragma omp single
        {
            // Get number of threads.
            num_threads =  omp_get_num_threads();
            std::cout << "\n  The number of OMP threads is: " <<  num_threads << "\n" << std::endl;
        }

        // This is what is being divvied up among the (20) threads.
        // We chose 20 for this example, arbitrarily, but you can 
        // choose any number; it does not have to "divide evenly."
        #pragma omp for
        for (itime = 1; itime <= num_loops; ++itime) {
            partial_sum += itime;
        }

        // Create thread safe region.
        #pragma omp critical
        {
            // Add each threads partial sum to the total sum
            total_sum += partial_sum;
        }
    }

    cout << "Total Sum: " << total_sum << "\n" << std::endl;

    // Get ending timepoint
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    std::cout << "Time taken by code: "
              << duration.count() << " microseconds" << endl;

    return 0;
}
~~~


#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is:

~~~bash
g++ main.C -o main.exe -fopenmp
~~~




#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.01.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output

 job resources:

JobId=184337 JobName=job.01.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1020 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:03 TimeLimit=00:10:00 TimeMin=N/A
   SubmitTime=2025-10-29T11:57:32 EligibleTime=2025-10-29T11:57:32
   AccrueTime=2025-10-29T11:57:32
   StartTime=2025-10-29T13:09:04 EndTime=2025-10-29T13:19:04 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-29T13:09:04 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:146065
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl049
   BatchHost=owl049
   NumNodes=1 NumCPUs=20 NumTasks=1 CPUs/Task=20 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=20,mem=158560M,node=1,billing=39
   AllocTRES=cpu=20,mem=158560M,node=1,billing=39
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl049 CPU_IDs=32-47,81-84 Mem=158560 GRES=
   MinCPUsNode=20 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex04/job.01.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex04
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex04/slurm.job.01.openmp.20.cores.184337.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex04/slurm.job.01.openmp.20.cores.184337.out
   TresPerTask=cpu=20


   SLURM_CPUS_PER_TASK:  20
   OMP_NUM_THREADS:  20
   SLURM_NTASKS:  1

  The number of loops is: 1000


  (Inside OMP section) The number of loops is: 1000


  The number of OMP threads is: 20

Total Sum: 500500

Time taken by code: 29188 microseconds
~~~



The sum of the numbers from 1 to n is (n)(n+1)/2 = (1000)(1001)/2 = (500)(1001) = 500500, so the output is correct.

So the 20 threads here work together to compute this sum of 500500.



## Example 2:  Get rid of the `total_Sum` variable.

How can we do this?  Change the C++ code to the following.

#### Files (Scripts and Code)

The file is _main02.C_.


~~~c
#include <stdio.h>
#include <omp.h>
#include <chrono>
#include <iostream>
#include <string>

using namespace std;
using namespace std::chrono;

int main(int argc, char** argv)
{

    // Get starting timepoint
    auto start = high_resolution_clock::now();

    long int total_sum=0;
    long int num_loops=0;

    // The CLI is the number of loops.
    num_loops = std::stol(argv[1]);
    std::cout << "\n  The number of loops is: " <<  num_loops << "\n" << std::endl;

    #pragma omp parallel shared(num_loops,total_sum)
    {

        long int itime = 0;
        int num_threads = 0;

        // Print numnber of threads.
        #pragma omp single
        {
            std::cout << "\n  (Inside OMP block) The number of loops is: " <<  num_loops << "\n" << std::endl;
            // Get number of threads.
            num_threads =  omp_get_num_threads();
            std::cout << "\n  The number of OMP threads is: " <<  num_threads << "\n" << std::endl;
        }


        // This is what is being divvied up among the (20) threads.
        // We chose 20 for this example, arbitrarily, but you can 
        // choose any number; it does not have to "divide evenly."
        #pragma omp for
        for (itime = 1; itime <= num_loops; ++itime) {

            // Create thread safe region.
            #pragma omp critical
            {
                // Add each threads partial sum to the total sum
                total_sum += itime;
            }
        }

    }

    cout << "Total Sum: " << total_sum << "\n" << std::endl;


    // Get ending timepoint
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    std::cout << "Time taken by code: "
              << duration.count() << " microseconds" << endl;

    return 0;
}
~~~


The other two files---the sbatch slurm script and the run script---now named
_job.02.slurm_ and _run.02.sh_, respectively---are essentially the same, with
just a couple of name changes inside the files.

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=20

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.02.openmp.20.cores.%j.out
#SBATCH --error   slurm.job.02.openmp.20.cores.%j.err


## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## PRINT RESOURCES.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.02.sh
~~~

Contents of file _run.02.sh_:

~~~bash
## invoke:  sh run.02.sh 

## CLA
num_iterations=1000

## Code invocation, CLI
./main02.exe  ${num_iterations}
~~~



#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.

The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~



The compile statement is:

~~~bash
g++ main02.C -o main02.exe -fopenmp
~~~





#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.02.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output
   SLURM_CPUS_PER_TASK:  20
   OMP_NUM_THREADS:  20
   SLURM_NTASKS:  1

  The number of loops is: 1000


  The number of OMP threads is: 20

Total Sum: 500500
Time taken by code: 131277 microseconds
~~~



Look what happens:  the execution time increases by a factor of 5x or 6x,
from 19806 or 29188 microseconds (two separate jobs) to 1312777 microseconds. 


| -------------- | ----------------- | ----------------- |
|   Source Code  |  Number of Threads  | Execution Time (microseconds) |
| -------------- | ----------------- | ----------------- |
|    main.C      |  20               | 19806, 29188      |
|    main02.C    |  20               | 131277            |
| -------------- | ----------------- | ----------------- |

What is going on here?  Why has the execution time increased so much?

- We got rid of the `partial_sum` variable in Example 2.
- So we are putting all values---all value updates of the sum---into the variable `total_sum`.
- Perfectly legal.
- But in Example 2 we got rid of the "accumulation" variable for each thread ("partial_sum")
  that is in Example 1, which when
  present means each thread can "blast away" running as fast as it can and put its running
  tally in partial_sum, so in this part of the code, each thread operates INDEPENDENTLY.
- Getting rid of this "intermediate result" variable, partial_sum, means that all threads
  have to share that one variable (total_sum) so they are INTERDEPENDENT, and it gets updated a lot---num_loops number of times.
- It is best to have each thread running independently; it is bad to have threads running interdependently.
- A shared variable has to be treated specially, delicately by each thread because it means that the 
  threads are running interdependently.
- So we are "banging on" that critical section many times so that execution is "bad":
    - Crucially, only one thread at a time can execute the code in a critical section to update total_sum.
    - Therefore, the threads have to "get in line" i.e., run serially, not in parallel, to get access to total_sum inside the critical section
      so that the thread can update the total_sum value.
        -  In Example 2, we have turned a concurrently-executing code into a serially-executing code and this is bad.
    - There is overhead with using critical sections---controlling all threads (granting permission, revoking permission, etc.)---and that costs, too.
- And hence the increase in exeuction time for this Example 2 compared to Example 1.


Examples 1 and 2 are provided to make the above points.
The codes that are being used are very simple.
On purpose.
We want to get to use as small (i.e., as simple) a code as possible so that we do
not have to spend a ton of time understanding what a code does. 
The counterpoint is that with a simple code, the execution times are normally quite small, as is the case here.
So the data above, in this case, show exactly what we want to show.
Great.
And I have run the two codes again and got the following results:


| -------------- | ----------------- | ----------------- |
|   Source Code  |  Number of Threads  | Execution Time (microseconds) |
| -------------- | ----------------- | ----------------- |
|    main.C      |  20               |   31536           |   
|    main02.C    |  20               |   63565           |
| -------------- | ----------------- | ----------------- |


Again, good:  main.C runs twice as fast (i.e., in one-half of the time) as main02.C,
showing that lots of executions of code inside a critical section lead to poor performance.

But it is possible that you could run the two codes and get that main02.C runs FASTER than does main.C.
If so, this is because the code segments are so small.
If you have normal codes, entailing more computations, then you will not get the case where
main02.C runs faster than main.C.
Rather, you will get results like those in the two tables above.

Regardless of these possible difficulties, we always go with the approach of using small codes.  And deal with the consequences.






__Lesson__:  Make iterations of loops as independent as possible. 


### Example 3:  Compile code without the OpenMP Library

We:

1. start with main02.C and make a copy called main02.serial.C.
2. comment out the section of code with method call get_omp_num_threads().
3. all pragmas that do not have special OpenMP functions can remain as is.
    - Without compiling with the OpenMP switch, the pragmas are ignored and the code is compiled like a serial code.
    - But as we see in step #2, any OMP-specific methods have to be commented out.
4. compile the code in the same way as before, but remove the `-fopenmp` switch.
5. then submit the `job.03.slurm` job.

#### Files (Scripts and Code)


The slurm sbatch script is _job.03.slurm_:

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.03.compiled.serial.%j.out
#SBATCH --error   slurm.job.03.compiled.serial.%j.err


## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## PRINT RESOURCES.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end job resources >>"
echo " "

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.03.sh
~~~


The run bash script is _run.03.sh_:


~~~bash
## invoke:  sh run.03.sh 

## CLA
num_iterations=1000

## Code invocation, CLI
./main02.serial.exe  ${num_iterations}
~~~


The C/C++ code _main02.serial.C_ is:

~~~c
#include <stdio.h>
#include <omp.h>
#include <chrono>
#include <iostream>
#include <string>

using namespace std;
using namespace std::chrono;

int main(int argc, char** argv){

    // Get starting timepoint
    auto start = high_resolution_clock::now();

    long int partial_sum=0;
    long int num_loops=0;

    // The CLI is the number of loops.
    num_loops = std::stol(argv[1]);
    std::cout << "\n  The number of loops is: " <<  num_loops << "\n" << std::endl;

    #pragma omp parallel shared(num_loops,partial_sum)
    {

        long int itime = 0;
        int num_threads = 0;

        // Print numnber of threads.
        // #pragma omp single
        // {
        //     // Get number of threads.
        //     num_threads =  omp_get_num_threads();
        //     std::cout << "\n  The number of OMP threads is: " <<  num_threads << "\n" << std::endl;
        // }


        // This is what is being divvied up among the (20) threads.
        // We chose 20 for this example, arbitrarily, but you can 
        // choose any number; it does not have to "divide evenly."
        #pragma omp for
        for (itime = 1; itime <= num_loops; ++itime) {

            // Create thread safe region.
            #pragma omp critical
            {
                // Add each threads partial sum to the total sum
                partial_sum += itime;
            }
        }

    }

    cout << "Total Sum: " << partial_sum << "\n" << std::endl;


    // Get ending timepoint
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    std::cout << "Time taken by code: "
              << duration.count() << " microseconds" << endl;

    return 0;
}
~~~



#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is (notice no `-fopenmp` switch):

~~~bash
g++ main02.serial.C -o main02.serial.exe 
~~~




#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.03.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output
   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   SLURM_NTASKS:  1

  The number of loops is: 1000

Total Sum: 500500
Time taken by code: 9715 microseconds
~~~


The sum of the numbers from 1 to n is (n)(n+1)/2 = (1000)(1001)/2 = (500)(1001) = 500500, so the output is correct.


Our updated table is:

| -------------- | ----------------- | ----------------- |
|   Source Code  |  Number of Threads  | Execution Time (microseconds) |
| -------------- | ----------------- | ----------------- |
|    main.C      |  20     | 19806, 29188  |   
|    main02.C    |  20     | 131277 |
|    main02.serial.C |   1  |    9715, 1176, 1032 |
| -------------- | ----------------- |


The serial code is twice as fast, or 20x as fast, as our best OpenMP code, main.C.
The third row entry was run three times, so there are three times listed.
You will see why below that I ran the last row multiplel times:  I did not like the 9715 microseconds timing,
but I have no reason to throw it away.

What is going on here?  The loop is so small/fast to execute that the overhead in instantiating
and running OMP threads is costlier than the benefits from parallel execution.
With bigger, more realistic problem sizes, the overhead/instantiating times will
be insignificant.


## Example 4: Run first code with one thread

We:

1. start with main.C and use that.
2. start with job.01.slurm and copy it to make job.04.slurm.
    - For the variable `--cpus-per-task`, set `=1`.  (It was 20.)
3. copy `run.01.sh` to `run.04.sh`.
4. do not need to compile any code; we still have the machine code `main.exe`.
5. then submit the `job.04.slurm` job.

#### Files (Scripts and Code)

The slurm sbatch script is _job.04.slurm_:

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.04.openmp.1.core.%j.out
#SBATCH --error   slurm.job.04.openmp.1.core.%j.err


## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## PRINT RESOURCES.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end job resources >> "
echo " "

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.01.sh
~~~



The run bash script is _run.01.sh_, which is given above.

The C++ code is _main.C_, which was compiled above into _main.exe_.


#### C++ Code Compilation

We do not compile anything.
We are reusing the compiled version of _main.C_,
which is _main.exe_.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~
sbatch job.04.slurm
~~~
{:  .language-bash}


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output
   SLURM_CPUS_PER_TASK:  1
   OMP_NUM_THREADS:  1
   SLURM_NTASKS:  1

  The number of loops is: 1000


  The number of OMP threads is: 1

Total Sum: 500500
Time taken by code: 1190 microseconds

~~~


The sum of the numbers from 1 to n is (n)(n+1)/2 = (1000)(1001)/2 = (500)(1001) = 500500, so the output is correct.


Our updated table is:

| -------------- | ----------------- | ----------------- |
|   Source Code  |  Number of Threads  | Execution Time (microseconds) |
| -------------- | ----------------- | ----------------- |
|    main.C            |  20     | 19806, 29188 |   
|    main02.C          |  20     | 131277 |
|    main02.serial.C   |  1      | 9715, 1176, 1032 |
|    main.C            |  1      | 1190, 1048  |
| -------------- | ----------------- |


The "serial code" (i.e., parallel OMP code with one thread) has a 
comparable execution time to the "pure serial" code (main02.serial.C).

What is going on here?  The loop contents are so small/fast
and the number of iterations is small, that the overhead in instantiating
and running threads is costlier than the benefits from parallel execution.

I'm now wondering whether I got the 9715 microseconds execution time for a wrong job.




## Example 5:  Matrix-Matrix  Multiplication

We have done loops above over scalars.

Now we present an example with matrices---lots of computational loops deal with matrices.


We:

1. assign two square matrices a single scalar value for each entry.
2. then multiply them:  C = A*B.
3. then if the matrices are sufficiently small, we print them out.

#### Files (Scripts and Code)

The slurm sbatch script is _job.05.slurm_:

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=2

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.05.openmp.2.cores.%j.out
#SBATCH --error   slurm.job.05.openmp.2.cores.%j.err

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## Print resources.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end job resources >>"
echo " "

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.05.sh
~~~


The run bash script is _run.05.sh_:


~~~bash
## invoke:  sh run.05.sh 

## CLI
square_matrix_dimension=4
code="./mm.exe"

## Code invocation
${code}  ${square_matrix_dimension}
~~~


The C++ code _mmultiply.C_ is:

~~~c
#include <iostream>
#include <vector>
#include <omp.h>
#include <chrono>
#include <string>

using namespace std::chrono;

// Function to perform matrix multiplication
void matrix_multiply_openmp(const std::vector<std::vector<int>>& A,
                            const std::vector<std::vector<int>>& B,
                            std::vector<std::vector<int>>& C,
                            int mlength) {
    // Ensure matrices are properly sized (mlength x mlength) for this example
    // A: mlength x mlength, B: mlength x mlength, C: mlength x mlength

    // Parallelize the outer loop.
    // The variables i, j, k are loop counters and are private by default in OpenMP 'for' loops.
    // A, B, and C are shared by default because they are defined outside the parallel region.
    // This is safe because each thread is writing to a unique C[i][j] element.
    #pragma omp parallel for shared(A, B, C, mlength) default(none)
    for (int i = 0; i < mlength; ++i) {
        for (int j = 0; j < mlength; ++j) {
            // Use a local variable to accumulate the sum for a single C[i][j] element.
            // This prevents race conditions on the C matrix updates within the inner-most loop.
            int sum = 0;
            for (int k = 0; k < mlength; ++k) {
                sum += A[i][k] * B[k][j];
            }
            // The final result is written to the shared C matrix only once, 
            // after the entire dot product for C[i][j] is computed. Each thread 
            // has exclusive access to its assigned C[i][j] cell.
            C[i][j] = sum;
        }
    }
}

// Function to print out matrices.
void print_matrix(std::string name, std::vector<std::vector<int>>& matrix, long int mlength)
{
    long int itime=0;
    long int jtime=0;

    std::cout << std::endl;
    std::cout << "Matrix : " << name << std::endl;
    std::cout << std::endl;

    for (itime = 0; itime < mlength; ++itime) {
        for (jtime = 0; jtime < mlength; ++jtime) {
            std::cout << "  " << matrix[itime][jtime] ;
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
    std::cout << std::endl;
    return;
}



int main(int argc, char** argv)
{
    // const int mlength = 500; // Size of the matrices (mlength x mlength)

    long int mlength = std::stol(argv[1]);
    std::cout << "\n  The size/length of a dimension of the square matrices is: " <<  mlength << "\n" << std::endl;


    // Initialize matrices A and B with some values
    std::vector<std::vector<int>> A(mlength, std::vector<int>(mlength, 2));
    std::vector<std::vector<int>> B(mlength, std::vector<int>(mlength, 3));
    std::vector<std::vector<int>> C(mlength, std::vector<int>(mlength, 0));

    // Optional: set the number of threads
    // omp_set_num_threads(4); 

    auto start = high_resolution_clock::now();

    matrix_multiply_openmp(A, B, C, mlength);

    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(stop - start);

    // If matrices are small enough, then print them out.
    if (mlength < 11) {
        print_matrix("A", A, mlength);
        print_matrix("B", B, mlength);
        print_matrix("C (result of A*B)", C, mlength);
    }

    std::cout << "Time taken by function: " << duration.count() << " milliseconds" << std::endl;

    return 0;
}
~~~



#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is (notice `-fopenmp` switch):

~~~bash
g++ mmultiply.C -o mm.exe -fopenmp
~~~




#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.05.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output

 job resources:
 
JobId=184387 JobName=job.05.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1019 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:04 TimeLimit=00:10:00 TimeMin=N/A
   SubmitTime=2025-10-29T13:00:58 EligibleTime=2025-10-29T13:00:58
   AccrueTime=2025-10-29T13:00:58
   StartTime=2025-10-29T13:01:04 EndTime=2025-10-29T13:11:04 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-29T13:01:04 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:146065
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl003
   BatchHost=owl003
   NumNodes=1 NumCPUs=2 NumTasks=1 CPUs/Task=2 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=2,mem=15856M,node=1,billing=3
   AllocTRES=cpu=2,mem=15856M,node=1,billing=3
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl003 CPU_IDs=91-92 Mem=15856 GRES=
   MinCPUsNode=2 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex05/job.05.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex05
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex05/slurm.job.05.openmp.2.cores.184387.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex05/slurm.job.05.openmp.2.cores.184387.out
   TresPerTask=cpu=2


   SLURM_CPUS_PER_TASK:  2
   OMP_NUM_THREADS:  2
   SLURM_NTASKS:  1

  The size/length of a dimension of the square matrices is: 4


Matrix : A

  2  2  2  2
  2  2  2  2
  2  2  2  2
  2  2  2  2



Matrix : B

  3  3  3  3
  3  3  3  3
  3  3  3  3
  3  3  3  3



Matrix : C (result of A*B)

  24  24  24  24
  24  24  24  24
  24  24  24  24
  24  24  24  24


Time taken by function: 0 milliseconds
~~~




## Example 6:  Schedule Loops With `static`

This is an example that focuses on one scheduler approach for
iterating over loop iterations.
In the static method, the total number of iterations is 
divided by the total number of OMP threads.
The quotient of these is how many iterations q are assigned to
each thread, and the first thread is assigned the first q
iterations, the second thread executes the second q iterations,
and so on.
So the static method does all assignments at loop begin
time.

#### Files (Scripts and Code)


Sbatch slurm script _job.06.lb.static.slurm_. 


~~~bash
#!/bin/bash


## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=2:00:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=20

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.06.static.20.cores.%j.out
#SBATCH --error   slurm.job.06.static.20.cores.%j.err

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## Print resources.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.06.static.sh
~~~



The bash script _run.06.static.sh_.

~~~bash
## invoke:  sh run.06.static.sh 

## CLAs
num_iterations=1000
code="./main.lb.06.static.exe"

## Code invocation, CLI
${code}  ${num_iterations}
~~~



The C++ code below is _main.lb.06.static.C_.

Note that the "contents" of each iteration of a loop is not the same.
The work is skewed to be greater for the later loop iterations.
So we are trying to make the "static" schedule method perform
relatively poorly.


The key line in the C/C++ file is `#pragma omp for schedule(static)`,

~~~c
#include <iostream>
#include <vector>
#include <cmath> // For std::pow
#include <chrono> // For timing
#include <cstdint>  // For more precise types.
#include <cstdlib>  // For type conversions.



// A function with highly varying computational cost.
// Simulates a task where larger work_load values take significantly longer.
uint64_t expensive_calculation(uint64_t work_load) {
    uint64_t sum = 0;
    uint64_t itime = 0;
    for (itime = 0; itime < work_load; ++itime) {
        sum += std::pow(itime, 2); // Simulate a more complex calculation
    }
    return sum;
}


int main(int argc, char** argv)
{
    uint64_t itime=0;
    uint64_t num_iterations=0;
    uint64_t work_load=0;
    // const int num_iterations = 1000;
    char* endptr;
    num_iterations = std::strtoull(argv[1], &endptr, 10);

    std::cout << "Number of iterations: " << num_iterations << std::endl;

    std::vector<uint64_t> results(num_iterations);

    auto start_time = std::chrono::high_resolution_clock::now();

    #pragma omp parallel private(itime, work_load) shared(num_iterations, results)
    {
        work_load=0;
        itime=0;

        #pragma omp for schedule(static)
        for (itime = 0; itime < num_iterations; ++itime) {
            // The work for each iteration depends heavily on 'itime'
            // Iterations with higher itime values will have much more work
            work_load = itime * itime;
            results[itime] = expensive_calculation(work_load);
        }
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_time = end_time - start_time;

    std::cout << "Parallel execution time (default static schedule): " << elapsed_time.count() << " seconds" << std::endl;

    return 0;
}
~~~



#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is:

~~~bash
g++    main.lb.06.static.C  -o  main.lb.06.static.exe   -fopenmp
~~~




#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.06.lb.static.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output

 job resources:
 
JobId=184584 JobName=job.06.lb.static.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1020 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:02 TimeLimit=02:00:00 TimeMin=N/A
   SubmitTime=2025-10-29T16:09:37 EligibleTime=2025-10-29T16:09:37
   AccrueTime=2025-10-29T16:09:37
   StartTime=2025-10-29T16:18:09 EndTime=2025-10-29T18:18:09 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-29T16:18:09 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:146065
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl010
   BatchHost=owl010
   NumNodes=1 NumCPUs=20 NumTasks=1 CPUs/Task=20 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=20,mem=158560M,node=1,billing=39
   AllocTRES=cpu=20,mem=158560M,node=1,billing=39
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl010 CPU_IDs=24-43 Mem=158560 GRES=
   MinCPUsNode=20 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/job.06.lb.static.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.static.20.cores.184584.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.static.20.cores.184584.out
   TresPerTask=cpu=20


   SLURM_CPUS_PER_TASK:  20
   OMP_NUM_THREADS:  20
   SLURM_NTASKS:  1
Number of iterations: 1000
Parallel execution time (default static schedule): 0.706604 seconds
~~~

The total number of iterations is 1000 (specified in _run.06.static.sh_)
and the number of threads is 20 (specified by `--cpus-per-task` in file _job.06.lb.static.slurm_).

We'll show the execution time together with those for schedules `dynamic` and `guided` after Example 8.


## Example 7:  Schedule Loops With `dynamic`


This is an example that focuses on one scheduler approach for
iterating over loop iterations.
In the dynamic method, the total number of iterations of one block
is specified.  Here, we use a value of 5.
This method works by assigning each thread 5 iterations.
Then, when a thread finishes its assigned iterations, it is 
assigned another set of 5 iterations.
So assignment of iterations to threads is dynamic and provides
better load balancing than static when iterations have different execution times.
 

#### Files (Scripts and Code)


The sbatch slurm script is _job.06.lb.dynamic.5.slurm_. 


~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=2:00:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=20

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.06.dynamic.05.20.cores.%j.out
#SBATCH --error   slurm.job.06.dynamic.05.20.cores.%j.err

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## Print resources.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end job resources >>"
echo " "

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.06.dynamic.05.sh
~~~



The bash script _run.06.dynamic.05.sh_.

~~~bash
## invoke:  sh run.06.dynamic.05.sh

## CLAs
num_iterations=1000
code="./main.lb.06.dynamic.5.exe"

## Code invocation, CLI
${code}  ${num_iterations}
~~~



The C++ code below is _main.lb.06.dynamic.C_.

Note that the "contents" of each iteration of a loop is not the same.
The work is skewed to be greater for the later loop iterations.
So we are trying to make the "dynamic" schedule method perform
better than "static."

The key line in the C++ file is `#pragma omp for schedule(dynamic,5)`,
where the dynamic scheduling method is used and a block of iterations
assigned to one thread is five.
How was five determined?  A guess basically.
There are 1000 iterations and 20 threads.
So in aggregate, where all loops have the same work
(which is not the case here), then
each thread executes 1000/20=50 iterations.
So I just took 1/10th of that number to give the scheduler leeway
in assigning blocks to threads.
The decsision is a tradeoff:  the lesser the number, the more 
likely there will be good load balancing, but the more
overhead is required to control (and feed iterations to) the threads.
If you have important code, you experiment with this number.



~~~c
#include <iostream>
#include <vector>
#include <cmath> // For std::pow
#include <chrono> // For timing
#include <cstdint>  // For more precise types.
#include <cstdlib>  // For type conversions.



// A function with highly varying computational cost.
// Simulates a task where larger work_load values take significantly longer.
uint64_t expensive_calculation(uint64_t work_load) {
    uint64_t sum = 0;
    uint64_t itime = 0;
    for (itime = 0; itime < work_load; ++itime) {
        sum += std::pow(itime, 2); // Simulate a more complex calculation
    }
    return sum;
}


int main(int argc, char** argv)
{
    uint64_t itime=0;
    uint64_t num_iterations=0;
    uint64_t work_load=0;
    // const int num_iterations = 1000;
    char* endptr;
    num_iterations = std::strtoull(argv[1], &endptr, 10);
    std::vector<uint64_t> results(num_iterations);

    std::cout << "Number of iterations: " << num_iterations << std::endl;

    auto start_time = std::chrono::high_resolution_clock::now();

    #pragma omp parallel private(itime, work_load) shared(num_iterations, results)
    {
        work_load=0;
        itime=0;

        #pragma omp for schedule(dynamic,5)
        for (itime = 0; itime < num_iterations; ++itime) {
            // The work for each iteration depends heavily on 'itime'
            // Iterations with higher itime values will have much more work
            work_load = itime * itime;
            results[itime] = expensive_calculation(work_load);
        }
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_time = end_time - start_time;

    std::cout << "Parallel execution time ( (dynamic, 5) schedule): " << elapsed_time.count() << " seconds" << std::endl;

    return 0;
}
~~~




#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is:

~~~bash
g++ main.lb.06.dynamic.C   -o   main.lb.06.dynamic.5.exe    -fopenmp
~~~



#### Slurm Sbatch Job Submission

Now we are back on the head node.

Submit the job with

~~~bash
sbatch job.06.lb.dynamic.5.slurm
~~~



#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output

 job resources:
 
JobId=184582 JobName=job.06.lb.dynamic.5.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1020 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:03 TimeLimit=02:00:00 TimeMin=N/A
   SubmitTime=2025-10-29T16:09:37 EligibleTime=2025-10-29T16:09:37
   AccrueTime=2025-10-29T16:09:37
   StartTime=2025-10-29T16:17:39 EndTime=2025-10-29T18:17:39 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-29T16:17:39 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:146065
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl010
   BatchHost=owl010
   NumNodes=1 NumCPUs=20 NumTasks=1 CPUs/Task=20 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=20,mem=158560M,node=1,billing=39
   AllocTRES=cpu=20,mem=158560M,node=1,billing=39
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl010 CPU_IDs=24-43 Mem=158560 GRES=
   MinCPUsNode=20 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/job.06.lb.dynamic.5.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.dynamic.05.20.cores.184582.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.dynamic.05.20.cores.184582.out
   TresPerTask=cpu=20


   SLURM_CPUS_PER_TASK:  20
   OMP_NUM_THREADS:  20
   SLURM_NTASKS:  1
Number of iterations: 1000
Parallel execution time ( (dynamic, 5) schedule): 0.28585 seconds
~~~



The total number of iterations is 1000 (specified in _run.06.dynamic.sh_)
and the number of threads is 20 (specified by `--cpus-per-task` in file _job.06.lb.dynamic.slurm_).
Each thread is fed five iterations at a time.

We'll show the execution time together with those for schedules `static` and `guided` after Example 8.


## Example 8:  Schedule Loops With `guided`

This is an example that focuses on one scheduler approach for
iterating over loop iterations.
In the guided method, the total number of iterations of one block
is specified.  Here, we use a value of 10.
This method works by assigning each thread 10 iterations, for initial assignments.
Then, when a thread finishes its assigned iterations, it is 
assigned another set of 10 (or fewer) iterations.
The "or fewer" is because as the latter iterations of the loop are
approached, the number of iterations in a block is automatically reduced
for better load balancing.
So assignment of iterations to threads is dynamic and provides
better load balancing than static when iterations have different execution times.
 


#### Files (Scripts and Code)


Sbatch slurm script _job.06.lb.guided.10.slurm_. 


~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=2:00:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=20

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## CONSTRAINTS.
#SBATCH --constraint=genoa&avx512

## -----------------------
## MEMORY.

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## ACCOUNT.
## You must specify your own account in place of "arcadm".
#SBATCH --account arcadm

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output  slurm.job.06.guided.10.20.cores.%j.out
#SBATCH --error   slurm.job.06.guided.10.20.cores.%j.err

## -----------------------
## MODULES.
## Always reset modules first.
module reset
module load foss/2023b

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## Print resources.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID

## -----------------------
## EXPORTS 
## Exports and variable assignments.
OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS

## Always write out (echo) important variables.
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.06.guided.10.sh
~~~



The bash script _run.06.guided.10.sh_.

~~~bash
## invoke:  sh run.06.guided.10.sh 

## CLI
num_iterations=1000
code="./main.lb.06.guided.10.exe"

## Code invocation
${code}  ${num_iterations}
~~~


The C/C++ code below is _main.lb.06.guided.C_.

Note that the "contents" of each iteration of a loop is not the same.
The work is skewed to be greater for the later loop iterations.
So we are trying to make the "guided" schedule method perform
better than the "static" method.



~~~c
#include <iostream>
#include <vector>
#include <cmath> // For std::pow
#include <chrono> // For timing
#include <cstdint>  // For more precise types.
#include <cstdlib>  // For type conversions.



// A function with highly varying computational cost.
// Simulates a task where larger work_load values take significantly longer.
uint64_t expensive_calculation(uint64_t work_load) {
    uint64_t sum = 0;
    uint64_t itime = 0;
    for (itime = 0; itime < work_load; ++itime) {
        sum += std::pow(itime, 2); // Simulate a more complex calculation
    }
    return sum;
}


int main(int argc, char** argv)
{
    uint64_t itime=0;
    uint64_t num_iterations=0;
    uint64_t work_load=0;
    // const int num_iterations = 1000;
    char* endptr;
    num_iterations = std::strtoull(argv[1], &endptr, 10);
    std::vector<uint64_t> results(num_iterations);

    std::cout << "Number of iterations: " << num_iterations << std::endl;

    auto start_time = std::chrono::high_resolution_clock::now();

    #pragma omp parallel private(itime, work_load) shared(num_iterations, results)
    {
        work_load=0;
        itime=0;

        #pragma omp for schedule(guided,10)
        for (itime = 0; itime < num_iterations; ++itime) {
            // The work for each iteration depends heavily on 'itime'
            // Iterations with higher itime values will have much more work
            work_load = itime * itime;
            results[itime] = expensive_calculation(work_load);
        }
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_time = end_time - start_time;

    std::cout << "Parallel execution time (  (guided, 10) schedule): " << elapsed_time.count() << " seconds" << std::endl;

    return 0;
}
~~~



#### C++ Code Compilation

Remember:  you first have to go onto a compute node and compile
from there.
See instructions above for how to perform this interactive job.


The module must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script above.


~~~bash
module reset
module load foss/2023b
~~~


The compile statement is:

~~~bash
g++    main.lb.06.guided.C   -o     main.lb.06.guided.10.exe    -fopenmp
~~~




#### Slurm Sbatch Job Submission

Now we are back on the head node.

~~~bash
sbatch job.06.lb.guided.10.slurm
~~~


#### Output

The slurm output file (the file name in the sbatch slurm script for the line `#SBATCH --output`) 
will contain something like this.

~~~output

 job resources:
 
JobId=184583 JobName=job.06.lb.guided.10.slurm
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1020 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:03 TimeLimit=02:00:00 TimeMin=N/A
   SubmitTime=2025-10-29T16:09:37 EligibleTime=2025-10-29T16:09:37
   AccrueTime=2025-10-29T16:09:37
   StartTime=2025-10-29T16:17:39 EndTime=2025-10-29T18:17:39 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-10-29T16:17:39 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:146065
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl010
   BatchHost=owl010
   NumNodes=1 NumCPUs=20 NumTasks=1 CPUs/Task=20 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=20,mem=158560M,node=1,billing=39
   AllocTRES=cpu=20,mem=158560M,node=1,billing=39
   Socks/Node=* NtasksPerN:B:S:C=1:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl010 CPU_IDs=44-47,80-95 Mem=158560 GRES=
   MinCPUsNode=20 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=avx512 DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/job.06.lb.guided.10.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06
   StdErr=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.guided.10.20.cores.184583.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2025/2025-10/parallel-01/openmp/ex06/slurm.job.06.guided.10.20.cores.184583.out
   TresPerTask=cpu=20


   SLURM_CPUS_PER_TASK:  20
   OMP_NUM_THREADS:  20
   SLURM_NTASKS:  1
Number of iterations: 1000
Parallel execution time (  (guided, 10) schedule): 0.363564 seconds
~~~



The total number of iterations is 1000 (specified in run.06.dynamic.sh) and
the number of threads is 20 (specified by --cpus-per-task in file job.06.lb.guided.10.slurm).
Each thread is fed ten iterations at a time initially, and then this number is reduced as
work on the loop progresses.


Over Examples 6 through 8, we now have these timing results:

| -------------- | ----------------- | ----------------- | ------------------------ |
|  Example       |   Source Code     |  Scheduler Method | Execution Time (seconds) |
| -------------- | ----------------- | ----------------- | ------------------------ |
|    6           |    main.06.lb.static.C     |  static      |   0.706604 |
|    7           |    main.06.lb.dynamic.5.C  |  dynamic, 5  |   0.28585  |
|    8           |    main.06.lb.guided.10.C  |  guided, 10  |   0.363564 |
| -------------- | ----------------- | ----------------- | ------------------------ |

So the more sophisticated methods (the last two), where the timing and numbers of blocks of iterations provided
to threads is not statically done, perform better by at least (roughly) a factor of two. 



## Example 9:  Fortran and OpenMP

Example 9 is also run on the Owl cluster.

We do the same code in Fortran (essentially the same code; a few extra statements).


We will use the GCC 14.2.0 compiler, which has gfortran compliant through 2018.

Rules to remember:
In an `OMP Parallel` section, 

1. shared variables come into the `OMP Parallel` section with the value they have
before the `OMP Parallel` section.
2. private variables come into the `OMP Parallel` section with undefined values;
__NOT__ the values before the `OMP Parallel` section.


File _sbatch.fortran.slurm_

~~~bash
#!/bin/bash
  

## Owl OpenMP


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number compute nodes.
#SBATCH --nodes=1

## Number of processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., one thread per cpu).
#SBATCH --cpus-per-task=4

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.openmp.4.cores.%j.out
#SBATCH -e slurm.openmp.4.cores.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q
#SBATCH --constraint=genoa&avx512

## -----------------------
## ACCOUNT.
#SBATCH -A arcadm

## -----------------------
## MEMORY.

## -----------------------
## MODULES.
module reset
module load GCC/14.2.0

## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## PRINT RESOURCES.
echo " "
echo " job resources:"
echo " "
scontrol show job --details $SLURM_JOB_ID

## -----------------------
## EXPORTS 
## Exports and variable assignments.
num_threads=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=${num_threads}

echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   SLURM_NTASKS: "  $SLURM_NTASKS


## -----------------------
## JOB.
sh run.me
~~~


File _summing.f95_

~~~f95
PROGRAM Summing_OpenMP

    USE OMP_LIB

    implicit none
    integer :: i
    integer :: thread_id
    integer :: num_threads
    integer :: total_Sum = 0
    integer :: partial_Sum = 0
    integer :: loop_times=1000
    real :: start_time, end_time, elapsed_time

    ! Start timer.
    call cpu_time(start_time)

    !$OMP PARALLEL PRIVATE(thread_id, num_threads)
        ! Get the thread ID for the current thread
        thread_id = OMP_GET_THREAD_NUM()

        ! Get the total number of threads in the parallel region
        num_threads = OMP_GET_NUM_THREADS()

        PRINT *, "Hello from thread", thread_id, "of", num_threads, "threads."
    !$OMP END PARALLEL


    !$OMP PARALLEL private(i,partial_Sum)  SHARED(total_Sum,loop_times)

        partial_Sum=0
        ! total_Sum=0

        ! This is what is being divvied up among the (20) threads.
        ! We chose 20 for this example, arbitrarily, but you can
        ! choose any number; it does not have to "divide evenly."
        ! Note that you put the ENIRE loop here; OMP carves it up.
        !$OMP DO
            DO i = 1, loop_times
                partial_Sum = partial_Sum + i
            END DO
        !$OMP END DO

        print*, "Thread has partial sum : ",partial_Sum

        ! Create thread safe region.
        !$OMP CRITICAL (my_lock_01)
            ! Code block to be executed by only one thread at a time.
            ! Add each thread's partial sum to the total sum.
            total_Sum = total_Sum + partial_Sum;
        !$OMP END CRITICAL (my_lock_01)

    !$OMP END PARALLEL

    PRINT *, "Total Sum: ", total_Sum, ".";


    ! End timer.
    call cpu_time(end_time)

    elapsed_time=end_time-start_time
    print *, "Elapsed CPU time: ", elapsed_time , " seconds"


END PROGRAM Summing_OpenMP
~~~



File _run.compile_ for compiling the code.

~~~bash
## execution:   sh run.compile   <single fortran code> 

code=$1

gfortran -fopenmp ${code} -o summing
~~~

File _run.me_ for invoking the code:

~~~bash

## Set number of threads.
## export OMP_NUM_THREADS=4

## Executable.
./summing
~~~


This last file is primarily for setting the number of threads for the
OpenMP execution during debugging.

#### Fortran Code Compilation

So the compilation is:

~~~bash
module reset
module load GCC/14.2.0
~~~


In the last command above, you can issue `module load GCC` instead of the provided
command to get the latest GCC module.

~~~bash
sh run.compile summing.f90
~~~


and the executable is "summing".

#### Slurm Sbatch Job Submission

To execute the code by submitting a batch job, type:

~~~bash
sbatch sbatch.fortran.slurm
~~~


#### Output

The output should be in the slurm-generated output file that is
specified in the sbatch slurm script (sbatch.fortran.slurm) above.:


~~~output
   SLURM_CPUS_PER_TASK:  4
   OMP_NUM_THREADS:  4
   SLURM_NTASKS:  1
 Hello from thread           2 of           4 threads.
 Hello from thread           3 of           4 threads.
 Hello from thread           0 of           4 threads.
 Hello from thread           1 of           4 threads.
 Thread has partial sum :        93875
 Thread has partial sum :        31375
 Thread has partial sum :       156375
 Thread has partial sum :       218875
 Total Sum:       500500 .
 Elapsed CPU time:    1.11159999E-02  seconds
~~~
{:  .output}

where the execution time will of course be different for you.
The ordering of the partial sums will probably be different,
but the total sum should be 500500.



