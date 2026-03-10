# Control Structures:  FOR Statement

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



## `for` Loops

For loops iterate through a block of code a user-specified (maximum) number of times.
Typically, the number of iterations is the maximum specified,
but your inner block of code may have "checks" in it that might
prematurely exit you out of the loop.


As well as looping through arrays directly, we can also write loops which iterate through
series of integer values, which can then be used as indexes. This can be useful if you need
to add or remove matching data from a series of arrays, etc.

Two methods can be used to do this. The first is to use the `seq` command to build a
sequence of integer values, e.g.:
~~~
seq 4
~~~
{: .language-bash}

The universal format for this command is `seq [first] [increment] last`, where the last
value must be defined, but the incremental value is optional, as is the first value (but
this must be defined if the incremental value is defined). Note that other options can be
added, but these will be system-specific, and wont be covered here. The default values for both
the start and incremental values are 1. The sequence will be built according to these rules,
starting at the first value, and continuing until the next value created would greater than
the last value.

So `seq 4` means the code block inside the "for" loop will be executed four
times:  1, 2, 3, and 4.

> ## sequences
>
> Please create a sequence of every 4th number between 3 and 37. Then create a sequence
> of these same numbers in reverse.
>
> > ## Solution
> >
> > `seq 3 4 37`
> >
> > `seq 35 -4 3` (Note: because `seq` starts from the first number given, you have to use
> >  _a priori_ knowledge to ensure that this sequence is the exact reverse of the
> >  first sequence).
> >
> {: .solution}
{: .challenge}


> ## real number maths
>
> Although we are not interested in this feature for the purposes of indexing arrays, it
> should be noted that `seq` uses real numbers, not integers, and so more complex sequences
> of numbers can be created than are shown here.
>
{: .callout}

To use `seq` within a `for` loop we must execute the command within it's own subshell, e.g:
~~~
for i in $(seq 1 7); do
  echo $i
done
~~~
{: .language-bash}


~~~
1
2
3
4
5
6
7
~~~
{: .output}


The next two code segments generate the same output
as the code immediately above.
Just different ways to write the source code.

You can also put the most recent group of commands from the for loop, all on one line.
Ordinarily, in a source code file, you do not want to do this because
readability of your code suffers, and that is important.
But if you are pasting lines of code into a terminal window, at the
shell prompt, one-liners like the one below can be useful.

~~~
for i in $(seq 1 7); do   echo $i; done
~~~
{: .language-bash}



Trying to do this (i.e., `$(seq 1 7)`)
without the subshell will simply cause your loop to iterate through the
set of strings `seq 1 7`.

One can also write the `do` keyword on a separate line, to match up with `done`, and
in this case, no semi-colon is used.

~~~
for i in $(seq 1 7)
do
  echo $i
done
~~~
{: .language-bash}


These integer values can be used for referencing items within an array---but do remember
that bash array indexes start at 0, and adjust your `seq` command accordingly:
~~~
varlist=( a list of strings )
for i in $(seq 0 3); do
  echo ${varlist[$i]}
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


> ## Indexing lengths
>
> Because our index starts from 0, we must remember to end our loop at length-1.
> Not doing this in bash is unlikely to give a fatal error (unlike other, stricter,
> programming languages, for which it would cause a buffer overrun), but the empty
> string which is returned could cause issues for your workflow if you are not expecting
> it.
>
{: .callout}


`For` loops can be constructed using C-style notation too. These use a set of three
expressions (start conditional; end conditional; increment conditional) within a math
context, e.g:
~~~
varlist=( a list of strings )
for (( i=0; i<4; i++ )); do
  echo ${varlist[$i]}
done
~~~
{: .language-bash}

This generates the same output as the previous code block.


> ## C-style integer increments
>
> The code `(( i++ ))` increments the value of variable i by one, equivalent to using
> `(( i+=1 ))` or (more explicity) `(( i=$i+1 ))`. Negative increments can be performed
> by using `-` instead of `+`.
>
{: .callout}


~~~
g=13
for (( i=0; i<4; i++ )); do
  (( g++ ))
  echo ${g}
done
~~~
{: .language-bash}

The output is:

~~~
14
15
16
17
~~~
{: .output}




> ## Looping through arrays without predetermined length
>
> Often we want to loop through arrays without a predetermined number of elements, so
> is useful to not have to hard-code the end number into the for loop.
>
> 1) Remembering that you can get the length of an array using `${#array[@]}`, and that
> integer maths should be carried out within an arithmetic expansion (`$(( ))`), please
> adapt the `seq` loop above so that it determines the array length automatically, and
> uses that within the for loop.
>
> 2) Please do the same using the C-style notation loop.
>
> 3) Please adapt the C-style notation loop to run through the array in reverse order.
>
> > ## Solutions
> >
> > 1)
> > ~~~
> > varlist=( a list of strings )
> > len=${#varlist[@]}
> > endvalue=$(($len-1))
> > for i in $(seq 0 $endvalue); do
> >   echo ${varlist[$i]}
> > done
> > ~~~
> > {: .language-bash}
> >
> > 2)
> > ~~~
> > varlist=( a list of strings )
> > len=${#varlist[@]}
> > for (( i=0; i<$len; i++ )); do
> >   echo ${varlist[$i]}
> > done
> > ~~~
> > {: .language-bash}
> >
> > 3)
> > ~~~
> > varlist=( a list of strings )
> > len=${#varlist[@]}
> > endvalue=$(($len-1))
> > for (( i=$len-1; i>=0; i-- )); do
> >   echo ${varlist[$i]}
> > done
> > ~~~
> > {: .language-bash}
> >
> >
> > Note: the lines creating variables `len` and `endvalue` could be incorporated directly into
> > the for loop statements, but they are explicitly stated here to make the solutions more
> > readable.
> >
> {: .solution}
{: .challenge}

