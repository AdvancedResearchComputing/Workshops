# Java Threading

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)


# TODO:  use runnable approach.  Here, we subclass (extend) class Thread.


### Module

The Java module.

### Virtual Environments

None.


### Example 1

This example is run on the Owl cluster.

In this example, three Java threads add unique data to a map (dictionary).
When the three threads finish, the main thread prints the map
and it has the data from all threads.

#### Code and Script Files

The sbatch slurm script is _run.01.sbatch_.

```bash
#!/bin/bash

#SBATCH -J java-thread

## Wall time.
#SBATCH --time=00:10:00 # 10 minutes.

## Account (put in your own).
#SBATCH --account=arcadm

### This requests 1 node, 1 task, 4 cores.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4

### Other queues are:  a100_normal_q,  dgx_normal_q
#SBATCH --partition=normal_q

## Use the compute node only for this job, and use all memory on this node.
## #SBATCH --exclusive
## #SBATCH --mem=0
## #SBATCH --mem=10G

## Slurm output and error files.
#SBATCH -o slurm.java.threading.02.job.%j.out
#SBATCH -e slurm.java.threading.02.job.%j.err

## This can be very annoying.
## #SBATCH --mail-type=BEGIN,END
## #SBATCH --mail-user=ckuhlman@vt.edu
## #SBATCH --mail-user=hugo3751@gmail.com

# Load modules.
module reset
module load Java


# Activate a python env.
# None.

# Code to execute.
sh run.01
```


The run script is _run.01_.

```bash
java ThreadTest02
```


The Java source code files are next.

This is file _ThreadTest02.java_.

```java
import java.util.Set;
import java.util.Iterator;


public class ThreadTest02
{
   public static void main(String [] args)
   {
      int maxTimes=4;
      int numThreads=3;
      SharedData sd = new SharedData();


      sd.putData("initial-01","value-01");
      sd.putData("initial-02","value-02");
      sd.putData("initial-03","value-03");
      sd.putData("initial-04","value-04");

      MyThread t1 = new MyThread(0, numThreads, maxTimes, sd);
      MyThread t2 = new MyThread(1, numThreads, maxTimes, sd);
      MyThread t3 = new MyThread(2, numThreads, maxTimes, sd);

      System.out.println("Threads start.");

      t1.start();
      t2.start();
      t3.start();

      // Barrier.  Psuedo barrier.
      try {
          // The 5000 is the number of milliseconds for the main thread
          // to wait for the child thread to finish.
          // If child thread not finished, the parent thread will continue on executing.
          t1.join(5000);
          t2.join(5000);
          t3.join(5000);
      }
      catch(InterruptedException e)
      {
          e.printStackTrace();
      }


      System.out.println("Threads done.");
      System.out.println("  ");
      System.out.println("Final map contents.");
      System.out.println("   key      value");

      // sd.printData(System.out);

      String currKey="";
      String currValue="";
      Set<String> set_keys = sd.getKeys();
      Iterator<String> setIterator = set_keys.iterator();
      while(setIterator.hasNext()) {
          currKey = setIterator.next();
          currValue = sd.getData(currKey);
          System.out.println(currKey + "   " + currValue);
      }

   }
}
```

This is the code that gets executed in a thread.
The file is _MyThread.java_.

```java
class MyThread extends Thread
{ 
    // private SharedResource resource; 
    private SharedData sdata;
    private int id=0;
    private int numThreads=0;
    private int maxTimes=0;

    public MyThread(int localThreadId, int numThreads, int maxTimes, SharedData sdata)
    {
        this.id = localThreadId;
        this.numThreads = numThreads;
        this.maxTimes = maxTimes;
        this.sdata = sdata;
    }

    @Override
    public void run()
    {
        synchronized (this.sdata)
        {
            String keyString="";
            String valueString="";
            String currKeyString;
            String currValueString;
            int keyInt=0;
            int valueInt=0;
            int itime=0;

            for (itime=0; itime<this.maxTimes; ++itime) {
               keyInt = this.id + itime + this.id*1000;
               currKeyString = keyInt + "";
               valueInt = this.id + itime + this.id*2000;
               currValueString = valueInt + "";
               this.sdata.putData(currKeyString, currValueString);

            }
        }
    }
}
```

The file _SharedData.java_ contains the class that is used to store
data across threads.

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import java.util.Set;
// import PrintStream;

class SharedData
{
    //  Thread safe:
    //   https://www.quora.com/How-do-I-share-an-object-between-threads-in-Java
    private ConcurrentHashMap<String, String> map = new ConcurrentHashMap<>();

    public void putData(String key, String value) {
        map.put(key, value);
    }

    public String getData(String key) {
        return map.get(key);
    }

    public Set<String> getKeys()
    {
        Set<String> keys = this.map.keySet();
        return keys;
    }
}
```


#### Compiling Java Code

First, the Java module must be loaded so that the compilation
is performed with the same version of Java as for running the code.

```bash
module reset
module load Java
```


The following command compiles the Java code to bytecode.
With Java, if you specify the "main" code file, Java will
"follow the interconnectedness of codes" and will compile
to bytecode all Java source files.

```
javac ThreadTest02.java
```

#### Job Submission to Slurm

```
sbatch run.01.sbatch
```


#### Output

All threads output the same data, which is also the
same as in the main program.


```output
Threads start.
Threads done.
  
Final map contents.
   key      value
initial-01   value-01
initial-02   value-02
initial-03   value-03
initial-04   value-04
0   0
1   1
2   2
3   3
2005   4005
1004   2004
2004   4004
1003   2003
2003   4003
1002   2002
2002   4002
1001   2001
```

