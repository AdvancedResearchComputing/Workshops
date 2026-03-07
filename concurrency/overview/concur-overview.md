## Link Back To Main


## Overview

There are myriad ways (programming languages, constructs, packages,
frameworks) for executing concurrency in software.

Concurrency (parallelism) has advantages.
Among these are:

1. concurrent thread and/or process execution to get more work done in the
same amount of time, compared to a serial code (albeit, using more compute resources).
2. sharing of same data to reduce memory footprint.
3. distribution of data to reduce per-machine memory footprint.

There are also limitations to some implementations.

We will briefly and informally go over some of the fundamental concepts 
of concurrency.

Then, we will look at some popular constructs used for 
concurrency.
Importantly, these examples will run on ARC resources so they
provide illustrations of (some of) the details of getting jobs to run.

What is the best approach to use?  It depends.
It depends on your requirements, algorithms, data sizes,
languages with which you feel comfortable.

## Learning Objectives

1. Computing paradigms concepts.
2. Computing examples across PLs (programming languages) and clusters and concepts.
3. Examples illustrate different features.
4. Composition and content of sbatch slurm scripts.
5. How to run on VT ARC clusters (different universities do things differently so commands can change based on school/institution).
6. Understand what software libraries are doing under the hood.
7. Understand what (commercial) codes you use work, e.g., Ansys, Abacus, Lammps.
8. Understand (a very tiny bit) about architectures.
9. Know connections among concurrency (parallel) approaches.
10. Comparisons of concurrency methods.


## "Best" Practices (i.e., Practices You Might Want to Consider)

- Think about concurrency (versus serial code).
    - How many “threads” of control will your code need?
    - How much memory will your code need?
    - How much time are you willing to spend waiting for a code to complete?
    - How many times would a concurrent code be used?
    - What is the “value proposition” for your concurrent code?
- What are your options (if any)?
    - Serial
    - Threading
    - Distributed computing
- Unless there is a compelling reason to do otherwise, most often the "best" path forward is:  serial -> threading -> distributed.
    - But you should go through the pros and cons of each:  your case might be special.
- Benefits of a serial code (no matter what).
    - If you are not going to first write a serial code, you better have a very compelling reason why not (and 99% of the time, if you do, then I won’t believe you).
    - Serial code provides
        - Understanding,
        - Better/refined code structure, 
        - Ability to instrument the code to find the (time) bottlenecks [and hence know where to prioritize concurrency efforts],
            - this point is key:  you do not just parallelize code---you parallelize code that takes the longest serial time to run.
        - Code reuse [the guts of your serial code is overwhelmingly likely to be required in any concurrent code].
        - A code base that is easier to debug than a concurrent code.
        - A verified code with which to verify any parallel code.
        - Much easier to "refactor" your code as you go.
- What concurrency approach has the best (benefit-cost), i.e., bang-for-the-buck?
    - Often this will be threading, particularly if one machine has sufficient memory to execute your code.
    - It gives you concurrency, without the complications of distributed computing.
    - This is my initial "go-to" the great majority of the time.
    - And if you code using good modularity, scope, etc., then you can reuse the guts of your code for a distributed code if it comes to that.
- What is the most robust solution?
    - Distributed computing is the most robust solution, in the sense that it offers the best scalability to large problems.
        - Generally, it is easier, in a cluster environment, to get access to many "normal" nodes than one huge memory node. 
            - Huge memory nodes are hugely expensive.
    - But it comes at a big cost (harder to design, write, debug, verify).
- What approach requires the most “wide open” eyes?
    - Distributed computing is generally the most complicated paradigm (I am thinking MPI here).
- For parallel codes:
    - First "stub out" your code.  Example:  If it is MPI, just get each process to communicate as it will need to do in your real code.
    - Create your sbatch slurm script so it runs your code.
    - Pass around simple payloads, like a single integer.
    - Write these simple data to file to ensure you have unique filenames and processes are not stepping on each other.
    - If it is a big code that will run for a day or more, consider writing "progress files" as output for each MPI process (or thread).
    - Time important sections, like reading in of large data, big loops, etc. Write timing data for each MPI process (or thread) to a separate output file.
    - Write the outputs to file, and do the minimal amount of work in the outputting of data.  That is, no post-processing, no concatenating file.
    - Write separate codes to post-process data.
    - You do not want to have to rewrite and rerun your concurrent code so that you have output in a "new" format.
- For those doing research (and want to get your degree done so that you can get on with your life), think about what your contributions are (I mean contributions in so far as your thesis, research papers).
    - If you must write a code, but it does “basic” work that you are not going to get credit for as a contribution in a research paper, you better have a good reason(s) for not just building a serial code.
    - Because it takes more time to “do” (design, construct, debug, build verification cases) parallel codes.
    - I have had this happen:  I parallelized a code that was not critical to my thesis, because it was part of a pipeline than contributed (i.e., cost) 24 hours of run time.  So to get the entire pipeline execution time down, I had to parallelize the code.  But, I used threading.



## Some Potentially Interesting Links

https://ds.cs.luc.edu/storage/storage.html#storage-devices



