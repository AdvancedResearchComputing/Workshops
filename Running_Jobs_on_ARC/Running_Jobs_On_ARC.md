# Running Jobs on ARC Systems  

February 06, 2026

Nicole Braunscheidel\
Computational Scientist (ARC)\
Email: nbraunsc@vt.edu

## Logistics
Please sign in: [https://docs.google.com/document/d/1KLXoQWPeVevkeBH8WNjgtNDxAiwdcG4GLJOx9yMRvqw/edit?usp=sharing](https://docs.google.com/document/d/1KLXoQWPeVevkeBH8WNjgtNDxAiwdcG4GLJOx9yMRvqw/edit?usp=sharing)

Feedback form: [https://forms.gle/BCQ4SfdiE3KhQ6sM8](https://forms.gle/BCQ4SfdiE3KhQ6sM8)

General Comments:
- Informal workshop so please feel free to interrupt me or use the chat for questions!
- This PDF is uploaded in Files on the Canvas site
- There will be no recording of this workshop but we have a lot of short video tutorials: [https://docs.arc.vt.edu/usage/video.html#video](https://docs.arc.vt.edu/usage/video.html#video)
- If you want to follow along, make sure you are connected to VT network (VPN if off campus) and have an ARC account

Useful links:
- ARC's documentation site: [https://docs.arc.vt.edu/](https://docs.arc.vt.edu/)
- GitHub Examples: [https://github.com/AdvancedResearchComputing/examples](https://github.com/AdvancedResearchComputing/examples)
- Office Hours: [https://arc.vt.edu/about/office-hours.html](https://arc.vt.edu/about/office-hours.html)
- 4Help: [https://arc.vt.edu/help](https://arc.vt.edu/help)
- Job scheduling and monitoring: [https://docs.arc.vt.edu/usage/job_scheduling.html](https://docs.arc.vt.edu/usage/job_scheduling.html)

## Outline of this Workshop
1. [Batch Jobs](#batch-jobs)
2. [Interactive Jobs](#interactive-jobs)
3. [Billing](#billing)
4. [Software Modules](#software-modules)
5. [Submitting Jobs through Open OnDemand](#submitting-jobs-through-open-ondemand-ood)

If you want to follow along, make sure you are connected to eduroam or the Cisco VPN and that you have an ARC account.

### Connect to ARC through a remote-ssh connection 

There are 3 different ways to connect:
1. Open a terminal in Open OnDemand [https://ood.arc.vt.edu/](https://ood.arc.vt.edu/). This will already have you connected to ARC. Easiest option if you have never created an ssh connection before. 

2. In terminal, type `ssh PID@tinkercliffs1.arc.vt.edu` or `ssh PID@owl2.arc.vt.edu`, then PID password, then DUO push.
Video tutorial for login: [https://docs.arc.vt.edu/usage/video.html#login](https://docs.arc.vt.edu/usage/video.html#login)

3. In VS Code, create an new ssh connection or connect to an existing remote host. [https://docs.arc.vt.edu/usage/vscode_remote_ssh.html#connect-vs-code-to-the-login-node](https://docs.arc.vt.edu/usage/vscode_remote_ssh.html#connect-vs-code-to-the-login-node) or video tutorial called "Connect to ARC systems with VS code" [https://docs.arc.vt.edu/usage/video.html#connecting-to-arc-clusters](https://docs.arc.vt.edu/usage/video.html#connecting-to-arc-clusters).

# Batch Jobs
Batch jobs are the preferred method to running jobs on ARC systems as they maximize utlization of the computer resources and don't require waiting on user input during the calculation. For batch jobs, you will need a batch script that usually has an extension `.sh` or `.slurm`.

The batch script contains the information to tell Slurm (our cluster scheduler) what resources are needed, for how long they are needed, and what job to run. 

To submit a batch job, use the `sbatch` command followed by the name of the batch file `hello_world.slurm`:
```
nbraunsc@tinkercliffs1:~ sbatch hello_world.slurm
```

## Job configuration options
An example batch script named `hello_world.slurm`:
```
#!/bin/bash
#SBATCH --job-name=hello-world
#SBATCH --account=<youraccountname>
#SBATCH --partition=normal_q
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1 
#SBATCH --time=0-00:10:00 # 10 minutes
#SBATCH --mem=5GB
#SBATCH --gres=gpu:1
```

Other optional configurations
```
#SBATCH --qos=tc_normal_base
#SBATCH --constraint=amd
#SBATCH --mail-user=nbraunsc@vt.edu
#SBATCH --mail-type=START,END,FAIL
```
If you forget what the syntax is or what each of these stand for, you can run the command `sbatch --help` or `man sbatch` to see all the available options. 
```
nbraunsc@tinkercliffs1:~ sbatch --help
Usage: sbatch [OPTIONS(0)...] [ : [OPTIONS(N)...]] script(0) [args(0)...]

Parallel run options:
  -a, --array=indexes         job array index values
  -A, --account=name          charge job to specified account
      --bb=<spec>             burst buffer specifications
      --bbf=<file_name>       burst buffer specification file
  -b, --begin=time            defer job until HH:MM MM/DD/YY
      --comment=name          arbitrary comment
      --cpu-freq=min[-max[:gov]] requested cpu frequency (and governor)
  -c, --cpus-per-task=ncpus   number of cpus required per task
  -d, --dependency=type:jobid[:time] defer job until condition on jobid is satisfied
      --deadline=time         remove the job if no ending possible before
                              this deadline (start > (deadline - time[-min]))
      --delay-boot=mins       delay boot for desired node features
  -D, --chdir=directory       set working directory for batch script
  -e, --error=err             file for batch script's standard error
      --export[=names]        specify environment variables to export
      --export-file=file|fd   specify environment variables file or file
                              descriptor to export
      --get-user-env          load environment from local cluster
      --gid=group_id          group ID to run job as (user root only)
      --gres=list             required generic resources
      --gres-flags=opts       flags related to GRES management
  -H, --hold                  submit job in held state
      --ignore-pbs            Ignore #PBS and #BSUB options in the batch script
...
...
...
```

### Quality of Service (QoS)
ARC must balance the needs of individuals with the needs of all to ensure fairness so we implemented QoS options. 

The QoS associated with a job affects the job in three key ways: scheduling priority, resource limits, and time limits. Each partition has a default QoS named partitionname_base with a default priority, resource limits, and time limits. 

To see the defaults, use the command `showqos`.

## Run an example job and see it in the queue

```
#!/bin/bash
#SBATCH --job-name=hello-world
#SBATCH --account=<youraccountname>
#SBATCH --partition=normal_q 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1 
#SBATCH --time=0-00:10:00 # 10 minutes
#SBATCH --mem=10MB
#SBATCH --qos=tc_normal_base
#SBATCH --constraint=amd

wait 10
echo "hello world from..."; hostname
echo “Working directory is: ”; pwd
```

Submit this job to the queue using `sbatch`:
```
nbraunsc@tinkercliffs1:~$ sbatch hello_world.slurm
Submitted batch job 4479249
```

Take a look at the queue to see the job using `squeue`:
```
nbraunsc@tinkercliffs1:~$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           4479249  normal_q hello-wo nbraunsc  R       0:00      1 tc076
```
Output is stored by default in `slurm-JOBID.out`. So for this example, the output is in `slurm-4479249.out`.

If you need to cancel a job, do so using `scancel`:
```
nbraunsc@tinkercliffs1:~$ scancel 4479249
```
You can cancel all your jobs by running the command `scancel -u $USER`.

# Interactive Jobs

### `interact`
You run the `interact` command to request and obtain compute resources.
```
interact --nodes=1 --account=arcadm --ntasks=1 --partition=normal_q --cpus-per-task=1 --time=10:00
```
```
nbraunsc@owl1:~$ interact --nodes=1 --account=arcadm --ntasks=1 --partition=normal_q --cpus-per-task=1 --time=10:00
 --- Warning:
     Your session consumes resources (CPUs, memory, and GPUs) while it remains open.
     Close your session whenever you finish your work.
     Other users cannot use the resources allocated to your job until you close your session.
     Consider the use of batch jobs to optimize resources allocation.
srun: job 293155 queued and waiting for resources
srun: job 293155 has been allocated resources
nbraunsc@owl075:~$
```

### `salloc` + `srun`

You first run the `salloc` command to request and obtain compute resources.
```
salloc --nodes=1 --account=arcadm --ntasks=1 --partition=normal_q --cpus-per-task=1 --time=10:00
```

```
nbraunsc@tinkercliffs1:~$ salloc --nodes=1 --account=arcadm --ntasks=1 --partition=normal_q --cpus-per-task=1 --time=10:00
salloc: Pending job allocation 4479028
salloc: job 4479028 queued and waiting for resources
salloc: job 4479028 has been allocated resources
salloc: Granted job allocation 4479028
salloc: Waiting for resource configuration
salloc: Nodes tc257 are ready for job
```

Then, run your calculation using `srun`. This is a simple example to get the hostname of the compute node you were allocated:
```
nbraunsc@tinkercliffs1:~$ srun hostname
tc257
```

For anything non-trivial like loading modules or using a virtual environment, use `srun` followed by the bash script that contains the information to run the calculation.

An example bash script named `testing.sh`:
```
#!/bin/bash
hostname

module reset
module load Miniconda3/25.11.1-1
module list

source activate flare
which python
```
```
nbraunsc@tinkercliffs1:~$ ll 
-rw-rw----  1 nbraunsc nbraunsc    108 Feb  2 12:44 testing.sh
```
Change the permissions to make the script executable by `srun` using `chmod +x testing.sh`.
```
nbraunsc@tinkercliffs1:~$ ll 
-rwxrwx---  1 nbraunsc nbraunsc    108 Feb  2 12:44 testing.sh*
```
Then run script on the compute node that you were allocated using `srun`:
```
nbraunsc@tinkercliffs1:~$ srun testing.sh
tc257
Resetting modules to system default. Reseting $MODULEPATH back to system default. All extra directories will be removed from $MODULEPATH.

Currently Loaded Modules:
  1) shared                3) apps             5) DefaultModules
  2) slurm/slurm/24.05.4   4) useful_scripts   6) Miniconda3/25.11.1-1

/home/nbraunsc/.conda/envs/flare/bin/python
```
This is a great way to do batch script development or get immediate results, but once your bash script becomes long, then you should move to submitting a batch job.

# Billing
Each PI gets 2,000,000 units/month per cluster in the free tier category of allocations.
We have more information on our documentation site: [https://docs.arc.vt.edu/usage/job_scheduling/01_slurm_overview.html#accounting](https://docs.arc.vt.edu/usage/job_scheduling/01_slurm_overview.html#accounting)

We have a billing calculator if you are curious how much your job will cost in compute hours: [https://coldfront.arc.vt.edu/billing-calculator](https://coldfront.arc.vt.edu/billing-calculator).

You can see how much you have used with the following commands:

`getusage --account <slurm_account_name>` Shows compute hours used per account per cluster

`getusage --pi <VT_PI_pid>` Shows compute hours used per PI per cluster

`getusage --user <VT_pid>` Shows compute hours used per user per cluster

# Software Modules

ARC clusters use a module system mostly built around EasyBuild, a software build and installation framework that allows you to manage (scientific) software on High Performance Computing (HPC) systems in an efficient way.

We have documentation about modules here: [https://docs.arc.vt.edu/usage/modules.html](https://docs.arc.vt.edu/usage/modules.html).

Modules get loaded in the slurm batch script or once you are in an interactive job. We have a list of which software and versions that we currently have installed on the clusters here: [https://docs.arc.vt.edu/usage/modules.html](https://docs.arc.vt.edu/software/01table.html). 

If you want to see the software from the command line/terminal, you can use the command `module spider PACKAGE`:
```
nbraunsc@tinkercliffs1:~$ module spider R

-------------------------------------------------------------------------------------
  R:
-------------------------------------------------------------------------------------
    Description:
      R is a free software environment for statistical computing and graphics.

     Versions:
        R/4.3.2-gfbf-2023a
        R/4.4.2-gfbf-2024a
        R/4.5.2-gfbf-2025b
     Other possible modules matches:
        3DSlicer  AMD-uProf  ANSYS-ELECTRONICS  ANTLR  APR  APR-util  Amber  ...

-------------------------------------------------------------------------------------
  To find other possible module matches execute:

      $ module -r spider '.*R.*'

-------------------------------------------------------------------------------------
  For detailed information about a specific "R" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider R/4.5.2-gfbf-2025b
-------------------------------------------------------------------------------------

```

You can use the command `module list` to see what modules are currently loaded:
```
nbraunsc@tinkercliffs1:~$ module list

Currently Loaded Modules:
  1) shared   2) slurm/slurm/24.05.4   3) apps   4) useful_scripts   5) DefaultModules
  ```

Use command `module load <PACKAGE>` to activate or load the package. The package `foss` for example:
`foss` (“Free Open Source Software”): GCC compilers, OpenBLAS for linear algebra, OpenMPI for MPI, etc.

```
nbraunsc@tinkercliffs1:~$ module load foss/2025b
```
Check the modules that are loaded:
```
nbraunsc@tinkercliffs1:~$ module list

Currently Loaded Modules:
  1) shared                              16) libevent/2.1.12-GCCcore-14.3.0
  2) slurm/slurm/24.05.4                 17) UCX/1.19.0-GCCcore-14.3.0
  3) apps                                18) libfabric/2.1.0-GCCcore-14.3.0
  4) useful_scripts                      19) PMIx/5.0.8-GCCcore-14.3.0
  5) DefaultModules                      20) PRRTE/3.0.11-GCCcore-14.3.0
  6) GCCcore/14.3.0                      21) UCC/1.4.4-GCCcore-14.3.0
  7) zlib/1.3.1-GCCcore-14.3.0           22) OpenMPI/5.0.8-GCC-14.3.0
  8) binutils/2.44-GCCcore-14.3.0        23) OpenBLAS/0.3.30-GCC-14.3.0
  9) GCC/14.3.0                          24) FlexiBLAS/3.4.5-GCC-14.3.0
 10) numactl/2.0.19-GCCcore-14.3.0       25) FFTW/3.3.10-GCC-14.3.0
 11) XZ/5.8.1-GCCcore-14.3.0             26) gompi/2025b
 12) libxml2/2.14.3-GCCcore-14.3.0       27) FFTW.MPI/3.3.10-gompi-2025b
 13) libpciaccess/0.18.1-GCCcore-14.3.0  28) ScaLAPACK/2.2.2-gompi-2025b-fb
 14) hwloc/2.12.1-GCCcore-14.3.0         29) foss/2025b
 15) OpenSSL/3
  ```
If you try to load other modules, make sure that package and it's dependencies are compatable.
To see what a packages dependencies are use the command `module show <PACKAGE>`
```
nbraunsc@tinkercliffs1:~$ module show R/4.4.2-gfbf-2024a
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /apps/arch/modules/all/R/4.4.2-gfbf-2024a.lua:
...
...
depends_on("gfbf/2024a")
depends_on("X11/20240607-GCCcore-13.3.0")
depends_on("Mesa/24.1.3-GCCcore-13.3.0")
depends_on("libGLU/9.0.3-GCCcore-13.3.0")
depends_on("cairo/1.18.0-GCCcore-13.3.0")
depends_on("libreadline/8.2-GCCcore-13.3.0")
depends_on("ncurses/6.5-GCCcore-13.3.0")
depends_on("bzip2/1.0.8-GCCcore-13.3.0")
depends_on("XZ/5.4.5-GCCcore-13.3.0")
depends_on("zlib/1.3.1-GCCcore-13.3.0")
depends_on("SQLite/3.45.3-GCCcore-13.3.0")
depends_on("PCRE2/10.43-GCCcore-13.3.0")
depends_on("libpng/1.6.43-GCCcore-13.3.0")
depends_on("libjpeg-turbo/3.0.1-GCCcore-13.3.0")
depends_on("LibTIFF/4.6.0-GCCcore-13.3.0")
depends_on("Java/17")
depends_on("libgit2/1.8.1-GCCcore-13.3.0")
depends_on("OpenSSL/3")
depends_on("cURL/8.7.1-GCCcore-13.3.0")
depends_on("Tk/8.6.14-GCCcore-13.3.0")
depends_on("HarfBuzz/9.0.0-GCCcore-13.3.0")
depends_on("FriBidi/1.0.15-GCCcore-13.3.0")
...
```

And if you try to load a package that has different versions of software, you will see a message like the following:
```
nbraunsc@tinkercliffs1:~$ module load R/4.4.2-gfbf-2024a
Setting R_LIBS_USER to: /home/nbraunsc/R/tinkercliffs-rome/4.4.2

The following have been reloaded with a version change:
  1) FFTW/3.3.10-GCC-14.3.0 => FFTW/3.3.10-GCC-13.3.0
  2) FlexiBLAS/3.4.5-GCC-14.3.0 => FlexiBLAS/3.4.4-GCC-13.3.0
  3) GCC/14.3.0 => GCC/13.3.0
  4) GCCcore/14.3.0 => GCCcore/13.3.0
  5) OpenBLAS/0.3.30-GCC-14.3.0 => OpenBLAS/0.3.27-GCC-13.3.0
  6) XZ/5.8.1-GCCcore-14.3.0 => XZ/5.4.5-GCCcore-13.3.0
  7) binutils/2.44-GCCcore-14.3.0 => binutils/2.42-GCCcore-13.3.0
  8) libpciaccess/0.18.1-GCCcore-14.3.0 => libpciaccess/0.18.1-GCCcore-13.3.0
  9) libxml2/2.14.3-GCCcore-14.3.0 => libxml2/2.12.7-GCCcore-13.3.0
 10) zlib/1.3.1-GCCcore-14.3.0 => zlib/1.3.1-GCCcore-13.3.0
  ```
This is not good! DO NOT continue to run your code as many things could be broken due to mismatched versions.
 

# Submitting Jobs through Open OnDemand (OOD)

More information about this in the April 17th workshop "Hands-On HPC Access and Application with Open OnDemand". 

Make sure you cancel your job when you are done! If you just close the browser it will not stop your job. Also, make sure that if you submit an OOD job, that you are actively using the resources and not leaving them idle. When we see idle jobs we consider that wasting resources and try to minimize this on the clusters as much as possible. 