# Control Structures:  WHILE Statement

#### Link Back To Main

[Back to Main Page](../aa-bash-02-main.md)



## `while` Loops

So far we have worked with fixed length loops;
however, not all processes are a fixed length,
and so a more open-ended solution is needed.

This is provided by the `while` loop, which uses a conditional statement to check when the
loop should be exited.

For example, this can be used to break the loop after user input:
~~~
halt=no
while [[ $halt != 'yes' ]]; do
  wait 3
  echo "break out of the loop? (yes or no)"
  read halt< /dev/tty
done
~~~
{: .language-bash}


One (and only one) example run of the above code could be:


~~~
-bash: wait: pid 3 is not a child of this shell
break out of the loop?
3
-bash: wait: pid 3 is not a child of this shell
break out of the loop?
4
-bash: wait: pid 3 is not a child of this shell
break out of the loop?
6
-bash: wait: pid 3 is not a child of this shell
break out of the loop?
YES
-bash: wait: pid 3 is not a child of this shell
break out of the loop?
yes
~~~
{: .output}



Note the use of `wait`, to wait a given number of seconds before continuing with execution
of the loop.

It can also be used to replicate
(in a slightly less obvious, maintainable, manner) the
for loops above:

~~~
varlist=( a list of strings )
len=${#varlist[@]}
i=0
while (( i<$len )); do
  echo ${varlist[$i]}
  (( i++ ))
done
~~~
{: .language-bash}


The output is:

~~~
a
list
of
strings
~~~
{: .output}

Note that the list is zero-indexed.



While loops are useful for process control: for automating the checking to see
whether
processes
are finished, for example, and moving onto the next stage of the workflow once they are.

> ## Tracking program progress
>
> As an example of how `while` loops can be used to wait for a process to finish, we will
> create a function which waits for a random period before finishing. It writes it's status
> to a log file, which we can use to track the progress of the program.
>
> What we are doing here is the following:
>  - writing a small code.
>  - run that small code (while not occupying the command prompt)
>  - interrogating the code's output file (log file) content to see whether
>    the job is done.  The command is `tail -n 1 log.out` and you keep invoking
>    this command (using the "up arrow") until the return from the command
>    is "finished" (no longer "started").
>
>
> ~~~
> sleeptest () { echo 'started' > log.out ; sleep $(($RANDOM/1000)) ; echo 'finished' >> log.out ; }
> ~~~
> {: .language-bash}
>
> Tracking the current status of the program can be done using `tail`, e.g.:
> ~~~
> sleeptest &
> tail -n  1 log.out
> ~~~
> {: .language-bash}
> ~~~
> started
> ~~~
> {: .output}
> Using the `-n 1` flag tells `tail` to only return the last line of the file.
>
> Can you fill the three gaps in this `while` loop, so that it exits once the sleeptest
> function has ended?
> ~~~
> sleeptest &
> finished_tasks=0
> job_limit=1
> while [[ $finished_tasks ____ $job_limit ]]; do
>   sleep 3
>   finished_tasks=0
>   log_tail=$(______)
>   if [[ ______ ]]; then
>     echo "finished a task"
>     ((finished_tasks+=1))
>   else
>     echo "still going"
>   fi
> done
> ~~~
> {: .language-bash}
> > ## Solution
> > ~~~
> > sleeptest &
> > finished_tasks=0
> > job_limit=1
> > while [[ $finished_tasks -lt $job_limit ]]; do
> >   sleep 3
> >   finished_tasks=0
> >   LOG_TAIL=$( tail -1 log.out )
> >   if [[ $LOG_TAIL == "finished" ]]; then
> >     echo "finished a task"
> >     halt=yes
> >     ((finished_tasks+=1))
> >   else
> >     echo "still going"
> >   fi
> > done
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}
