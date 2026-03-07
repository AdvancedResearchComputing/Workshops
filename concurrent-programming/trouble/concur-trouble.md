# Concurrency:  How To Get Into Trouble

## Link Back To Main

[Back to Main Page](../concurrency-main.md)


## Issue:  Degeneration

Parallel or concurrent codes can degenerate to execute as though they are serial codes.

We look at two central ideas for how this can happen:

1. critical sections
2. load balancing.


## Critical Sections

### Concepts

Our starting point is as before:  threads executing concurrently.
In this graphic, it is ASSUMED that the data are independent so that they can be operated on 
by the threads in any execution order of the threads (non-determinism).

[critical sections-1](../../figures/concept-crit-section-1.pdf)
![critical sections-1](../../figures/concept-crit-section-1.png)


Now, what happens if we have critical sections in the code?
A __critical section__ is a hunk of code that must be run by one thread at a time, so that
all other threads must wait for that executing thread to finish, whereupon a single other
thread may execute that special hunk of code.
This most often happens when data are updated and different threads need to make use of
the updated data.
If the threads do not take turns, the data could get into an inconsistent state, i.e.,
could become corrupted.
For example, if the code hunk was not in a critical section, so that the threads could
access the data in any way, then two threads may be updating the same piece of data.
This is shown below.


[critical sections-2](../../figures/concept-crit-section-2.pdf)
![critical sections-2](../../figures/concept-crit-section-2.png)


Since one cannot now have all threads run concurrently, what is going on?
In extreme cases, the parallel code could EXECUTE as if it is a serial code.
In the graphic below, threads are now numbered to see how they map from the upper
graphic to the lower one.


[critical sections-3](../../figures/concept-crit-section-3.pdf)
![critical sections-3](../../figures/concept-crit-section-3.png)

Also, a key and unfortunate outcome of this phenomenon is that as the number of 
threads or processes increases, so that you hope to achieve greater concurrency and
therefore drive the execution time to lesser times,
this effect of critical sections becomes MORE pronounced.



### Example

There is an example in the OpenMP section showing how 
sub-optimal use of critical sections
can drive execution time up by a factor of 5x or 6x.

## Load Balancing:  Distributed Systems


This is an issue for forking, threads, distributed processing, and combinations of them.
We will use MPI (distributed) computing, just to be different from the threading above.
Our original distributed processing graphic is below.

[distributed-1](../../figures/concept-distributed.pdf)
![distributed-1](../../figures/concept-distributed.png)

Each of the four processes is now represented by a cyan arrow in the following graphic.
In the first case, all four processes execute for about the same amount of time
and this is good load balancing.
Note that all four processes do not have to be executing the same code.
In the second case, process 3 takes a long time to complete its work, while
processes 1, 2 and 4 finished much faster.
So processes 1, 2, and 4 wait for process 3 to complete, an amount equal to the
magenta bars.
The total length of the magenta bars is a measure of load imbalance.
A total magenta height of zero (or near zero) means load balancing is achieved.

If the length of the cyan arrow for process 3 dominates the
combined lengths of the arrows for processes
1, 2, and 4, then this execution is, in the limit, a serial code.



[distributed-2](../../figures/concept-load-balance-1.pdf)
![distributed-2](../../figures/concept-load-balance-1.png)


## Load Balancing:  Threading

Return to the most recent graphic above.
In the previous discussion, we cyan arrows were execution times and magnenta blocks were
wasted time when a cpu (or gpu warp) could be executing, but is not.

Now let us return to the notion that the cyan arrows are executing threads.
There is an OpenMP example later where we look at the OMP keyword `schedule`.
`schedule` can take on values of `dynamic` or `guided` and these options are used
precisely to ensure (or to attempt to ensure) that all threads run for the same
amount of time.



## Summary

We looked at critical sections in terms of threading and load balancing in terms of distributed computing.

But each problem (critical sections, load balancing) can arise in each of 

1. threading.
2. distributed computing.

Without any loss in concepts, the load balancing across processes (above) is equally applicable to threading.

Critical sections can arise in distributed codes because each process can have threads.

So critical sections and load balancing have wide scope.


{% include links.md %}

