# Python Environments

Source from the February 27th, 2026 workshop [materials](https://github.com/AdvancedResearchComputing/Workshops/tree/14c2cb709ee848a4cb72ab94bf98e54c23feb4c6/Virtual_Environments)

## Creating environments:

### Get a job!
ARC has 10+ different node types. We go to great lengths to provide a uniform experience, but each type may still have differences in hardware, drivers, optimizations, and available software modules.

> [!WARNING]
> Do not expect `conda` environments to be portable between clusters or nodes types.

ARC recommends:
1. constrain each python environment to a single node type
2. build an environment on the node type where it will be used

Here's how you might get an interactive job on a Falcon V100 node to build an environment:
```bash
interact --account=<account> --mem 8G --partition=v100_normal_q --gres=gpu:1
```

> [!NOTE]
> An `interact` jobs has dedicated access to the allocated resources. End the job with `exit` to release the resources back as soon as you're at a stopping point. This helps keep jobs moving through the clusters and reduces wait times for everyone.


### What provides `conda`?
There are several options available for managing `conda` environments. The open source `conda` tool is packaged into:
 - **Anaconda**: Anaconda, Inc.'s distributions (contains software subject to stricter usage licensing and prefer's licensed repo channel)
 - **Miniconda**: Lightweight version of Anaconda, prefers licensed channel
 - **Miniforge**: Open source `conda` and does not use Anaconda licensed channels

> [!TIP]
> Load the latest Miniforge module to start using `conda` for managing python environments 
```bash
module load Miniforge3/25.11.0-1
```

### Basic `conda` build steps
After getting a job and loading the `Miniforge3` module, the typical steps are:
1. **Create** an environment, specifying either a name `-n` or path `-p`:
```
conda create ...
```
2. **Activate** the environment, specifying the name or path as above :
```
source activate <name of or path to env>
```
3. **Install** packages
```
conda install ...
```
or 
```
pip install ...
```
> [!WARNING]
> Some software packages will provide a `requirements.yml` defining a complete list of packages for the environment. This are often overly specific and quickly become outdated which may result in `conda` failing to resolve the set of dependencies to install.


## Sbatch and interactive jobs

## How to use conda within Jupyter Notebooks on OOD