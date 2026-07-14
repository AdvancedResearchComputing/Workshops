# Mapping Job Types to GPUs:  All GPU-Based Compute Nodes Are Not Created Equal

ARC has six (soon to be seven) types of GPUs.

Some are particularly well-suited for particular types of jobs.

It is important to know these mappings because GPU resources
are scarce.
(Note that compute resources are always scarce---there is never
enough to do all work as quickly as users desire.

So this is a universal problem, in no way specific to VT.)

It is in everyone's interest to use resources in wise ways so
that you as an individual and VT as a collective run as many
jobs as possible in some unit of time.


|     Use              | Cluster   | GPU Node Type   |
|   ---                |     ---   |  ---            |
|  LLM inference; AI training; data analytics; HPC  |   TC   |    A100    |
|  memory-intensive, large-scale LLM; HPC           |    TC      |     H200     |
|  AI workloads; low-prec HPC       |    Owl       |  B200`*` |
|  AI inference; HPC FP32 only         |    Falcon  |    L40S      |
|  HPC FP64; AI inference        |    Falcon  |    A30       |
|  HPC FP64; Light ML (training and inference); data analytics; graphics         |    Falcon  |    v100      |
|  Light ML inference; FP32 ; visualization and graphics        |    Falcon  |    T4        |

`*` coming in late summer/fall 2026.

Tomorrow's workshop on GPU Basics will provides more info on GPU charactistics and usage.