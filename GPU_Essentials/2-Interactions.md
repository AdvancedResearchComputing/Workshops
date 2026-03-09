# Inspections, Interfacing, and Interactions with GPUs

## Requesting GPUs

### Slurm 

|Option | Meaning | Use Case |
|-|-|-|
`--gres=gpu:N`|Request `N` GPUs on each allocated node|resources balanced between 1 or more nodes|
|`--gpus-per-node=N`|Request `N` GPUs on each allocated node|resources balanced between 1 or more nodes|
|`-G N` or `--gpus=N`|Request `N` GPUs for the job, possibly distributed across multiple nodes|multi-gpu, multi-process, non-communicating workload|


Example: Use `--gres=gpu:N` to requent `N` GPUs per node.
```bash
#SBATCH --nodes=1
#SBATCH --gres=gpu:1        # GPUs per node
#SBATCH --cpus-per-task=4   # A least 1 CPU
#SBATCH --mem=12G           # Memory per-node
```
> [!HINT]
> When starting out with GPUs, first make sure that you can make good use of a single, mid-range GPU before scaling up to high-end or multiple GPUs.

## `nvidia-smi`

```bash
nvidia-smi
```

```bash
nvidia-smi topo -m
```

```bash
nvidia-smi --help-query-gpu | more
```

```bash
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,temperature.gpu,utilization.gpu,utilization.memory,memory.used --format=csv -lms 1000
```


### Logging in a batch script
ARC provides a wrapper script for logging GPU utilization within a job script. To use it in a batch script,  
1. it needs to log to a file (output redirection via "`>`", and 
2. the script must proceed without waiting for the command to end (run in the background via "`&`"):

```bash
gpumon > ${SLURM_JOB_ID}.gpu.log &
```

## `showjobusage <jobid>`
```bash
[brownm12@fal003 gpuessentials]$ showjobusage $SLURM_JOB_ID
JOBID:     249839
JOBNAME:   bash
USER:      brownm12
ACCOUNT:   arcadm
JOBSTATE:  RUNNING
RUNTIME:   02:19:12
TIMELIMIT: 07:00:00
NODES:     1
CPUS:      64
MEM (MB):  506880
GPUS:      4

NODE                  CPUS   MEM (MB)  GPUS GPU IDX (SLURM)
-------------------- -----  --------- ----- ---------------
fal003                  64     506880     4         0,1,2,3

        PID     CPU   MEM (MB)  GPU IDX CMD
    -------  ------  ---------  ------- --------------------------------
    3814607     0.0       7.52          /usr/bin/bash
    3816644     0.0       5.44          -bash
    3816730     0.0     398.53          /apps/common/software/matlab/R2025b/bin/glnxa64/MATLAB -nodisplay
    3816804     0.0      30.97          /apps/common/software/matlab/R2025b/bin/glnxa64/MathWorksCrashReporter --no-rate-limit --monitor-exp
    3816807     0.0      43.09          /apps/common/software/matlab/R2025b/sys/Xvfb/glnxa64/bin/Xvfb :49361 -screen 0 3840x2160x24 -audit 4
    3816808     0.0      10.02          /apps/common/software/matlab/R2025b/sys/fluxbox/glnxa64/bin/fluxbox -screen 0 -display :49361
    3816827     0.0     223.06          /apps/common/software/MathWorksServiceHost/2025.12.0.2/bin/glnxa64/MathWorksServiceHost service --re
    3816955     100    6345.12        0 /apps/common/software/matlab/R2025b/bin/glnxa64/MATLAB -mpasessionid=4b5a4047-dcdb-4375-9e8f-1d875f6
    3817070     0.0      63.50          /apps/common/software/MathWorksServiceHost/2025.12.0.2/bin/glnxa64/MathWorksServiceHost-Monitor --cl
    3819932     0.0     152.36          /apps/common/software/MathWorksServiceHost/2025.12.0.2/bin/glnxa64/MathWorksServiceHost client-v1 --
    3820395     0.0       3.55          /apps/common/software/matlab/R2025b/bin/glnxa64/matlab_helper /dev/pts/2 no
    3830344     0.0       4.01          bash /apps/common/useful_scripts/showjobusage 249839
    3830426     0.0       2.31          bash /apps/common/useful_scripts/showjobusage 249839

         CPU UTIL  CPU UTIL (%)     MEM UTIL (MB)  MEM UTIL (%)
    -------------  ------------  ----------------  ------------
       100 / 6400         1.56%     7186 / 506880         1.42%


    GPU    MEM UTIL (MB)  MEM UTIL (%)  GPU UTIL (%)
    ---  ---------------  ------------  ------------
      0     235 /  24576         0.00%            0%

    WARNING: 64 CPU(s) allocated but utilization is low (1.56%)
    WARNING: 506880 MB allocated but utilization is low (1.42%)
    WARNING: GPU IDX 1 (per nvidia-smi) allocated but there are no processes using the GPU
    WARNING: GPU IDX 2 (per nvidia-smi) allocated but there are no processes using the GPU
    WARNING: GPU IDX 3 (per nvidia-smi) allocated but there are no processes using the GPU
    WARNING: GPU IDX 0 (per nvidia-smi) low utilization (0%)
```

#### Dashboard metrics and history

ARC's [dashboard](https://dashboard.arc.vt.edu) site collects cluster and node information and is able to display current and historical usage information. ARC provides a convenience script "`getjobutilurl <jobid>`" which will provide customized URLs that take you to the dashboard pages that are:
 - specific to the nodes allocated to the job
 - specific to the time range when the job was running.
> [!NOTE]
> These dashboard pages show node-level utilization information. If multiple jobs were running on the same node, the displayed usage is the aggregate for all the jobs.
