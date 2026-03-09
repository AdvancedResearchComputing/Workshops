# Programming with GPUs

## Built-in

Some applications have built-in capabilities for using GPUs as accelerators. For example, this script compares the performance of a basic matrix-matrix multiplication on CPU vs. on GPU using Matlab:

### Matlab
```matlab
%N=13800*1.25;
for ii=1:10
    N=10000;
    prec="single";
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
    fprintf("speedup svd: %f \n",cpusvd/gpusvd)
end

```

### Computational Chemistry and Molecular Dynamics
Many of the calculations in these fields have matrix multiplications at their core and were early adopters of GPU accelerators. ARC provides installations which are built with GPU capabilities:

```
Amber/24.0-foss-2023b-AmberTools-24.0-CUDA-12.4.0
```

```
GROMACS/2024.4-foss-2023b-CUDA-12.6.0-PLUMED-2.9.2
GROMACS/2024.4-foss-2023b-CUDA-12.6.0
```

```
LAMMPS/22Jul2025-foss-2024a-kokkos-CUDA-12.6.0
LAMMPS/28Oct2024-foss-2023a-kokkos-mace-CUDA-12.1.1
LAMMPS/29Aug2024_update2-foss-2024a-kokkos-CUDA-12.6.0
LAMMPS/29Aug2024-foss-2023b-kokkos-CUDA-12.6.0
```
```
QuantumESPRESSO/7.4.1-NVHPC-24.9-CUDA-12.6.0
```
```
VASP/5.4.4-CUDA-12.6.0
VASP/6.4.2-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0
VASP/6.5.1-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0
```

### Libraries

"Fastest Fourier Transform in the West"
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
> ![note]
> Over time, Nvidia will drop support for older GPU architectures from their software. For example, CUDA versions 13+ do not support V100 GPUs (compute capability 7.0).

### Nvidia SDK for HPC
```
NVHPC/24.9-CUDA-12.6.0
NVHPC/24.11-CUDA-12.6.0
NVHPC/25.1-CUDA-12.6.0
```

### Nvidia Collective Communications Library
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

### OLLAMA
```
ollama/0.17.4-GCCcore-14.3.0-CUDA-13.0.2
```

