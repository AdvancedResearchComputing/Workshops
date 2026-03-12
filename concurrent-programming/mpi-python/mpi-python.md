# MPI and Pythong (MPI4Py)

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



### Useful links

#### Use

Just note this page exists:  we are not using it right now.

[https://mpi4py.readthedocs.io/en/stable/tutorial.html#running-python-scripts-with-mpi](https://mpi4py.readthedocs.io/en/stable/tutorial.html#running-python-scripts-with-mpi)

#### Install

Just note this page exists:  we are not using it right now.
That is, do not install anything right now.
We are going to use virtual environments instead.

[https://mpi4py.readthedocs.io/en/4.0.3/install.html](https://mpi4py.readthedocs.io/en/4.0.3/install.html)


### Installation and Use of Mpi4Py Via Virtual Environments

To use Mpi4Py, you need to create a virtual environment (VE) that contains
Mpi4Py.
But the specific instance of Mpi4Py depends on the MPI implementation.

Assuming you are using conda, e.g., via the `Miniforge3` module, the table below
shows the correspondence.

|   MPI Implementation   |    Install Commands | 
| ------------------ | ----------------------- |
|  MPICH           |    `conda install -c conda-forge mpi4py mpich` |
|  Open MPI        |    `conda install -c conda-forge mpi4py openmpi`  |
| Intel MPI        |    `conda install -c conda-forge mpi4py impi_rt` |
| Microsoft MPI    |    `conda install -c conda-forge mpi4py msmpi` |


## Examples Summary

Example 1 uses Mpi4py with CPU processing.

Example 2 uses Mpi4py with GPU processing.

This is one of our first examples with virtual environments (VEs).
We are building VEs in this episode almost like an aside from our main
purpose.
We have an entire workshop on VEs and how to make them.

The main points here are:
1. You can only RUN your job that uses a VE on the type of compute
node that was used to CREATE the VE.
2. So if you use the a30_normal_q partition on Falcon to create your VE,
then you can only run jobs on Falcon cluster using the A30 gpus, i.e.,
using the a30_normal_q partition.
3. So you might want to create the "same" VE using several partitions
(even across clusters) to give you more flexibility where you run your code.
4. The good thing is, the steps to create a VE on these different partitions
are almost identical.
5. Currently, the partitions on Tinkercliffs (TC) and Owl that 
   contain only CPU multicore compute nodes have MULTIPLE types of 
   compute nodes.  In this case, you also have to use `--constraint=`
   to uniquely specify a compute node.
   -  See the videos in this section for more details [https://docs.arc.vt.edu/usage/video.html#how-to-run-codes-your-own-or-commercial-open-software](https://docs.arc.vt.edu/usage/video.html#how-to-run-codes-your-own-or-commercial-open-software).


### Examples

#### Example 1:  MPI4Py on CPU compute nodes.

#### Creating a Virtual Environment on Owl

The process for creating a VE for other clusters and compute node types 
is very similar.

This version is NOT CUDA enabled.

This example is to run on the Owl genoa nodes.
Very few modifications are required to run on TC (Tinkercliffs) cluster.

Just note:  when virtual environments (VEs) are involved, 
you must run your code on the type of node used to 
create the VE.
This is a universal constraint.

~~~bash
## Obtain resources from slurm.
## On the genoa nodes (because there are more of them than milan: 84 vs. 4).
salloc --account=<account>  --partition=normal_q    --constraint=genoa      --nodes=1 --ntasks-per-node=1 --cpus-per-task=2 --time=2:00:00

## ssh to the compute node.
ssh owlXXX

## Module reset on compute node.
module reset

## Load module for conda.
## Best practice is to fully specify the module.
module load Miniforge3/25.11.0-1

## Load module for Open MPI.
module load foss/2023b

## Load CUDA.  <--- Optional, not done here.
## module load CUDA/12.6.0

## Create the VE.
## conda create -p ~/env/owl/normal_q_genoa/py312_mf_openmpi
conda create -p ~/env-python/owl/normal_q/genoa/py34_mf_openmpi_mpi4py


## Activate the VE.
## source activate ~/env/owl/normal_q_genoa/py312_mf_openmpi
source activate ~/env-python/owl/normal_q/genoa/py34_mf_openmpi_mpi4py


## Install python.
conda install python=3.14

## Check:  should show correct version
python --version

## Install Mpi4Py, for OpenMPI
## This is the statement that varies, per the table at the top of this section,
## based on the version of MPI that you are using.
conda install -c conda-forge mpi4py openmpi


## Install numpy.  Use of numpy arrays with python faster.  Evidently.
conda install numpy

## Install any more packages you desire.


## List packages
conda list

## Deactivate VE.
conda deactivate

## Exit off of compute node; go back to head node.
exit


## Return unused resources to slurm.
## squeue command shows the SLURM_JOB_ID.
## Look for the SLURM_JOB_ID corresponding to your interactive job.
squeue -u $USER
scancel SLURM_JOB_ID
~~~



__NOTE:__  You might get a warning message from the command `conda install -c conda-forge mpi4py openmpi`
(it is ok):

~~~
## I get this output from conda:
To enable CUDA support, UCX requires the CUDA Runtime library (libcudart).                   
The library can be installed with the appropriate command below:                             
                                                                                             
* For CUDA 11, run:    conda install cudatoolkit cuda-version=11                             
* For CUDA 12, run:    conda install cuda-cudart cuda-version=12                             
                                                                                             
If any of the packages you requested use CUDA then CUDA should already                       
have been installed for you.                                                                 
                                                                                             
                                                                                             
/                                                                                            
To enable CUDA support, please follow UCX's instruction above.                               
                                                                                             
To additionally enable NCCL support, run:    conda install nccl                              
                                                                                             
                                                                                             
| 
On Linux, Open MPI is built with CUDA awareness but it is disabled by default.
To enable it, please set the environment variable
OMPI_MCA_opal_cuda_support=true
before launching your MPI processes.
Equivalently, you can set the MCA parameter in the command line:
mpiexec --mca opal_cuda_support 1 ...
Note that you might also need to set UCX_MEMTYPE_CACHE=n for CUDA awareness via
UCX. Please consult UCX documentation for further details.
~~~






#### Files (Scripts and Codes)

We need to create these files in one directory.

The sbatch slurm script for running job in batch mode is _job.01.slurm_:

~~~bash
#!/bin/bash


## Owl open MPI.

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0-0:10:00

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
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.openmpi4py.%j.out
#SBATCH --error slurm.openmpi4py.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q


## -----------------------
## Want the genoa multicore nodes on Owl.
## If on TC, comment out this line.
## But then you'd need a VE specifically
## for TC.  Our VE is specifically for 
## Owl and genoa nodes.  See below for the VE.
#SBATCH --constraint=genoa&avx512


## -----------------------
## ACCOUNT.
## The account to charge to.
## You will have your own accounts.
#SBATCH --account arcadm


## -----------------------
## MEMORY.
## The default memory is good enough here.
##SBATCH --mem=122368


## -----------------------
## MODULES.
module reset
module load Miniforge3
module load foss/2023b


## -----------------------
## VE (virtual environment).
## source activate ~/env/owl/normal_q_genoa/py312_mf_openmpi
source activate ~/env-python/owl/normal_q/genoa/py34_mf_openmpi_mpi4py



## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR


## -----------------------
## RECORD SLURM AND EXECUTION ENVIRONMENT.
echo " "
echo "slurm scontrol" 
scontrol show job --details $SLURM_JOB_ID
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo " "
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS
echo " "
echo " "

# Data collection interval in seconds.
data_collection_period_s=1
echo " " 
echo " ------------"
echo "Running IOSTAT, MPSTAT, VMSTAT"
iostat ${data_collection_period_s} >iostat.%j.out 2>iostat.%j.err &
mpstat -P ALL ${data_collection_period_s} >mpstat.%j.out 2>mpstat.%j.err &
vmstat -t ${data_collection_period_s} >vmstat.%j.out 2>vmstat.%j.err &


## -----------------------
# Code to execute.
echo " "
echo " ------------"
echo "Running executable"
echo " "
THE_EXEC="./src.01.py"
THE_INPUT=""
srun --mpi=pmix  python $THE_EXEC  $THE_INPUT


echo " ------------"
echo "Executable done:  stop IOSTAT, MPSTAT, VMSTAT"
kill %1
kill %2
kill %3
~~~


The python source code file is _src.01.py_ immediately below:

~~~python
## Obtained from:  https://mpi4py.readthedocs.io/en/4.0.3/tutorial.html

import time
from mpi4py import MPI


## ====================================
def doWork():
    """
    Do MPI work.
    """

    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()

    ## Precisely two MPI processes.
    if rank == 0:
        sleep(5)
        data = {'a': 7, 'b': 3.14}
        print("Rank : ",rank," ; action:  about to send message")
        comm.send(data, dest=1, tag=11)
        print("Rank : ",rank," ; action:  sent message")
        print("     data sent: ",data)
    elif rank == 1:
        sleep(5)
        print("Rank : ",rank," ; action:  set up to receive message.")
        data = comm.recv(source=0, tag=11)
        print("Rank : ",rank," ; action:  received message.")
        print("     message contents received: ",data)

    return


## ====================================
if __name__ == "__main__":

    beginTime = time.time()

    ## Do work.
    doWork()

    endTime = time.time()

    dt = endTime-beginTime

    print("execution time (s): ",dt)
    print("execution time (hr): ",(float)(dt)/3600.0)

    print("  ---- good termination ---")
~~~



#### Job Submission

From a head node, enter:


~~~bash
sbatch job.01.slurm
~~~

#### Job Output/Results

Results will be in the file _slurm.mpi4py.SLURM-JOB-ID.out_ file
because this is the slurm output file specified by the
`#SBATCH --output` command.

~~~output
 execution output

Rank :  1  ; action:  set up to receive message.
Rank :  1  ; action:  received message.
     message contents received:  {'a': 7, 'b': 3.14}
execution time (s):  0.028662919998168945
execution time (hr):  7.961922221713596e-06
  ---- good termination ---
Rank :  0  ; action:  about to send message
Rank :  0  ; action:  sent message
     data sent:  {'a': 7, 'b': 3.14}
execution time (s):  0.03054952621459961
execution time (hr):  8.485979504055447e-06
  ---- good termination ---
~~~


There is additional output in this file, occurring above these results,
and these primarily give the slurm job specifications.
Especially with MPI and more complicated executions than serial code,
it is useful to print these results.


### `seff` Command

To build intuition, always try to do:

~~~bash
seff SLURM_JOB_ID
~~~

after a job completes to see memory usage and cpu usage.

-------------------------

-------------------------

## Example 2

This is to run MPI on a GPU.

###  Creating a Virtual Environment on Falcon

The process for creating a VE for other clusters and compute node types 
is very similar.

This version is CUDA enabled.

This example is to run on the Falcon L40S GPU node.
Very few modifications are required to run on TC (Tinkercliffs) cluster with a GPU node.
And also, very few modifications are required to run on other partitions (i.e., types of
GPUs) on Falcon.

Just note:  when virtual environments (VEs) are involved, 
you must run your code on the type of node used to 
create the VE.
This is a universal constraint.

~~~bash
## Obtain resources from slurm.
## On the genoa nodes (because there are more of them than milan: 84 vs. 4).
salloc --account=<account>  --partition=l40s_normal_q    --nodes=1 --ntasks-per-node=1 --cpus-per-task=2 --gres=gpu:1  --time=2:00:00

## ssh to the falcon compute node XXX.
ssh falXXX

## Module reset on compute node.
module reset

## Load module for conda.
module load Miniforge3

## Load module for Open MPI.
module load foss/2023b

## Load CUDA.
module load CUDA/12.6.0

## Create the VE.
conda create -p ~/env-python/falcon/l40s_normal_q/py312_mf_openmpi_cuda

## Activate the VE.
source activate ~/env-python/falcon/l40s_normal_q/py312_mf_openmpi_cuda

## Install python.
conda install python=3.12

## Check:  should show correct version
python --version

## Install Mpi4Py, for OpenMPI
conda install -c conda-forge mpi4py openmpi

## For CUDA version 12.
conda install cuda-cudart cuda-version=12

## NCCL support.
conda install nccl


## Install numpy.  Use of numpy arrays with python faster.  Evidently.
conda install numpy

## Install cupy.  Using conda.
## See https://docs.cupy.dev/en/stable/install.html#installing-cupy-from-conda-forge
conda install -c conda-forge cupy cuda-version=12.6


## List packages.
conda list

## Install any more packages you desire.


## When you think you are done, stay in the VE and 
## start the python interpreter and import the packages
## using the statements in your code.
## This ensures that all required packages are there, and if not,
## you can add them right now.

## For this example:
python
from mpi4py import MPI
import cupy as cp
## When done with imports:
exit()



## List packages.
conda list

## Deactivate VE.
conda deactivate

## Exit off of compute node; go back to head node.
exit


## Return unused resources to slurm.
## squeue command shows the JOBID.
squeue -u $USER
scancel JOBID
~~~



__NOTE:__ After the command `conda install nccl`, you might receive a message (it is ok):

~~~
On Linux, Open MPI is built with CUDA awareness but it is disabled by default.
To enable it, please set the environment variable
OMPI_MCA_opal_cuda_support=true
before launching your MPI processes.
Equivalently, you can set the MCA parameter in the command line:
mpiexec --mca opal_cuda_support 1 ...
Note that you might also need to set UCX_MEMTYPE_CACHE=n for CUDA awareness via
UCX. Please consult UCX documentation for further details.
~~~
{:  .language-bash}



#### Files (Scripts and Codes)

We need to create these files in the same directory.

Create sbatch slurm script _job.02.slurm_ with this content:

~~~bash
#!/bin/bash


## Falcon open MPI.

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0-1:00:00

## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=l40s_normal_q

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.
## From this, the number of compute nodes is automatically calculated.

## Total number of MPI processes in the entire job.
#SBATCH --ntasks=4

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=4

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## Gpus.
#SBATCH --gres=gpu:1
#SBATCH --gres-flags=enforce-binding


## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## BE VERY, VERY CAREFUL WITH THIS.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.mpi4py.gpu.%j.out
#SBATCH --error slurm.mpi4py.gpu.%j.err


## -----------------------
## ACCOUNT.
## The account to charge to.
## You will have your own accounts.
#SBATCH --account arcadm


## -----------------------
## MEMORY.
## The default memory is good enough here.
##SBATCH --mem=122368


## -----------------------
## MODULES.
module reset
module load Miniforge3
module load foss/2023b
module load CUDA/12.6.0


## -----------------------
## VE (virtual environment).
source activate ~/env-python/falcon/l40s_normal_q/py312_mf_openmpi_cuda


## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR


## -----------------------
## RECORD SLURM AND EXECUTION ENVIRONMENT.
echo " "
echo "slurm scontrol" 
scontrol show job --details $SLURM_JOB_ID
echo " "


## -----------------------
## Monitor the GPU.
saveInterval=3
echo " "
echo " "
echo "Start file for monitoring data of GPU."
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l ${saveInterval} > log.gpu.$SLURM_JOBID.out &
echo " "
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo " "
echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS
echo " "
echo " "


## -----------------------
## JOB.
echo " "
echo " execution output"
echo " "
THE_EXEC="./src.02.py"
THE_INPUT=""
## The four here is four MPI processes, to match the four tasks above.
srun --mpi=pmix -n 4  python $THE_EXEC  $THE_INPUT
~~~



The python source code file _src.02.py_ is:

~~~python
## Obtained from:  https://mpi4py.readthedocs.io/en/4.0.3/tutorial.html

import time
from mpi4py import MPI
import cupy as cp


## ====================================
def doWork():
    """
    Do MPI work.
    Using GPUs.
    """

    comm = MPI.COMM_WORLD
    size = comm.Get_size()
    print("----------------------------")
    print("Size of the communicator: ", size)
    print("----------------------------")
    rank = comm.Get_rank()
    print("Rank : ",rank," ; action:  instantiated")

    sendbuf = cp.arange(10, dtype='i')
    recvbuf = cp.empty_like(sendbuf)
    cp.cuda.get_current_stream().synchronize()
    comm.Allreduce(sendbuf, recvbuf)

    print("Allreduce done.")
    print(" ")
    print("Rank : ",rank," ; action:  received message.")
    print("     message contents received: ",recvbuf)
    print(" ")
    assert cp.allclose(recvbuf, sendbuf*size)

    return


## ====================================
if __name__ == "__main__":

    beginTime = time.time()

    ## Do work.
    doWork()

    endTime = time.time()

    dt = endTime-beginTime

    print("execution time (s): ",dt)
    print("execution time (hr): ",(float)(dt)/3600.0)

    print("  ---- good termination ---")
~~~



#### Job Submission

Submit job to slurm via:

~~~
sbatch job.02.slurm
~~~
{:  .language-bash}

#### Job Output/Results

Results will be in the file _slurm.mpi4py.gpu.SLURM_JOB_ID.out_ file

#### `seff` Command

To build intuition, always try to do:

~~~bash
seff SLURM_JOB_ID
~~~

after a job completes to see memory usage and cpu usage.


