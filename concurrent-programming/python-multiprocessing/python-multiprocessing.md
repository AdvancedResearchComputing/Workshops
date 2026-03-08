# Python Multiprocessing

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



## Overview

The "multiprocessing" package implements a type of forking, so instead of
running multiple "threads" concurrently, it will execute
multiple "processes" concurrently.
However, those processes then do not share the same address
space.
This means that if you want each "process" to operate on the SAME LARGE
set of data, then each process must have its OWN COPY of that same large
data, which can be a huge waste of resources and can severely limit the size
of problem that you tackle (on any cluster, not just ARC clusters).

Python also has the concept of a thread, but it, too, is not one's
common understanding of a thread.
Python threads do not truly run concurrently.
Rather, all threads time-slice on one core.
So, for example, if you have a code that runs serially in _5y_ seconds,
and if you can reorganize your code so that five threads are used
and therefore each thread does one-fifth of the work, the code
will NOT run in _y_ seconds because those threads will not run
in parallel, as you would expect a true threading mechanism to operate.
The code will still run in about _5y_ seconds.
This is because Python uses a Global Interpreter Lock (GIL) that restricts
threads execution.
Python, in 3.13 and 3.14, has a threading mechanism that that is "no-GIL"
but it is considered experimental and is not addressed here.


## Modules

The module `Python/3.12.3-GCCcore-13.3.0` is used in the first
example.
It is used just to demonstrate that you can use a module.

_**Note:**_  One issue with creating documents like these is that this document
is static, but the software on (ARC) clusters is not.
So while we use here the particular module that contains python,
`Python/3.12.3-GCCcore-13.3.0`, it may/will go away at some time in the future.
For this work, any python module, say Python >=3.12 will work.
To see the available python modules on a cluster, type at the
command prompt:  `module spider python` and use one of those.
If the one used in these notes is not available, just use one that is.
There will be many modules that appear because python is used in a lot
of modules; pick one that is `Python/XXXXXXX`, consistent with the format above.

However, Example 1 is very minimalistic.
It does not use other python packages.
In real work, it is almost certain that you will need
other Python packages.
In this case, you do NOT want to use a python module
for the `multiprocessing` package and then use a 
virtual environment (VE) for other Python packages.
The reason is that there may be some inconsistency between
the module and the packages in a VE.

Instead, you should put the `multiprocessing` package
in the VE.
The pip or conda package manager will then ensure compatibility among all of the packages.

But we use modules in this example just to show that it can be
done ... for simple cases.

## Virtual Environments

None used here, but in general you want to.




## Example 1

This example is run on the Owl cluster.


This is a parallel code where a main process forks
four other processes that each alter a list and print
its contents.
The contents of the lists are different, indicating
that the forked processes all have their own address
spaces and hence do not have the same data.

This job is run on the Owl cluster.

#### Input Files

The sbatch slurm script file _run.01.sbatch_.


```bash
#!/bin/bash

#SBATCH -J p-multiprocess

## Wall time.
#SBATCH --time=00:10:00 # 1 hour

## #SBATCH --account=personal
#SBATCH --account=arcadm

### This requests 1 node, 5 cores.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=5

## Partition.
#SBATCH --partition=normal_q

## Use the compute node only for this job, and use all memory on this node.
## #SBATCH --exclusive
## #SBATCH --mem=0
## #SBATCH --mem=10G

## Slurm output and error files.
#SBATCH -o slurm.python.multiprocessing.04.job.%j.out
#SBATCH -e slurm.python.multiprocessing.04.job.%j.err

## This can be very annoying.
## #SBATCH --mail-type=BEGIN,END
## #SBATCH --mail-user=ckuhlman@vt.edu
## #SBATCH --mail-user=hugo3751@gmail.com

# Load modules.
module load Python/3.12.3-GCCcore-13.3.0


# Activate a python env.
## None.


# Code to execute.
sh run.01
```

The run script is _run.01_.

```
python main.py
```


The python code filename is _main.py_.


```python
from multiprocessing import Process
import time


def print_func(continent,list_cont):

    print('The name of continent is : ', continent)
    list_cont.append(continent)
    time.sleep(5)
    print(" All continents, including added one: ",list_cont)
    return



if __name__ == "__main__":  # confirms that the code is under main function

    names = ['Asia','America', 'Europe', 'Africa']
    procs = []

    # instantiating process with arguments
    for name in names:
        # print(name)
        proc = Process(target=print_func, args=(name,names))
        procs.append(proc)
        proc.start()

    # complete the processes
    for proc in procs:
        proc.join()

```


#### Submit the Slurm Job

The job is submitted by:

```bash
sbatch run.01.sbatch
```

#### Results

Output is written to the slurm-generated output file, whose name
in this instance is _slurm.python.multiprocessing.04.job.82421.out_.

For each of the four processes, the first four elements of the list
are the same; these values were set before the processes were forked.
Thereafter, each forked process adds another element to the list.
Rather than each process having a list of all entries, 
each process has a unique fifth element of its list.

```
The name of continent is :  Asia
 All continents, including added one:  ['Asia', 'America', 'Europe', 'Africa', 'Asia']
The name of continent is :  America
 All continents, including added one:  ['Asia', 'America', 'Europe', 'Africa', 'America']
The name of continent is :  Europe
 All continents, including added one:  ['Asia', 'America', 'Europe', 'Africa', 'Europe']
The name of continent is :  Africa
 All continents, including added one:  ['Asia', 'America', 'Europe', 'Africa', 'Africa']
```


When the slurm job has finished, do not forget to run `seff` according to:

```
seff SLURM_JOB_ID
```


