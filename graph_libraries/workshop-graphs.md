# Using Graph Libraries on ARC Clusters


## Ideas Behind This Workshop

1. Graphs are an abstraction and there
2. Running VS Code is allowable on head nodes IF
   1. You do not run with plugins, e.g., do not run with AI plugins.
   2. You do not run code:  no code execution, no major code debugging.
3. Why these restrictions?
   1. Because head nodes are communal resources that all users make use of _**simultaneously**_.
   2. (Compute nodes, on the other hand, _**ARE**_ used by a selected few users at a time according to Slurm scheduler operations.)
   3. So if you are consuming lots of resources on head nodes, then you are degrading 
          the performance of the head nodes for all other users.
       1. VS Code is a _**primary**_ way that users consume too many resources on head nodes.
   4. It is most useful to think of yourself and all other 1000 ARC users as being in the same boat:
         we need to be respectful of others, by following agreed upon procedures, so that everyone
         can work efficiently and get their work done.
4. To summarize:  I want to use VS Code to do my work and
   1. I want to debug and run my code.
   2. I want to use AI or other plugins.
5. How do I do this?
6. By running your instance of VS Code on a _**compute**_ node.
7. This workshop is all about running VS Code on compute nodes.



## Organization

### Applicability

1. These procedures apply to Tinkercliffs (TC), Owl, and Falcon clusters.


### Prerequisites

1.  ssh installed on your local machine (comes with most laptops). [SSH keys](sshkeys)
2.  If working remotely, have [VT VPN](https://www.nis.vt.edu/ServicePortfolio/Network/RemoteAccess-VPN.html) installed on your laptop (local machine).
3.  ARC [account](https://arc.vt.edu/account).
4.  Project for file storage.  Not absolutely critical for this workshop, but critical for your work.
5.  [allocation](allocations) to charge "jobs" to.
6.  

## Learning Objectives

1. List some of the major graph analysis libraries.
2. Learn how to customize your ARC work areas to use different graph libraries.
3. Learn how to use modules and virtual environments.
4. Learn how to compute graphs and properties with these graph libraries.
5. Learn out to set up files, launch jobs, view results:  running in batch mode.



### Major Activities  TODO

1. VS Code
   1. Install VS Code (VSC) on your laptop.
   2. Install the `Remote-ssh` plugin in your VSC.
   3. Make sure you have a 
2. Laptop (or local machine)
   1. Alter the _config_ file under directory _.ssh_ as below



-----------------------------

-----------------------------

## Graph Overview


### Nomenclature

[Graph Nomenclature](figures/graph-analytics-workshop-march-2025-slide-1.pdf)
![Graph Nomenclature](figures/graph-analytics-workshop-march-2025-slide-1.png)

### Graph Classes

Some classes of graphs are given in the figure below.


[Graph Classes](figures/graph-analytics-workshop-march-2025-slide-2.pdf)
![Graph Classes](figures/graph-analytics-workshop-march-2025-slide-2.png)


### Ubiquity of Graphs

Many, many systems can be represented as graphs.
Some examples are below.


[Graph Classes](figures/graph-analytics-workshop-march-2025-slide-3.pdf)
![Graph Classes](figures/graph-analytics-workshop-march-2025-slide-3.png)



### Graph Operations

For this presentation, we confine ourselves to two basic categories
of operations.

1. _Graph construction_:  creating graphs and storing them to file.
2. _Analyzing graphs_:  computing properties of graphs.  Often these are structural properties,
but it can be almost anything, e.g., list the edges of a graph that have label _sky_.


### Graph Analytics Libraries

Graph analytics libraries are useful because they use the above
abstractions---the graphs---to compute information about graphs
that then can be mapped back into the problem space.

Example:  What does the node with the greatest degree mean in
each domain below?


|  Domain       | Meaning of Highest Degree Node |
| ------------- | ------------------ |
| Brain neural network | neuron that is most connected to other neurons; probably firing a lot. |
| Road network |   an intersection that is expected to have a lot of traffic and therefore congestion. |
| Citation network | this person has the most collaborators. |
| subway network   |  a person might want to get to this station to have a lot of options for where to go next. |
| class schedule network | the class with the most students. |

... and so on.
The graph computation is the same; the difference is in the interpretation
of the results based on the domain.


### Motivation for Using Graph Analysis Libraries

Hence, there is great motivation to develop graph analysis libraries because
they can be used to solve problems in so many fields.


Graph analysis libraries take a long time to develop, particularly distributed
codes.
This is because of irregularities.
Take a constrast.
Given the sizes (dimensions) of two matrices to multiply together,
I know immediately how many multiplies and additions will be performed
because the data and operations are regular or well-structured.
Each graph, in contrast, has both global and local structure and since graph
structures can vary widely, these problems are not regular
or well-structured.
Which means things like---for computations---load balancing,
partitioning a problem, and memory and CPU utilization are not
straight-forward to reason about.


### Overview of Graph Libraries

There is a range of graph libraries, and it is often difficult to compare them,
as the strengths and weaknesses in the table below indicate.
Most, if not all libraries, have pythong interfaces, although codes like SNAP and
NetworKit are C++ codes under the (Python) wrappers.


| Library Name     |   Pros         |    Cons       |
| ---------------- | -------------- | ------------- |
|    NetworkX      | (a) Many more (e.g., 275) operations on graphs than other libraries. (b) Community of users so multiple working threads. (c) Documentation good.  | Does not scale well (neiher in memory nor processing). |
|    SNAP      | Serial code, but build for scalability and larger graphs.   |  Roughly about 30-40 graph operations. |
|    Snappy      | Is a Python wrapper around SNAP.  (a) Performant serial code. (b) Documentation good. |  Roughly about 30-40 graph operations. |
|    NetworKit      | Concurrent code; via multithreading.  (Uses OpenMP.)  A larger number of graph operations.  |  Does not have the number of methods that NetworkX does. |
|    Gunrock      | GPU-based code.   |  A smaller number of graph operations. |
|    RAPIDS      | GPU-based code.   |  A smaller number of graph operations. Only works with Nvidia GPUs. |


NetworkX is the most general and flexible, but it does not scale.
You will see adverse performance effects when you graph size increases
in the range 10,000 to 100,000 nodes.
Beyond 100,000 nodes, it is very slow.

In fact, if you can readily implement your own library methods, using naive approaches,
and realize execution times from 1/2 to 1/10 the time of NetworkX methods, using
1/3 to 1/10 the memory.
But NetworkX is excellent for its intended use:  by social scientists on small graphs.

All other libraries scale in much more performant ways.

RAPIDS is Nvidia's code base, evolved from nvGraph into cuGraph.
cuGraph is now in RAPIDS.
(Sometimes termed RAPIDS cuGraph.)


### How Libraries are Provided Within ARC

Libraries are provided typically either as modules or as packages that you
can install into your virtual environments.
Modules are created by ARC.
Gunrock is an exception, being built in a more traditional way using makefiles.

Note that if you have a choice on whether to build a virtual environment
or use a module, ARC highly encourages you to build a virtual environment.
This is because with virtual environments, you as a user have much
more control (basically, total control) of what packages and capabilities
you need and want so you can build your VEs in a customized fashion.
You have much less capability with modules, e.g., a module may not "play
well" with a virtual environment that you also need.
It is a natural part of the VE build process to ensure compatability
across multiple packages.
It is for this reason that ARC may not install modules for these
libraries.


| Library Name     |   Environment      |
| ---------------- | -------------- |
|    NetworkX      | Virtual Environment.  See https://networkx.org/documentation/stable/install.html    |
|    NetworkX      | Module.  In easybuild:  https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/n  |
|    SNAP      |   Module.  Easybuild:  https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s         |
|    Snappy     |   Virtual Environment.         |
|    Snappy     |   Module.  Easybuild:  https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s (separate from SNAP).          |
|    NetworKit      | Virtual Environment.  Python library.  See  https://networkit.github.io/ ( pip3 install networkit ) |
|    Gunrock      |   Prerequisite:  module---need to have:  CUDA v11.5.1 or higher.  Build using C++ makefile at website:  https://gunrock.github.io/gunrock/            |
|    RAPIDS      |   Virtual Environment.        |
|    RAPIDS      |   Module.  Easybuild:  https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/r             |


###  Where to Find the Methods That Libraries Possess

Here are web pages for finding methods that the
libraries provide.
No library provides all methods.


| Library Name     |  ARC Cluster      |
| ---------------- | -------------- |
|    NetworkX      | https://networkx.org/documentation/stable/reference/index.html |
|    SNAP          |    https://snap.stanford.edu/ |
|    Snappy     |   https://snap.stanford.edu/snappy/doc/tutorial/tutorial.html#computing-structural-properties |
|    NetworKit      |  https://networkit.github.io/dev-docs/notebooks/User-Guide.html ;  https://networkit.github.io/dev-docs/python_api/modules.html |
|    Gunrock      |   https://gunrock.github.io/gunrock/   |
|    RAPIDS      |   https://github.com/rapidsai/cugraph?tab=readme-ov-file; https://docs.rapids.ai/api/cugraph/stable/api_docs/cugraph/    |



### Mapping Graph Libraries to ARC Clusters

Each library can be run on multiple clusters.

The mapping is dominated by the software architecture of
the graph library, and specifically, the question:

Is this a CPU-based library or a GPU-based library?

If it is CPU-based, it runs on TC and Owl (becasue these clusters have multicore comptue nodes).

If it is GPU-based, it runs on TC or Falcon (because these clusters have GPUs).

Note:  GPUs are coming to the Owl cluster, so RAPIDS will be
able to run there, too.


| Library Name     |  ARC Cluster      |
| ---------------- | -------------- |
|    NetworkX      | Tinkercliffs (TC), Owl |
|    SNAP      |    Tinkercliffs (TC), Owl |
|    Snappy     |   Tinkercliffs (TC), Owl |
|    NetworKit      |  Tinkercliffs (TC), Owl |
|    Gunrock      |   Tinkercliffs, Falcon    |
|    RAPIDS      |   Tinkercliffs, Falcon    |


## NetworkX Graph Library

### Example 1:  Creating a Virtual Environment for NetworkX 

#### Module

We are not using any networkx-specific module but we will use
modules in creating a virtual environment (VE).

We choose a virtual environment (VE) approach because it is more
flexible and versatile.


#### Virtual Environments


We use a NetworkX virtual environment (a conda virtual environment)
to run the NetworkX library.

Details on how to build virtual environments (VEs)
are given in a separate workshop.
The commands are given here.

It is common to also install pandas and matplotlib for data
manipulation and plotting, respectively.

These procedures were run on Owl cluster.
Should work on Tinkercliffs, too.

But to work on TC, you have to:
1. create a new VE on TC, analogous to that done here.
2. alter the sbatch slurm script for TC and for the VE built on TC.


The steps to create the VE are given below.

~~~
# Acquire resources.
salloc --account=<account>  --partition=normal_q  --constraint==genoa&avx512  --nodes=1 --ntasks-per-node=1 --cpus-per-task=2 --time=2:00:00

# Go onto compute node that salloc returns.  Here we assume that it is owl084.
ssh owl084

# List modules.
module list

# Load Miniforge to create VE.
module reset
module load Miniforge3

# Create VE.
# conda create -p ~/env/owl/normal_q/py312_mf_networkx
conda create -p ~/env-python/owl/normal_q/genoa/py314_mf_networkx

# Activate VE.
# source activate ~/env/owl/normal_q/py312_mf_networkx
source activate  ~/env-python/owl/normal_q/genoa/py314_mf_networkx

# Install packages.
# Will have to answer yes [y] many times.
conda install python=3.14
# Check python version, should be 3.14.
python --version
conda install pandas
conda install matplotlib
# Always try to do 'pip install' after all 'conda install'.
pip install networkx

# All done with building VE.  Deactivate the VE.
conda deactivate

# Get off of compute node.
exit

# Now back on login node of the ARC cluster.

# Release resources.
scancel <job ID of the salloc command>

~~~


Now a new VE should be:  ~/env-python/owl/normal_q/genoa/py314_mf_networkx



### Example 2:  Running a NetworkX Job in Batch Mode


#### Inputs


The sbatch slurm script, named _run.01.slurm_, is:

~~~
#!/bin/bash

#SBATCH -J networkx

## Wall time.
#SBATCH --time=00:10:00 # 1 hour

## #SBATCH --account=personal
# Have to use your own account.
#SBATCH --account=arcadm

### This requests 1 node, 1 core.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

#SBATCH --partition=normal_q
#SBATCH --constraint==genoa&avx512

## Use the compute node only for this job, and use all memory on this node.
## #SBATCH --exclusive
## #SBATCH --mem=0
## #SBATCH --mem=10G

## Slurm output and error files.
#SBATCH --output slurm.networkx.01.code.output.job.%j.out
#SBATCH --error slurm.networkx.01.code.output.job.%j.err

#SBATCH --mail-type=BEGIN,END
# Have to use your own email.
#SBATCH --mail-user=ckuhlman@vt.edu

# Print the ACTUAL resources provided by slurm to
# the output file.
scontrol show job --details $SLURM_JOB_ID

# Load modules.
module load Miniforge3


# Activate a python env.
# Have to use your own VE (virtual environment); name and location can vary.
source activate  ~/env-python/owl/normal_q/genoa/py314_mf_networkx


# Code to execute.
./run.01
~~~


The run script, _run.01_, is:

~~~
# file: run.01

python short.path.01.py
~~~


This python code uses NetworkX to construct a graph and
then find a shortest path between two nodes, A and E.

The NetworkX python source code---file _short.path.01.py_---is:


~~~
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib
import time
import sys



## =======================================
def main():

    # Get start time.
    begin_time = time.time()


    # Create a graph with nodes and edges
    G = nx.Graph()
    G.add_nodes_from(["A", "B", "C", "D", "E", "F", "G", "H"])
    G.add_edge("A", "B", weight=4)
    G.add_edge("A", "H", weight=8)
    G.add_edge("B", "C", weight=8)
    G.add_edge("B", "H", weight=11)
    G.add_edge("C", "D", weight=7)
    G.add_edge("C", "F", weight=4)
    G.add_edge("C", "I", weight=2)
    G.add_edge("D", "E", weight=9)
    G.add_edge("D", "F", weight=14)
    G.add_edge("E", "F", weight=10)
    G.add_edge("F", "G", weight=2)
    G.add_edge("G", "H", weight=1)
    G.add_edge("G", "I", weight=6)
    G.add_edge("H", "I", weight=7)

    # Find the shortest path from node A to node E
    path = nx.shortest_path(G, "A", "E", weight="weight")
    print("A shortest path between nodes A and E is: ")
    print(path)

    # Create a list of edges in the shortest path
    path_edges = list(zip(path, path[1:]))

    # Create a list of all edges, and assign colors based on whether they are in the shortest path or not
    edge_colors = [
        "red" if edge in path_edges or tuple(reversed(edge)) in path_edges else "black"
        for edge in G.edges()
    ]

    # Visualize the graph
    pos = nx.spring_layout(G)

    fig = plt.figure()
    nx.draw(G, pos, edge_color=edge_colors, ax=fig.add_subplot())
    nx.draw_networkx_labels(G, pos)
    # Save plot to file
    matplotlib.use("Agg")
    fig.savefig("graph.png")

    ## ---------------------------
    # Get end time and duration.
    duration = time.time() - begin_time

    return duration


## =======================================
if __name__ == "__main__":
    ## Driver.
    duration = main()
    dur_hours = (float)(duration)/3600.0
    print("    total execution duration (s, hr): ",duration,dur_hours)
    print (" ----- good termination -----")

~~~



#### Submit Job to Slurm

Issue this command to submit the job to slurm.

~~~
sbatch run.01.slurm
~~~


#### Analysis (Summary)

Procedure to run a slurm batch job:

1. Copy each of the above file contents into files on Owl or Tinkercliffs.
2. Use the provided file names.
3. Put all files in the same directory.
4. cd to that directory on the appropriate cluster.
5. Issue this command:  sbatch run.01.slurm
6. The slurm batch job should run.

#### Results

The results are as follows.

The text output is written by python to screen.
Since this is a slurm job, slurm redirects all output that would go to screen
and puts it in the slurm-generated output file, here named:
_slurm.networkx.01.code.output.job.%j.out_
where "%j" is the slurm-generated unique JOB ID.

In that file, a shortest path is:

~~~
A shortest path between nodes A and E is:
['A', 'H', 'G', 'F', 'E']
~~~


The path is shown in the graphic below.
From the python file, we see that this graphic is in
file _graph.png_.


![output graph](figures/networkx/graph.png)


## Snappy Graph Library






