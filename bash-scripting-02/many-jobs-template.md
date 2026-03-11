# Chaining Commands Together:  Piping

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)




#### Motivation:  Setup and Problem

We are running a code that has many input parameters.
Execution of the code one time is a "job."
We need to run a lot of these jobs.
Each job invokes a computational code that requires a configuration file to run,
where the parameter values for the code are specified.


We have a large input parametric space:  six variables with five values each.
This is 5**6 = 15625 jobs because we have a full factorial design.
Each job has its own slurm script, so each job has its own slurm output file
and configuration file.
So there will be 15625 configuration files.


The problem is how to generate 15625 configuration files quickly, and perhaps repeatedly.
That is, we often make mistakes in values or formats in configuration and other files,
so we have to redo them.
So being able to generate many files, and being able to generate many files in a flexible
manner, are both important.

Our solution is given next.


#### Solution Approach

Our approach consists of building two files:

1. A template file containing:
  - a. the desired format and contents.
  - b. variable names that are 'unique' _placeholders_ that will be overwritten with values
  for the six variables.
2. A bash script that:
  - a. iterates over parameter values for each parameter (i.e., variable).
  - b. for each set of parameter values (one value for each of six variables),
  makes a copy of the template file and overwrites
  the variable names with the parameter values.


The variable names in the template file
must be text that does not exist in other places in the template.
One way to do this is to use four consecutive capital letters to denote a variable.
So if there are four variable names, then the variables are:  AAAA, BBBB, CCCC, and DDDD.
All other characters in the template file are fixed and will not be altered.


#### Solution


Template file example.  Variable names are four consecutive same capitalized letters.
Here, they are AAAA, BBBB, CCCC, ..., FFFF.

The filename is _config.template_.

~~~bash
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
 IntegerNodeTraits 2  2  ../../../properties/basic-traits/AAAA.int.node.traits
## State is denoted by 1 integer.
 IntegerNodeStates 3  6  ../../../properties/basic-states/AAAA.t.BBBB.int.node.states
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
## Filename containing initially infected nodes.
 SeedFile ../../../seeds/blocking/AAAA/EEEE/AAAA.p.EEEE.ms.CCCC.k.FFFF.bt.BBBB.ti.DDDD.seeds
## output all of the node states, even the zeros.
 StopOnFixedPoint 1
 OutputAllStateChanges 1
 NumRunsPerSimulation 100
 OutFile ../../../../runs/AAAA.t.BBBB.ms.CCCC.ti.DDDD.p.EEEE.k.FFFF.is01
 LogFile ../../../../runs/AAAA.t.BBBB.ms.CCCC.ti.DDDD.p.EEEE.k.FFFF.log
~~~



Below is the bash script for the template file above.
A minor point is that the letter for a variable in the template
file is the variable used for the loop in the bash script.
For example, threshold in the template file is BBBB, and the
loop control variable in the bash script for parameter
threshold is b.
This is simply a useful mnemonic to help ensure correctness of the codes.

The filename is _run.gen.configs.sh_.

~~~bash
# Inputs

base_graph="
wiki  slashdot  epinions gcrp   facebook  enron
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
                        sed -e "s/AAAA/$a/g"   -e "s/BBBB/$b/g"  -e  "s/CCCC/$c/g"   -e  "s/DDDD/$d/g"    -e  "s/EEEE/$e/g"    -e  "s/FFFF/$f/g"   ${template_file}    >    "$a"/"$a".t."$b".ms."$c".ti."$d".p."$e".k."$f".inp
                    done
                done
            done
        done
        cd ..

    done
    cd ..

done
~~~



To run the code on the template file, type

~~~bash
sh run.gen.configs.sh
~~~


#### Explanation

Because we are doing a full factorial set of parameters, we loop over
the values of every variable and write the values into the variable
names in
a copy of the template.
If all parameters are independent, then the values for each parameter can be
put in a list, as is done here.
That is, surround parameter values in double-quotes and separate them by
one or more blank spaces.

We do the substitution using `sed`.
In the sed command `-e` means perform all of the substitutions on one
instance of the template, and in `s/DDDD/$d/g`, for example, the `g` tells
the value of `$d` to be substituted for every occurrence of `DDDD`.

Note that most of the loop control variables are
used for substitutions with `sed`.
However, it is often the case that one or more loop control variables will also
be used to generate new directories, if they are needed.
In this example, new directories are generated for loop variables `c` and `a`.
These new directories are simply a way to organize your inputs and to stay
away from UNIX/Linux-imposed maximums on the numbers of files in any one directory.
Approaching these maximums can severely degrade performance in operating on
files in directories.
The `mkdir -p` command means "make a directory only if it does not exist."
Files are then created inside of these two nested directories.
This is handy because if there is a mistake in the template file, then the directories
will not be reconstructed with each run of the bash script.

The description of the `mkdir` command highlights an often overlooked aspect of running
many code executions, and it is this:  take the time to design your directory structure
and directory names.  It will help a lot as your jobs progress and you have to manipulate
various files.
And never put blanks in names of files nor directories.

#### Bigger Picture

The above is done for a configuration file for running a code.
Now, suppose you are running your code through slurm, a cluster scheduler.
For each job, you might have these inputs:

1. slurm script
2. run script
3. configuration file
4. additional input (data) files

The above example addresses item 3.

