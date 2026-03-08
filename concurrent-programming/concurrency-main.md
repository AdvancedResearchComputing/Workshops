# Concurrency in Software


## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help and access to information, and links to those resources, are provided.

## Overview

This set of slides is designed to be a flexible set of resources for 
covering various aspects of concurrency programming.
The first four items below address concepts.
The remaining items provide concrete examples of concurrency
software tools that run on ARC clusters.

These tools are at various levels of software.  These include:

- UNIX/Linux tools.
- Slurm tools.
- POSIX tools.
- PL constructs.
- Software libraries.
- Software frameworks. 

By _**concurrency**_ we mean that multiple sequences of code are executing simultaneously.
Herein, we use "concurrency" synonymously with "parallel execution."
We are not interested in, for example, two "threads of control" or sequences of commands
being alive or active at the same time but not executing at the same time.
This behavior is either time-slicing or akin to it.
We have one or two examples of this, but they are only to recognize the limitations of
such approaches---they are not advocated.
Rather, we are interested in multiple threads of control executing code at the same 
moment in time.

_**Note on example codes**_.
Examples are the backbone of this document.  The idea is to save you time and energy
by providing examples for how codes run on ARC systems.
The approach used here is that the source code for examples is embedded right in the 
text files.
To run these codes---and they have been tested on ARC clusters---simply copy the contents
and paste them into a file (on the clusters).
For each code or slurm script or bash script or makefile or whatever, a file _**name**_ is
provided.  You can use your own filenames, but very often, those names appear within other 
code files.  For example (and this happens a LOT), say:  code A invokes code B.
If you give a different name to code B than what is specified in these pages, then you have
to modify the contents of code A so that it calls code "whatever-new-name-you-used" rather
than code B.
So it is most straight-forward to use the file names provided.
Since there are few files for each example and the files are small to keep examples 
minimalistic, the time required to paste contents of these pages into files using
a text editor is almost zero.
Also, the reason the codes are placed here and not in some github repo is because 
one can realize a LOT of value by SEEING the codes even if you do not execute them.
(It is recommended that you execute them.)
This approach makes the text and the code integrated in one place.


## Outline

1. [Overview](overview/concur-overview.md)
2. [Concurrent Paradigms:  Concepts](paradigms/concur-paradigms.md)
3. [Concurrency:  How To Get Into Trouble](trouble/concur-trouble.md)
4. [Concurrency Tools](tools/concur-tools.md)
5. [srun Tool](srun/srun.md)
6. [GNU Parallel Tool](gnu-parallel/gnu-parallel.md)
7. [srun and GNU Parallel Combined](srun-and-parallel/srun-and-parallel.md)
8. [Slurm Job Arrays](slurm-job-arrays/slurm-job-arrays.md)
9. [Python Multiprocessing](python-multiprocessing/python-multiprocessing.md)
10. [Java Threading](java-threading/java-threading.md)
11. [Pthreads](pthreads/pthreads.md)