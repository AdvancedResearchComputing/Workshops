# Chaining Commands Together:  Piping

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



#### Overview

Piping is a mechanism to "chain" commands together.
You can think of it as a compound statement.

Piping is a major concept.
Not just in Unix/Linux.
It is a dominant __ARCHITECTURE__ pattern, see the first volume of a 3-volume set
by Schmidt and others in [Pattern Book Vol. 1](https://www.amazon.com/Pattern-Oriented-Software-Architecture-System-Patterns/dp/0471958697/ref=pd_lpo_d_sccl_1/134-6123281-9556922?pd_rd_w=O6iYk&content-id=amzn1.sym.4c8c52db-06f8-4e42-8e56-912796f2ea6c&pf_rd_p=4c8c52db-06f8-4e42-8e56-912796f2ea6c&pf_rd_r=DVEPNAFEQF40BC5EP9EW&pd_rd_wg=qoIaT&pd_rd_r=ad2fcb5f-0631-499d-94cf-59b3aa6bc1c7&pd_rd_i=0471958697&psc=1)

For our purposes here, there are only a couple of things to remember:
1. The individual commands in the sequence of commands
are separated by `|`, i.e., the pipe symbol.
2. The output of the current command becomes the input for the next command.
3. Because of #2, there is no input specified for the second and all subsequent
commands (input is specified only for the first command).
4. There is no practical limit for the number of commands to pipe.


#### Data Files

We will use the following data, in file _company.data_ for a few companies in several examples.


~~~data
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
~~~


We call each column of the file above a "field."
Often, files have headers (i.e., names) for the fields;
this file does not.


Here is our data file, _sports.data_.

~~~data
What is the greatest sport?
NFL      football.
What is the worst sport?
That is easy:     golf.
Is that even a sport?
~~~


A third data file, _mynumbers.data_ is

~~~data
10
80
10000000
8051
805
20006
~~~

A fourth data file, _mynumbers2.data_ is

~~~data
10           73
80           92
10000000     3
8051         973
805          1342
20006        793
~~~




#### Example  `Piping`:  Putting `head` and `tail` Together

We take two individual commands:

1.  `head -n 5 company.data`
2.  `tail -n 1 company.data`

These two commands, respectively, give us the first five lines of company.data
and the last line of company.data.

Now we give an example where we using piping to sequence these commands to
get a totally different result.

Suppose I want to print the fifth line of the file _company.data_.

Here are two ways to do it.

Option 1.

This approach is more natural and reproducible (it is used frequently).

~~~bash
head -n 5 company.data | tail -n 1
~~~


Note that there is no input specified for the second (i.e., `tail`) command.
Its input is the output from the first (i.e., `head`) command.

The output is:

~~~bash
dq          ice_cream     restaurant     national            3560
~~~


Option 2.

This approach is less natural because you have to know how many
lines are in the file.  It is pretty awkward, actually.


~~~bash
tail -n 3 company.data | head -n 1
~~~

The output is:

~~~output
dq          ice_cream     restaurant     national            3560
~~~


#### Example:  More Than One Pipe


Please do not be fooled by the short length of this section.
These commands are used a lot, and are used in combination
with other commands.
For example, suppose some file has one million lines and
each line contains 75 numbers.
So the file has 75 columns of data.
We want to know the min and max values of column 7.
We can do these steps:
1. Use `awk` to get column 7 numbers.
2. Use the `sort` command, we can sort the result based on column 7.
3. Use `head` to get the first line and hence the min value of column 7.
4. Use `tail` to get the last line and hence the max value of column 7.


We will use the `mynumbers2.data` file to illustrate, where we are
interested in the values in column 1.

~~~bash
echo " the min value of column 1 of file mynumbers2.data:"
awk '{print $1}' mynumbers2.data  | sort -n | head -n 1

echo " "
echo " the max value of column 1 of file mynumbers2.data:"
awk '{print $1}' mynumbers2.data  | sort -n | tail -n 1
~~~


The output is

~~~output
 the min value of column 1 of file mynumbers2.data:
10
 
 the max value of column 1 of file mynumbers2.data:
10000000

~~~




#### Example:  Piping with `grep`

Suppose you want to know the types of restaurants in the company.data file.

You can:
1. first find all restaurants.
2. print the type of restaurants.

The command is:

~~~bash
grep "restaurant" company.data | awk '{print $2}' 
~~~


This gives us:

~~~output
fast_food
ice_cream
~~~

#### Example:  Piping with `ls` to Count Occurrences


If you want to know how many files and directories and symbolic links are in the current directory, one can issue:

~~~
ls * | wc -l
~~~
{:  .language-bash}


The “ls *” lists all of the files, directories, and symbolic links. This listing goes into “word count” (wc) program as input and wc counts the number of entries.

The output of a successful command will be an integer.

The files sought can be specialized or tailored, for example, in finding the files with extension “txt.”

~~~bash
ls *.txt | wc -l
~~~


#### Example:  Piping to Determine Number of Occurrences in a File

We might want to know how many lines have _international_
in them at least once.

The command is:

~~~bash
grep international company.data  | wc -l
~~~


This command uses piping:  we take the output of the first part of the
command, `grep international company.data`, which is given above,
and we put it into the
second command `wc -l`, which counts the number of lines.

The output is:

~~~
5
~~~
{:  .output}

This is consistent with the previous `grep` command, which
generated five lines of output.

