# Inspections, Interfacing, and Interactions with GPUs

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
