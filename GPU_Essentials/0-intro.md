# Welcome to the ARC "GPU Essentials" Workshop

## Outline
0. (5 min) [Welcome](0-intro)
1. (25 min) [ARC Cluster GPU Offerings and Comparisons](1-arc_gpus)
2. (25 min) [Inspection and Interfacing with GPUs](2-interactions)
3. (10 min) Break
3. (25 min) [Programming with GPUs](3-programming)
4. (25 min) [Parallelization with GPUs](4-parallelization)

## Why are we using GPUs for scientific computing

GPUs were originally created to accelerate graphics processing. This task often reduces to streaming large volumes of data through the accelerator and performing matrix operations on vectorized data. The human threshhold for detected visual changes is only 30 Hz, which is extraordinarily slow in computer terms. But even fast CPUs struggled to keep up with the continuous volumes of input data.

By recognizing the the graphics processing workload is very much "single-instruction, multiple-data" (SIMD), early developers designed add-on devices which grouped together very simplified (and thus cheap and efficient) components to work in locked synchonization to handle this problem.

In the 2000's PC display resolutions crept up from 800x600 to 1024x768 to 1600x1200. This trend was both enabled by GPUs and also pushed GPUs to grow in capability and performance.


### Recent CPU specs and capabilities
This image exposes some of the architectural components of an Intel "Skylake" CPU processor. These were released around 2015 and the model in the image shows 28 CPU cores.
![Intel Skylake Die Shot](images/skylake-dieshot.jpg)

![AMD Zen2 Rome Die Shot](images/zen2rome-dieshot.jpg)

| **CPU**            | **Year** | **Clock (MHz)** | **Process (nm)** | **Max Cores** | **AVX?** | **GFLOPs Theoretical** | **Watts** | **GF/W** | **Watts/Rack (est. peak)** |
|:-------------------|:--------:|----------------:|-----------------:|--------------:|:-------:|-----------------------:|----------:|--------:|---------------------------:|
| Sandy Bridge       | 2011     | 2300            | 32                | 8             | AVX2    | 73.6                   | 95        | 0.77    | 6 175                      |
| Haswell            | 2014     | 2600            | 22                | 18            | AVX2    | 187.2                  | 175       | 1.07    | 11 375                     |
| Skylake            | 2015     | 2100            | 14                | 28            | AVX512  | 470.4                  | 173       | 2.72    | 20 760                     |
| Zen 2 “Rome”       | 2019     | 2600            | 7                 | 64            | AVX2    | 665.6                  | 225       | 2.96    | 27 000                     |
| Zen 4 “Genoa”      | 2022     | 3800            | 5                 | 48            | AVX512  | 1 459.2                | 290       | 5.03    | 34 800                     |

![A100 GPU Architecture](images/a100-layout.jpg)
![A100 SM Layout](images/a100-smlayout.png)

## What problems run well on GPUs

There are some problems which are very difficult to execute efficiently on GPUs.