# Parallelization and Optimization with GPUs

## General Recommendations
### Release resources when you're finished

### Keep the GPUs busy
GPUs are useful to accelerate workloads, but they do not help at all with serial portions of the code or i/o.
> [!TIP]
> Amdahl's Law: "the overall performance improvement gained by optimizing a single part of a system is limited by the fraction of time that the improved part is actually used"

#### Use large chunk sizes
Because of their massive internal SIMD parallelism, GPUs are only efficient when they are asked to perform the same operation on large sets of data. In some applications, the data handling is controlled internally, but if you are in a situation where you can tune "batch size", "chunk size", etc., tend to make these large to leverage the SIMD efficiency.

#### Use `TMPDIR` for data-intensive workloads
If your workload with either read from or write to a large dataset, then it's highly recommended to use `TMPDIR` (`/localscratch`) on compute nodes to minimize the i/o bottleneck

```bash
#!/bin/bash
# prototype usage of TMPDIR in a batch script
# -----------------------------------------
#SBATCH ...
#SBATCH ...

echo "Copying data from /scratch to TMPDIR=$TMPDIR/input"
cp /scratch/user/data.tar $TMPDIR/input
cd $TMPDIR/input
tar -xf data.tar

echo "Setting output directory to $TMPDIR/output"
OUTDIR=$TMPDIR/output

myprog -i $TMPDIR/input -o $TMPDIR/output

echo "myprog execution completed.. packaging output data"
cd $TMPDIR
tar -cf ${SLURM_JOB_ID}_output.tar output

echo "${SLURM_JOB_ID}_output.tar created, copying to /scratch"
cp ${SLURM_JOB_ID}_output.tar /scratch/user/
```

> [!NOTE]
> If you work with LLMs, we may already have the models you need available on the clusters. Check in `/common/data/models`

### One GPU per process
In the classical HPC paradigm with MPI, you would launch many MPI processes for a job and they would divide the work. The most common starting point was "one rank per core" or equivalently "one CPU per process" and try to run all CPUs at 100%. These programs were "CPU-bound".

There is a paradigm shift when adjusting to MPI+GPU simulations. The goal is to prioritize keeping the GPU busy and running efficiently, but it takes extremely careful planning to effectively have multiple processes share a single GPU. Think of GPUs as arithmetic factories where the machines have to be switched out to serve the requests of different processes. 
> [!WARNING] 
> During context switches, GPUs are not producing.

Because of this, the general best practice is to use 1 GPU per MPI process. 
Ref: [LAMMPS](https://docs.lammps.org/Speed_kokkos.html#running-on-gpus), [VASP](https://www.vasp.at/wiki/index.php/OpenACC_GPU_port_of_VASP#Running_the_OpenACC_version), [Amber](https://ambermd.org/GPUHowTo.php)


## Outline
0. [Welcome](./0-intro.md)
1. [ARC Cluster GPU Offerings and Comparisons](./1-arc_gpus.md)
2. [Inspection and Interfacing with GPUs](./2-Interactions.md)
3. Break
3. [Programming with GPUs](./3-Programming.md)
4. [Parallelization with GPUs](./4-Parallelization.md)