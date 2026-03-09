# Programming with GPUs

## Built-in

Some applications have built-in capabilities for using GPUs as accelerators. For example, this script compares the performance of a basic matrix-matrix multiplication on CPU vs. on GPU using Matlab:

### Matlab
```matlab
gpuDevice(1)
for ii=1:10
    N=10000;
    %prec="single";
    prec="double";
    A=rand(N,prec); 
    B=rand(N,prec); 
    C=ones(N,prec); 
    tic; C=A*B; cpumult=toc;
    %tic; [U,S,V] = svd(C); cpusvd=toc;

    a=gpuArray(A); 
    b=gpuArray(B); 
    c=gpuArray(C); 
    tic; c=a*b; gpumult=toc;
    %tic; [u,s,v] = svd(c); gpusvd=toc;

    fprintf("speedup mult: %f \n",cpumult/gpumult)
    %fprintf("speedup svd: %f \n",cpusvd/gpusvd)
end

```

### Computational Chemistry and Molecular Dynamics
Many of the calculations in these fields have matrix multiplications at their core and were early adopters of GPU accelerators. ARC provides installations which are built with GPU capabilities:

> [!NOTE]
> Get an interactive job on a compute node to inspect the modules available there. Especially for GPU-enabled software, the modules may be different from those on the login nodes. `interact --account=<slurm account> --partition=<gpu partition> --gres=gpu:1`

#### Amber
"Amber (originally Assisted Model Building with Energy Refinement) is software for performing molecular dynamics and structure prediction."
```
Amber/24.0-foss-2023b-AmberTools-24.0-CUDA-12.4.0
```

#### Gromacs
"GROMACS is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations of motion for systems with hundreds to millions of particles. This is a GPU enabled build, containing both MPI and threadMPI binaries. It also contains the gmxapi extension for the single precision MPI build."
```
GROMACS/2024.4-foss-2023b-CUDA-12.6.0-PLUMED-2.9.2
GROMACS/2024.4-foss-2023b-CUDA-12.6.0
```

#### LAMMPS
"LAMMPS is a classical molecular dynamics code, and an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator. LAMMPS has potentials for solid-state materials (metals, semiconductors) and soft matter (biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be used to model atoms or, more generically, as a parallel particle simulator at the atomic, meso, or continuum scale. LAMMPS runs on single processors or in parallel using message-passing techniques and a spatial-decomposition of the simulation domain. The code is designed to be easy to modify or extend with new functionality."
```
LAMMPS/22Jul2025-foss-2024a-kokkos-CUDA-12.6.0
LAMMPS/28Oct2024-foss-2023a-kokkos-mace-CUDA-12.1.1
LAMMPS/29Aug2024_update2-foss-2024a-kokkos-CUDA-12.6.0
LAMMPS/29Aug2024-foss-2023b-kokkos-CUDA-12.6.0
```
Use the command `lmp -h` after loading the module to inspect the list of invididual "style options" included in the installation. 
> [!NOTE]
> Styles with `kk` suffixes indicate they were built with Kokkos and should be able to use GPU accelerators.

#### Quantum Espresso
"Quantum ESPRESSO is an integrated suite of Open-Source computer codes for electronic-structure calculations and materials modeling at the nanoscale. This build uses the NVHPC compiler suite with GPU acceleration via CUDA."
```
QuantumESPRESSO/7.4.1-NVHPC-24.9-CUDA-12.6.0
```

#### Vienna Ab initio Simulation Package
"VASP is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.
```
VASP/5.4.4-CUDA-12.6.0
VASP/6.4.2-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0
VASP/6.5.1-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0
```
> [!NOTE]
> VASP sells licenses only at the research-group level, so there are no "VT-wide" licenses for this package and access is restricted. If you have purchased a license, let us know and we can enable access to the software.

### Libraries

#### "Fastest Fourier Transform in the West"
"FFTW is a C subroutine library for computing the discrete Fourier transform (DFT) in one or more dimensions, of arbitrary input size, and of both real and complex data."
```
FFTW/3.3.10-NVHPC-24.9-CUDA-12.6.0
```

"The MAGMA project aims to develop a dense linear algebra library similar to LAPACK but for heterogeneous/hybrid architectures, starting with current Multicore+GPU systems."
```
magma/2.7.2-foss-2023a-CUDA-12.1.1
```

## Using CUDA libraries
```
CUDA/12.1.1
CUDA/12.4.0
CUDA/12.6.0
CUDA/12.8.0
CUDA/13.0.2
```
> [!NOTE]
> Over time, Nvidia will drop support for older GPU architectures from their software. For example, CUDA versions 13+ do not support V100 GPUs (compute capability 7.0).

### Nvidia SDK for HPC
```
NVHPC/24.9-CUDA-12.6.0
NVHPC/24.11-CUDA-12.6.0
NVHPC/25.1-CUDA-12.6.0
```

### Example: C program
[Example 2](./ex2-large.c) from Nvidia's [docs on cuBLAS](https://docs.nvidia.com/cuda/cublas/#example-code) "_shows an application written in C using the cuBLAS library API._"

Attempt to compile using NVHPC
```bash
module load NVHPC
nvcc ex2-large.c -o ex2-large-a30
```

The "`ld: undefined reference to ...`" errors indicate that the linker couldn't find necessary libraries. Inspect the environment and adapt:

```bash
$ which nvcc
/apps/arch/software/NVHPC/25.1-CUDA-12.6.0/Linux_x86_64/25.1/compilers/bin/nvcc
$ echo $LD_LIBRARY_PATH
/apps/arch/software/NVHPC/25.1-CUDA-12.6.0/Linux_x86_64/25.1/compilers/lib:/apps/common/software/CUDA/12.6.0/nvvm/lib64:/apps/common/software/CUDA/12.6.0/extras/CUPTI/lib64:/apps/common/software/CUDA/12.6.0/targets/x86_64-linux/lib:/apps/arch/software/numactl/2.0.18-GCCcore-13.3.0/lib:/apps/arch/software/binutils/2.42-GCCcore-13.3.0/lib:/apps/arch/software/zlib/1.3.1-GCCcore-13.3.0/lib:/apps/arch/software/GCCcore/13.3.0/lib64:/cm/shared/apps/slurm/current/lib64/slurm:/cm/shared/apps/slurm/current/lib64
```

Instruct the linker to use the cublas library:
```bash
nvcc ex2-large.c -o ex2-large-a30 -lcublas
```

### Nvidia Collective Communications Library
Analogous to the "Message Passing Interface" (MPI), NCCL is an Nvidia-centric library for inter-process communication with the processes are running on GPUs. 

Arxive: "[Demystifying NCCL](https://arxiv.org/html/2507.04786v1)":

"_Unlike general-purpose message-passing frameworks, such as MPI [3], NCCL specifically targets GPU-to-GPU interactions, utilizing interconnect technologies such as NVLink, PCIe, and InfiniBand (IB) to achieve high bandwidth and low latency._"
```
NCCL/2.18.3-GCCcore-12.3.0-CUDA-12.1.1
NCCL/2.20.5-GCCcore-13.2.0-CUDA-12.4.0
NCCL/2.20.5-GCCcore-13.2.0-CUDA-12.6.0
NCCL/2.22.3-GCCcore-13.3.0-CUDA-12.6.0
```

### Nvidia CUDA Deep Neural Network Library (cuDNN)
```
cuDNN/8.9.2.26-CUDA-12.1.1
cuDNN/9.5.0.50-CUDA-12.6.0
```

## AI Model Hosting Packages

The ecosystem software and prerequistes for hosting AI models is rapidly evolving. ARC is closely monitoring and frequently updating models and engines.

### llama.cpp
"High-performance C/C++ LLM inference engine (llama-server) using GPU acceleration."
```
llama.cpp/server-cuda12-b8172
llama.cpp/server-cuda13-b8193
```

### OLLAMA
"Get up and running with large language models."
```
ollama/0.17.4-GCCcore-14.3.0-CUDA-13.0.2
```

### VLLM
"High-throughput, memory-efficient LLM inference engine."
```
vLLM/0.15.1
vLLM/0.17.0
```

## Outline
0. (10 min) [Welcome](./0-intro.md)
1. (20 min) [ARC Cluster GPU Offerings and Comparisons](./1-arc_gpus.md)
2. (25 min) [Inspection and Interfacing with GPUs](./2-Interactions.md)
3. (10 min) Break
3. (25 min) [Programming with GPUs](./3-Programming.md)
4. (25 min) [Parallelization with GPUs](./4-Parallelization.md)