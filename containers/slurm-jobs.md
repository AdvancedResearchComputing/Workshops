# Running a Batch Job With a Container Using an Sbatch Slurm Script


##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. All examples so far have run fast and so we have
   run interactive jobs on compute nodes.
2. Generally, you do not want to run codes in containers
   via interactive jobs.
   You want to use **batch jobs**.
3. Illustrate how to incorporate a container 
   into an sbatch slurm script and run it.

## Sbatch Slurm Script

Composing and submitting a slurm job script, with container code execution,
is straight-forward.

Here, we compose one job, but we run multiple codes, just to 
demonstrate that you can do this.
With `apps` this is quite common.

Also note that in addition to the two specified containers,
my_apps.sif and python.ve.container.03.sif, you need this file:
`/scratch/ckuhlman/main.02.py`

All three of these files were built in previous lessons, so they should
be available.
You will have to change the paths to them in accordance with where
they reside for you.

For definiteness below, call this file _sbatch.container.slurm_.

```
#!/bin/bash
#SBATCH --job-name=apptainer_job
## You need your own account.
#SBATCH --account=arcadm
#SBATCH --partition=normal_q
#SBATCH --output=result_%j.out
#SBATCH --error=error_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#### #SBATCH --mem=8G
#SBATCH --time=00:10:00

# Write to the output file the hardward used and other 
# aspects of the job.
echo " " 
echo " Job Specifics"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " "


# 1. Load the Apptainer module.
module reset
module load apptainer

# 2. Run your command inside the container; we have three commands on two containers.

# Two variables that specify the directories where the two containers reside.

# The contain with multiple apps.
dir_my_apps=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/simple-multi-app/try01

# The container with the virtual environment.
dir_my_ve=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/python-env/try03

echo " " 
echo " run app foo within container my_apps."
echo " (this comes from the lesson on building containers with apps.)"
apptainer run --app foo ${dir_my_apps}/my_apps.sif

echo " " 
echo " run app bar within container my_apps."
echo " (this comes from the lesson on building containers with apps.)"
apptainer run --app bar ${dir_my_apps}/my_apps.sif


echo " "
echo " run an app that is outside of a container, using bind"
echo " where the container has a virtual environment inside of it."
echo " (this comes from the lesson on building containers with virtual environments.)"
apptainer exec --bind /scratch/ckuhlman  ${dir_my_ve}/python.ve.container.03.sif python /scratch/ckuhlman/main.02.py

echo " "
echo " end "

```


#### Submit the Job

As normal, we submit the job using `sbatch`.


```
sbatch sbatch.container.slurm
```

#### Job Output

Per the other lessons, the output in the _results_SLURM_JOB_ID.out_ file is:


```
 Job Specifics
 
JobId=458698 JobName=apptainer_job
   UserId=ckuhlman(1344122) GroupId=ckuhlman(1344122) MCS_label=N/A
   Priority=1258 Nice=0 Account=arcadm QOS=owl_normal_base
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   DerivedExitCode=0:0
   RunTime=00:00:01 TimeLimit=00:10:00 TimeMin=N/A
   SubmitTime=2026-04-16T09:31:05 EligibleTime=2026-04-16T09:31:05
   AccrueTime=2026-04-16T09:31:06
   StartTime=2026-04-16T09:31:17 EndTime=2026-04-16T09:41:17 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2026-04-16T09:31:17 Scheduler=Backfill
   Partition=normal_q AllocNode:Sid=owl1:3238896
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=owl065
   BatchHost=owl065
   NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=1,mem=7928M,node=1,billing=2
   AllocTRES=cpu=1,mem=7928M,node=1,billing=2
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   JOB_GRES=(null)
     Nodes=owl065 CPU_IDs=46 Mem=7928 GRES=
   MinCPUsNode=1 MinMemoryCPU=7928M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/slurm-job/try01/sbatch.container.slurm
   WorkDir=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/slurm-job/try01
   StdErr=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/slurm-job/try01/error_458698.err
   StdIn=/dev/null
   StdOut=/projects/kuhlman-project-storage/workshops/y2026/spring-2026/containers-apptainer/slurm-job/try01/result_458698.out
   TresPerTask=cpu=1





 run app foo within container my_apps.
 (this comes from the lesson on building containers with apps.)
Running App Foo
 _________________________________________
/ Write yourself a threatening letter and \
\ pen a defiant reply.                    /
 -----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

 run app bar within container my_apps.
 (this comes from the lesson on building containers with apps.)
Running App Bar
72

 run an app that is outside of a container, using bind
 where the container has a virtual environment inside of it.
 (this comes from the lesson on building containers with virtual environments.)
  c :  5

 end
```

Note that about all of the information will be different for your job.
- The `foo` app gives a different clever saying each run.
- The `bar` app counts the number of files, directories, and symbolic links in
  YOUR home directory (i.e., $HOME = /home/<your_user_name>).
    - But you can verify this number:
      - Go to your $HOME directory, i.e., `cd $HOME`
      - Type `ls | wc -l` and the number you get should be the
        same as the second output above.
- The third code (and output) will always give you a five. 
