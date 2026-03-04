# Welcome to the ARC "GPU Essentials" Workshop

## Outline
0. (5 min) Welcome
1. (25 min) ARC Cluster GPU Offerings and Comparisons
2. (25 min) Inspection and Interfacing with GPUs
3. (10 min) Break
3. (25 min) Programming with GPUs
4. (25 min) Parallelization with GPUs

## It is worth it to use GPUs?

### Recent CPU specs and capabilities
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