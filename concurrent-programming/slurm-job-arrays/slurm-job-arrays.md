# Slurm Job Arrays


#### Link Back To Main

[Back to Main Page](../concurrency-main.md)

#### TODO:  More Examples

More information to be incorporated into this document from Kuhlman's other md pages.



## Job Arrays

Job arrays in slurm enable multiple executions of a single code,
with different input parameters---all in a single slurm job.
Actually, you could, by incorporating bash scripts or other codes,
invoke different codes.
But invoking a single code with different sets of inputs is the typical
way job arrays are used.
One should/could consider repeating the steps herein for each different code.
In slurm, one element of a job array is a _task_, so each task has a _TASK_ID_.



### Example 1

This is an example to demonstrate that multiple parameters
can be incorporated into a job array.

Run this example on Tinkercliffs or Owl.

There are seven jobs (tasks) that are executed---independent
executions---in one sbatch submission to slurm.
You can readily see that if instead of seven, you
have a job array of 100 or more elements,
then you can do a lot of work with just one
sbatch submission---which will only count one against the
number of jobs you have in the queue.

Each job array task will generate its own sbatch output
and error files.
This is why the format for the slurm-generated output
and error files changes---so each file contains both
the unique JOB ID and the job array number
with the `%A` and `%a` symbols, like so:

```
#SBATCH --output  r.para.job.array.%A_%a.out
#SBATCH --error   r.para.job.array.%A_%a.err
```



#### Inputs

Input files follow.
Simply paste the contents of these files into files
on ARC clusters, using, say, the vi editor.
Put all of these files in the same directory.

This is an input file.
It is used by the slurm script, not the R code.
It maps the number of the job array to the values of
the triple of CLAs.

This is file _config.txt_.
There are three parameters for each invocation of the
R script:  alpha, beta, and gamma.

```
ArrayTaskId    alpha     beta     gamma
1               1         2          3
2               4         5          6
3               7         8          9
4              10        11         12
5              13        14         15
6              16        17         18
7              19        20         21
```

#### Files/Codes

This slurm sbatch script is _slurm.02.sbatch_.

```bash 
#!/bin/bash


## #SBATCH -J rPara
#SBATCH --job-name jarray

## Account.
#SBATCH --account arcadm

## Time.
#SBATCH --time 00:10:00

## Partition.
#SBATCH --partition normal_q

## Num compute nodes, executing tasks, compute cores.
## The first three lines are applied per job array task (jat).
## These resources are NOT cumulative over all of the jats.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --array=1-7

## The command below means that of the 100 jobs,
## you can only run at most 7 jobs at one time.
## #SBATCH --array=1-100%7
## This is a "step" operation.  This says to run jobs
## 0, 5, 10, 15, 20, 25, and 30.
## #SBATCH --array=0-30:5


## Slurm output and error files.
## For job arrays.
#SBATCH --output  r.para.job.array.%A_%a.out
#SBATCH --error   r.para.job.array.%A_%a.err


echo "date: `date`"
echo "hostname: $HOSTNAME"; echo

# Write details of the job's resources.
echo -e "\nChecking job details for CPU_IDs..."
scontrol show job --details $SLURM_JOB_ID


# Specify the path and name of the config file
config=./config.txt

# Extract param1.  Each job array task will extract one value.
param1=$(awk -v ArrayTaskId=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskId {print $2}' $config)

# Extract param2.  Each job array task will extract one value.
param2=$(awk -v ArrayTaskId=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskId {print $3}' $config)

# Extract param3.  Each job array task will extract one value.
param3=$(awk -v ArrayTaskId=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskId {print $4}' $config)

# Echo parameters.  Each task of the job array will
# print out its particular values.
echo "param1:  ${param1}"
echo "param2:  ${param2}"
echo "param3:  ${param3}"

# Load the module to run R.
module load R/4.4.2-gfbf-2024a

# R invocation.
Rscript test_args.R $param1 $param2 $param3
```


The R script that is our code in this example, is _test_args.R_.
Note that it reads in a sequence of CLAs (command line arguments)
and writes them to standard out.


```R
args = commandArgs(trailingOnly=TRUE)

fmt_str = paste("From ", Sys.info()["nodename"], "...   Arguments: ")
for (a in args) {fmt_str <- paste(fmt_str, " ",  a)}
print(fmt_str)
```


#### Submit Batch Job

To submit the job, type:

```
sbatch slurm.02.sbatch
```

You just submitted a job in _batch mode_, i.e., you are running
in _batch mode_.

#### Output


The directory where the codes are placed will look something like
the following, after the slurm job is complete.
You see the input files.
Since the job array is size 7 (i.e., seven jobs inside of the
single slurm script and hence single slurm job),
you see seven pairs of file for each job array ID,
which ranges from 1 to 7.
Here, the job ID on Owl was 08652, so the
slurm-generated error and output files have the format
`< JOB ID > _ < JOB ARRAY ID >` in each filename.
Error and output files are suffixed *.err and *.out respectively.
This is how we specified them in the slurm.01.sbatch
file above.

So slurm individualizes the error and output files per job in
the array.


```bash
[ckuhlman@owl1 code01]$ ll
total 24
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   313 Feb 28 13:19 config.txt
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:35 r.para.job.array.80652_1.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1898 Feb 28 13:35 r.para.job.array.80652_1.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:35 r.para.job.array.80652_2.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1898 Feb 28 13:35 r.para.job.array.80652_2.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:35 r.para.job.array.80652_3.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1898 Feb 28 13:35 r.para.job.array.80652_3.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:35 r.para.job.array.80652_4.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1904 Feb 28 13:35 r.para.job.array.80652_4.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:35 r.para.job.array.80652_5.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1904 Feb 28 13:35 r.para.job.array.80652_5.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:36 r.para.job.array.80652_6.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1904 Feb 28 13:36 r.para.job.array.80652_6.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   146 Feb 28 13:36 r.para.job.array.80652_7.err
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage 12246 Feb 28 13:36 r.para.job.array.80652_7.out
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage  1410 Feb 28 15:07 slurm.01.sbatch
-rw-r--r-- 1 ckuhlman arc.kuhlman-project-storage   184 Feb 28 13:08 test_args.R
```


If you look at the end of file, say r.para.job.array.80652_4.out, you
will see:

```
param1
10
param2
11
param3
12
[1] "From  owl008 ...   Arguments:    10   11   12"
```

This is correct based on file config.txt above:  job array 4 uses parameters 10, 11, and 12.

The very last print statement comes from the R code;
all previous output statements come from the slurm script.
There is more in the *.out files and you should look at
them.

Note that what we see here is a basic operation of slurm:
slurm takes all print statements that normally go to standard out
(stdout), which is typically your terminal screen, and
redirects them to the slurm output file, whose name is
specified in the slurm script slurm.02.sbatch above.

This is why the "output" of these jobs is in the
slurm-generated output file---the *.out files.





