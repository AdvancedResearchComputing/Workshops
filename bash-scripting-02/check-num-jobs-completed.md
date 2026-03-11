# Checking Number of Jobs Completed

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



#### Motivation:  Setup and Problem

We motivate the use of the codes in this episode by setting up
an example problem, but it is a real-world problem, too.
We are running a big code with many sets of inputs.
We run these jobs through slurm (but slurm does not explicitly show up;
we simply refer to slurm as a way
to connote big jobs).
Our code/sofware that we run
is set up to print "---- good termination ----'' to standard out as the last
statement that it executes.
This can be motivated by languages like C++ where you must clean up memory,
and this can be problematic, so to ensure memory cleanup was successful,
one can print a statment, such as the one above, as an indicator that
the program shut down properly.
This is just one example.
Since the code writes "---- good termination ----'' to standard out, slurm
will trap that statement and write it to the log file named
"slurm.mifs.danville.06.job.JOBID.out" below, using the `#SBATCH -o` command.
So when an execution of our code, through slurm, completes successfully, there is a
line at the end of the slurm-generated output file that has
"---- good termination ----''; but only if the job completes successfully.

Returning to our example,
we have a large input parametric space:  six variables with five values each.
This is 5**6 = 15625 jobs because we have a full factorial design.
Each job has its own slurm script, so each job has its own slurm output file.
So there will be 15625 slurm output files of the form "slurm.mifs.danville.06.job.JOBID.out''.


~~~bash
#!/bin/bash


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=4-10:00:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.

## Total number of MPI processes across all nodes.
#SBATCH --ntasks=12

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=3

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=4

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.mifs.danville.06.job.%j.out
#SBATCH -e slurm.mifs.danville.06.job.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q


## -----------------------
## ACCOUNT.
## The account (A) to charge to.
#SBATCH --account nsf-crisp-2019


## -----------------------
# If needed, request memory required per node or memory required per allocated
# CPU, in MegaBytes
#
# NOTE: Memory required per node would generally be used if whole nodes are
#       allocated to jobs, while memory required per allocated CPU would
#       generally be used if individual processors are allocated to jobs.
#
# NOTE: The commented out examples below show the currently configured default
#       values.

## -----------------------
## MEMORY.


## -----------------------
## WORKING DIRECTORY.


## -----------------------
## MODULES.
# Optional: If modules are needed, source modules environment
module reset
module load gmvapich2/7.1.0_2.3



## -----------------------
## Envs.


## -----------------------
## EXPORTS
## Exports and variable assignments.


## -----------------------
## JOB.
./run.gen.mifs.blocking.danville.v06.sh

~~~


We submit all of the 15625 jobs at one time, using a bash script.
So every job can be in one of three major states within slurm:
Q (queued), R (running), or completed.
(When a job completes, user information about that job terminates
very soon thereafter, so you very often cannot see
completed jobs via slurm commands.)

Let us say for simplicity that all of the slurm-generated log files are written to
one directory; the extension of our bash script below
to multiple directories is straight-forward.

So we can determine how many total jobs (the sum of jobs) that
are completed or are in progress.
And we can determine how many jobs of these jobs were completed successfully.

The problem and goal are explicitly stated.
There are 15625 slurm jobs that may take days to run.
We want to periodically check on the status of these jobs
over the days by obtaining the number of in-progress plus completed jobs,
and how many jobs were completed successfully.
The bash script below provides this information.

The bash script below resides in some directory, and the slurm-generated
output files reside in a subdirectory named runs.


#### Solution

This bash script will tell us what we need to know.
The script name is _run.check_.

~~~bash
# Number successful jobs.
echo " number of jobs with good termination"
tail -n 1 runs/*.out | grep "good termination" | wc -l

# Number of completed and in-progress jobs.
echo " "
echo " number of jobs total"
ls runs/*.out | wc -l

echo " << end >> "
~~~



An invocation is:

~~~bash
sh run.check
~~~



A sample execution follows.

~~~output
 number of jobs with good termination
 13963

 number of jobs total
 14217
~~~

#### Example:  Check on Number of Running and Queued Slurm Jobs on Cluster

Issue this command to determine number of queued jobs.

~~~bash
squeue -u $USER | grep " Q "  | wc -l
~~~


Issue this command to determine number of running jobs.

~~~bash
squeue -u $USER | grep " R "  | wc -l
~~~

#### Explanation

The log files are in subdirectory `run`.
If it exists, the text "good termination" will be in the last line of our
log files, which have suffix _out_.
Note that this `tail` command operates on **all** *.out files.
So you want to name your slurm-generated output files with a unique suffix, to
make life easier.
So we `tail` the files, with argument `-n 1` to obtain the last line of the files.
That text is piped into the `grep` command, where we determine whether
each of those last lines contains our desired text `good termination`.
Then, we pipe that result into a counter, which is `wc -l`, to count
how many times that desired text appears.

The second piece of code operates with a subset of the commands just described.
In particular, we just determine how many log files exist:
we pipe all of the *.out files into `wc -l` to determine how many of them
there are.
These *.out files can represent completed jobs or jobs that are in-progress.


If the two numbers are equal, then all of the jobs that have
been started, have also been completed successfully.
If the number is not 15625, then this means that some
jobs have not started yet.
The number of jobs not yet started can be determined
with the slurm command `squeue -u username | grep Q  | wc -l`.
This command gives us the count of all our our slurm jobs that have
not started running, i.e., are in the queued (Q) state.

If the numbers are not equal, then one can issue the following command
to determine the number of jobs running or queued: `squeue -u <user-name>  | wc -l`.
Note that we have to subtract one from the result because there is a header line
from slurm in this output.

If the numbers above were something like 2 and 3, then this would indicate
that `sh run.check` was invoked
very soon after the jobs were submitted, because only three
slurm-generated output files have been started (out of 15625 jobs).
And two of those jobs are completed and successful.

We can periodically issues the `sh run.check` command and watch these numbers
in the output grow over time (possibly over days).

This use case and this solution have been used by computer scientists for
20 years (that I know of).
Am sure such solutions have been used a very long time.




