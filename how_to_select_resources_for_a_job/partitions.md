# Partitions:  The Compute Nodes on Which Your Job Runs

A partition is a collection of compute nodes.
A partition must be specified in an sbatch slurm script
(or interactive job from the command line).

Often, this collection of compute nodes
is of one type (i.e., one specific architecture),
say a particular class of GPU nodes.
But this is not always the case.
Partitions may have more than one type of compute node, e.g.,
to increase job throughput when they are sufficiently similar.

The partitions of all one node type are given below.
Specifying the partition completely specifies the type of 
compute node.

|  Cluster   | Partition |   Type of Compute Node  |
|    ---     |    ---    |      ---                |
|   TC       |    h200_normal_q   |  H200 GPUs     |
|   Falcon   |    l40s_normal_q   |   L40S GPUs    |
|   Falcon   |    a30_normal_q    |   A30 GPUs     |
|   Falcon   |    v100_normal_q   |   V100 GPUs    |
|   Falcon   |    t4_normal_q     |   T4 GPUs      |


The partitions with more than one node type are given
below.
In these cases, if one wants to specify uniquely
the type of compute node, then specifying only the
partition is not sufficient.


|  Cluster   | Partition |   Types of Compute Node  |
|    ---     |    ---    |      ---                |
|   TC       |    normal_q       |  CPUs:  AMD and Intel nodes.    |
|   TC       |    a100_normal_q  |  GPUs:  Nvidia and HPE nodes.      |
|   Owl      |    normal_q       |  CPUs: Genoa and Milan nodes.     |

We note that for many jobs, the type of compute node is
not important.
For example, one may want to run an app that will 
execute on CPUs, and it may run fine on either of the
two CPU types on the TC normal_q and on either of the
two CPU types on the Owl normal_q.

If the type of compute node is important, then in addition
to a partition, one specifies a constraint as a slurm
switch (see initial examples of sbatch slurm scripts).
Expanding the previous table, the mapping is:

|  Cluster   | Partition |   Compute Node Type; Constraint  | Compute Node Type; Constraint  |
|    ---     |    ---    |      ---                |    ---                |
|   TC       |    normal_q       |  AMD; `--constraint=amd`.    | Intel; `constraint=avx512`.    |
|   TC       |    a100_normal_q  |  Nvidia; `--constraint=a100-dgx`.    |  HPE;  `constraint=a100-hpe`.      |
|   Owl      |    normal_q       |  Genoa; `--constraint=avx512`.     |    Milan; `--constraint=milan`. |

As given in an earlier example, one situation in 
which constraints are required is when your code
uses a virtual environment.
This is because the virtual environment must be built
on the same type of compute node on which the 
environment is used.
So you must specify the same constraint in creating
the VE and running your job.

Another situation is profiling your code for performance evaluation.

There is one more issue worth addressing.
This is the Owl cluster and its use of standard, large memory,
and huge memory nodes.
You can see on the [Owl resources page](https://docs.arc.vt.edu/resources/compute/01owl.html)
that these are all "AMD EPYC 7000 series" nodes.
There are not distinct partitions for these nodes, nor
are there constraints that separate them.
Instead, the choice of compute node type is based
on the memory specified in the sbatch slurm script
with the `#SBATCH --mem` or similar switch.