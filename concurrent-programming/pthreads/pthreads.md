# POSIX pthreads

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



### Module

`module GCC`

### Virtual Environments

None.




### Example 1

We run this example on the Owl cluster.

#### Slurm/Code Files

The slurm sbatch script is _run.01.sbatch_.


```bash
#!/bin/bash

#SBATCH -J pthreads

## Wall time.
#SBATCH --time=00:10:00 # 1 hour

## #SBATCH --account=personal
#SBATCH --account=arcadm

### This requests 1 node, 1 core.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=11

### Other queues are:  a100_normal_q,  dgx_normal_q
#SBATCH --partition=normal_q

## Use the compute node only for this job, and use all memory on this node.
## #SBATCH --exclusive
## #SBATCH --mem=0
## #SBATCH --mem=10G

## Slurm output and error files.
#SBATCH -o slurm.cpp.pthreads.04.job.%j.out
#SBATCH -e slurm.cpp.pthreads.04.job.%j.err

## This can be very annoying.
## #SBATCH --mail-type=BEGIN,END
## #SBATCH --mail-user=ckuhlman@vt.edu
## #SBATCH --mail-user=hugo3751@gmail.com

# Load modules.
module reset
module load GCC


# Activate a python env.
# None.

# Code to execute.
sh run.01
```


The run script is _run.01_.

```
./main.exe
```


The main C++ code is in file _main.C_.


~~~cpp
#include <stdio.h>
#include <pthread.h>
#include <iostream>
#include <unistd.h>

#define NTHREADS 10
void *thread_function(void *);
pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
int  counter = 0;

int main(int argc, char *argv[])
{
   pthread_t thread_id[NTHREADS];
   int i, j;

   // Create and start the threads.
   // for(i=0; i < NTHREADS; i++)
   for(i=0; i < NTHREADS; ++i)
   {
      // pthread_create( &thread_id[i], NULL, thread_function, NULL );
      printf("  i : %d\n",i);
      pthread_create( &thread_id[i], NULL, thread_function, &i );
      sleep(2);
   }

   // The join() operation here is a barrier. 
   for(j=0; j < NTHREADS; j++)
   {
      pthread_join( thread_id[j], NULL); 
   }
  
   /* Now that all threads are complete I can print the final result.     */
   /* Without the join I could be printing a value before all the threads */
   /* have been completed.                                                */

   printf("Final counter value: %d\n", counter);
}

// void *thread_function(void *dummyPtr)
void *thread_function(void *dummyPtr)
{
   int myNumber = *((int *)dummyPtr);
   printf("Thread number %ld\n", pthread_self());
   printf("myNumber : %d\n", myNumber);
   pthread_mutex_lock( &mutex1 );
   printf("adding to counter : %d\n", (myNumber+1));
   // counter++;
   counter += (myNumber+1);
   printf("counter : %d\n", counter);
   pthread_mutex_unlock( &mutex1 );

   return(0);
}
~~~


What is form bad about the _main.C_ code above?

Answer:  there are two print statements inside the critical section, i.e.,
the section of code bounded by `pthread_mutex_lock( &mutex1 );`
and `pthread_mutex_unlock( &mutex1 );`.
They are needed here, though, to verify the code, 
because we want to confirm the value to add to `counter` and
the resulting `counter` value.
You should minimize the work done in a critical section---because
you may be holding up all other threads, i.e., the progress of other
threads can be halted.
Also, you should minimimize the number of times a critical section
gets executed.
Ultimately, critical sections, while they are used and needed,
should---in most cases---be used as sparingly as possible.


#### Compile Code

First, the GCC module must be loaded so that the compilation
is performed with the same version of GCC as for running the code.

```
module reset
module load GCC
```




The compile process is in _build.sh_ and is

```
g++ main.C -o main.exe
```

To execute the build script:

```bash
run build.sh
```


#### Slurm Job Submission

~~~bash
sbatch run.01.sbatch
~~~

#### Output

Each of the ten threads takes an input
of 0 to 9.
To each of these, one is added.
So the code adds the numbers 1 through 10, to give 55.
For a number n (here n=10), the value is (n)(n+1)/2.

```
  i : 0
Thread number 23456240367168
myNumber : 0
adding to counter : 1
counter : 1
  i : 1
Thread number 23456238265920
myNumber : 1
adding to counter : 2
counter : 3
  i : 2
Thread number 23456236164672
myNumber : 2
adding to counter : 3
counter : 6
  i : 3
Thread number 23456234063424
myNumber : 3
adding to counter : 4
counter : 10
  i : 4
Thread number 23456231962176
myNumber : 4
adding to counter : 5
counter : 15
  i : 5
Thread number 23456229860928
myNumber : 5
adding to counter : 6
counter : 21
  i : 6
Thread number 23456227759680
myNumber : 6
adding to counter : 7
counter : 28
  i : 7
Thread number 23456225658432
myNumber : 7
adding to counter : 8
counter : 36
  i : 8
Thread number 23456223557184
myNumber : 8
adding to counter : 9
counter : 45
  i : 9
Thread number 23456221455936
myNumber : 9
adding to counter : 10
counter : 55
Final counter value: 55
```


