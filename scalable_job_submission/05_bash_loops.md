

## Use of (bash) Scripting Loops


### Example 1:  Sbatch Slurm Job Submission


#### Background

You have a code that you want to run multiple
times with different inputs.

For each input variable, you create one loop.

Then, by nesting all of these loops, you can
call the code/software with every combination
of inputs.

The executions are serial, one after the other.



#### Inputs

Please copy the contents of the files below into files on the cluster, using the same names.

The purpose of this example is to take a template file
and specialize it for a host of different
sets of inputs.

All files should be put in one directory.


The sbatch slurm script is _slurm.01.sbatch_.

```bash
#!/bin/bash

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## ACCOUNT.
#SBATCH --account arcadm

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:30:00

## -----------------------
## JOB QUEUE/PARTITION.
#SBATCH --partition=normal_q

## -----------------------
## NUM NODES AND CORES.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH -o slurm.bash.loops.%j.out
#SBATCH -e slurm.bash.loops.%j.err

## -----------------------
## MEMORY FOR SMP.
##  #SBATCH --mem=128MB



## -----------------------
## MODULES.
# Optional: If modules are needed, source modules environment
module reset

## -----------------------
## WORKING DIRECTORY.
## cd $PBS_O_WORKDIR
## cd $SLURM_SUBMIT_DIR

## -----------------------
## EXPORTS 


## -----------------------
sh run.gen.configs.sh

```


The configuration file template: _config.template_.


```bash
## Try50-1 example.
## Open MP if value is 1.
 OpenMP 1
## Number of OpenMP threads to use is parallel sections.  Value 0 means use max threads possible.
## Eg., on pecos, this means 8; on shadowfax this means 12.
 NumOpenMpThreads 19
## For hybrid code, threshold number of messages in a bundle, for
## a particular send queue, such that when this number is
## reached, the bundle of messages is sent.
 HybridNumBundleMessagesSend 40
## Graph stuff.
## 0 means edges are undirected (or bidirected). 1 is directed.
 GraphEdgeDirectionality 0
 ## GraphFormat EdgeList try01.uel.w.rank.nodes 1 try01.strip.uel
 ## Changed so nodes assigned randomly.
 ## Assuming this is in mif/<subdir>.
 GraphFormat EdgeList ../../../networks/AAAA.nodes 0  ../../../networks/AAAA.uel
## Node attribute file.
## The integer node traits are:  NIM Model ID, submodel ID, and the duration of infection.
 IntegerNodeTraits 2  2  ../../../properties/AAAA/AAAA.int.node.traits
 IntegerEdgeTraits 6  6  ../../../properties/AAAA/AAAA.int.edge.traits
## State is denoted by 1 integer.
 IntegerNodeStates 3  6  ../../../properties/AAAA/AAAA.t.BBBB.int.node.states
 DoubleNodeStates 2  4  ../../../properties/AAAA/AAAA.t.BBBB.double.node.states
 ShortEdgeStates 2  4  ../../../properties/AAAA/AAAA.t.BBBB.short.edge.states
 ShortEdgeStates 4  8  ../../../properties/AAAA/AAAA.t.BBBB.char.edge.states
## For node properties; number of FSMs, FSM ID, number of kinds in node state, for each kind i, d, or c, and indices.
 NodeStateVectorIndices 1     1     1    i 0 2 3 5
 FsmDiffusionModelIndicesTraits 1  1 0
 FSM ../../../models/nim-11-6.fsm.cntrl
## Fixed seed; if this line exists, gives reproducible results in stochastic computations.
 FixedRandomSeed 14
## Maximum number of time steps.
 MaximumNumTimeStepsPerRun 50
## For deterministic computations, stop on fixed point.
## Specify the initial seeding method-- only valid entry is 1.  This is seed by explicit nodes in seed file.
 InitialSeedByNodeAndState 1
## Initial conditions:  Filename containing initially infected nodes.
##  SeedFile ../../../seeds/blocking/AAAA/EEEE/AAAA.p.EEEE.ms.CCCC.k.FFFF.bt.BBBB.ti.DDDD.seeds
 SeedFile ../../../seeds/blocking/AAAA/EEEE/AAAA.p.EEEE.ms.CCCC.bt.BBBB.ti.DDDD.seeds
## Intervention conditions:  Filename containing blocking nodes.
 InterventionFile ../../../seeds/blocking/AAAA/EEEE/AAAA.p.EEEE.ms.CCCC.k.FFFF.bt.BBBB.ti.DDDD.seeds
## output all of the node states, even the zeros.
 StopOnFixedPoint 1
 OutputAllStateChanges 1
 NumRunsPerSimulation 100
 OutFile ../../../../runs/AAAA.t.BBBB.ms.CCCC.ti.DDDD.p.EEEE.k.FFFF.is01
 LogFile ../../../../runs/AAAA.t.BBBB.ms.CCCC.ti.DDDD.p.EEEE.k.FFFF.log
```

File _run.gen.configs.sh_.

```bash
# Inputs

base_graph="
wiki
        "
thresholds="  1  2 3 4 5 6 7 8 9 10"

tincreases=" 1 2 3 4 5 6 7 8 9 10"

min_seeds="   15  100  500  1000  5000   "

props=" nd  cl  bc  cc  ec  pr hs as  kn "

kvalues="10 50 100 500 1000  2000  3000  4000    5000"

template_file="../../config.template"

# Execution

for c in $min_seeds
do

    locDir=block-min-seeds-"$c"

    mkdir -p "$locDir"
    cd "$locDir"

    for a in $base_graph
    do

        mkdir -p "$a"
        cd "$a"

        for b in $thresholds
        do

            for d in $tincreases
            do
                for e in $props
                do
                    for f in $kvalues
                    do
                        sed -e "s/AAAA/$a/g"   -e "s/BBBB/$b/g"  -e  "s/CCCC/$c/g"   -e  "s/DDDD/$d/g"    -e  "s/EEEE/$e/g"    -e  "s/FFFF/$f/g"   ${template_file}    >    "$a".t."$b".ms."$c".ti."$d".p."$e".k."$f".inp
                    done
                done
            done
        done
        cd ..

    done
    cd ..

done
```



#### Slurm Sbatch Job Submission

To submit the job to the Slurm scheduler on ARC clusters, type:

```
sbatch slurm.01.sbatch
```

#### Output

First, note our main objective:  to run many executions of a code
from one sbatch slurm script.

The number of executions is the product of the number
of values across all inputs:

1 x 10 x 10 x 5 x 9 x 9 = 40500

This is also the number of output files.

Output file _wiki.t.8.ms.15.ti.3.p.hs.k.4000.inp_ is:

```output
## Try50-1 example.
## Open MP if value is 1.
 OpenMP 1
## Number of OpenMP threads to use is parallel sections.  Value 0 means use max threads possible.
## Eg., on pecos, this means 8; on shadowfax this means 12.
 NumOpenMpThreads 19
## For hybrid code, threshold number of messages in a bundle, for
## a particular send queue, such that when this number is
## reached, the bundle of messages is sent.
 HybridNumBundleMessagesSend 40
## Graph stuff.
## 0 means edges are undirected (or bidirected). 1 is directed.
 GraphEdgeDirectionality 0
 ## GraphFormat EdgeList try01.uel.w.rank.nodes 1 try01.strip.uel
 ## Changed so nodes assigned randomly.
 ## Assuming this is in mif/<subdir>.
 GraphFormat EdgeList ../../../networks/wiki.nodes 0  ../../../networks/wiki.uel
## Node attribute file.
## The integer node traits are:  NIM Model ID, submodel ID, and the duration of infection.
 IntegerNodeTraits 2  2  ../../../properties/wiki/wiki.int.node.traits
 IntegerEdgeTraits 6  6  ../../../properties/wiki/wiki.int.edge.traits
## State is denoted by 1 integer.
 IntegerNodeStates 3  6  ../../../properties/wiki/wiki.t.8.int.node.states
 DoubleNodeStates 2  4  ../../../properties/wiki/wiki.t.8.double.node.states
 ShortEdgeStates 2  4  ../../../properties/wiki/wiki.t.8.short.edge.states
 ShortEdgeStates 4  8  ../../../properties/wiki/wiki.t.8.char.edge.states
## For node properties; number of FSMs, FSM ID, number of kinds in node state, for each kind i, d, or c, and indices.
 NodeStateVectorIndices 1     1     1    i 0 2 3 5
 FsmDiffusionModelIndicesTraits 1  1 0
 FSM ../../../models/nim-11-6.fsm.cntrl
## Fixed seed; if this line exists, gives reproducible results in stochastic computations.
 FixedRandomSeed 14
## Maximum number of time steps.
 MaximumNumTimeStepsPerRun 50
## For deterministic computations, stop on fixed point.
## Specify the initial seeding method-- only valid entry is 1.  This is seed by explicit nodes in seed file.
 InitialSeedByNodeAndState 1
## Initial conditions:  Filename containing initially infected nodes.
##  SeedFile ../../../seeds/blocking/wiki/hs/wiki.p.hs.ms.15.k.4000.bt.8.ti.3.seeds
 SeedFile ../../../seeds/blocking/wiki/hs/wiki.p.hs.ms.15.bt.8.ti.3.seeds
## Intervention conditions:  Filename containing blocking nodes.
 InterventionFile ../../../seeds/blocking/wiki/hs/wiki.p.hs.ms.15.k.4000.bt.8.ti.3.seeds
## output all of the node states, even the zeros.
 StopOnFixedPoint 1
 OutputAllStateChanges 1
 NumRunsPerSimulation 100
 OutFile ../../../../runs/wiki.t.8.ms.15.ti.3.p.hs.k.4000.is01
 LogFile ../../../../runs/wiki.t.8.ms.15.ti.3.p.hs.k.4000.log
```

Note that here, the six variables, AAAA through FFFF, 
are not replaced with values.


---

⬅️ [Previous: Introduction](01_introduction.md) | [Next: GNU pararllel ➡️](03_parallel.md)
