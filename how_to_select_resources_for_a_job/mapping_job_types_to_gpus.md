# Mapping Job Types to GPUs:  All GPU-Based Compute Nodes Are Not Created Equal

ARC has six (soon to be seven) types of GPUs.

Some are particularly well-suited for particular types of jobs.

It is important to know these mappings because GPU resources
are scarce.
(Note that compute resources are always scarce---there is never
enough to do all work as quickly as users desire.
Even at places like Amazon.
So this is a universal problem, in no way specific to VT.)

It is in everyone's interest to use resources in wise ways so
that you as an individual and VT as a collective run as many
jobs as possible in some unit of time.

**<<Matt, I got this off of the internet; please inspect.>>**

|     Use              | Cluster   | GPU Node Type   |
|   ---                |     ---   |  ---            |
|   `&` LLM inference; AI training; data analytics; HPC/RC  |   TC   |    A100    |
|   memory-intensive, large-scale AI and HPC/RC           |    TC      |     H200     |
|   `*` AI workloads       |    Owl       |  B200 |
|   AI inference; visualization; video and media processing         |    Falcon  |    L40S      |
|   AI inference; data analytics; HPC/RC        |    Falcon  |    A30       |
|   Deep learning (training and inference); data analytics; HPC/RC         |    Falcon  |    v100      |
|   `$` NLP; single precision computations        |    Falcon  |    T4        |

`&` HPC = high performance computing; RC = research computing.

`*` coming in late summer/fall 2026.

`$` NLP = natural language processing.
