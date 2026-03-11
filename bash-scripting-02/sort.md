# Sorting Data:  Sort

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



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



#### Overview

SORT command is used to sort a file, arranging the records in a particular order. By default, the sort command sorts file assuming the contents are ASCII. Using options in the sort command can also be used to sort numerically.

- SORT command sorts the contents of a text file, line by line.
- sort is a standard command-line program that prints the lines
of its input or concatenation of all files listed in its argument list in sorted order.
- The sort command is a command-line utility for sorting lines of text files.
- It supports sorting alphabetically, in reverse order, by number, by month, and can also remove duplicates.
- The sort command can also sort by items not at the beginning of the line, ignore case sensitivity,
and return whether a file is sorted or not.
- Sorting is done based on one or more sort keys extracted from each line of input.
- By default, the entire input is taken as the sort key. Blank space is the default field separator.

(The above is taken from [https://www.geeksforgeeks.org/sort-command-linuxunix-examples/](https://www.geeksforgeeks.org/sort-command-linuxunix-examples/).)


Some useful switches are:

|  Options | Description  |
| --------- | ----------- |
| -o      | Specifies an output file for the sorted data. Functionally equivalent to redirecting output to a file.|
-r    | Sorts data in reverse order (descending).
-n  |  Sorts a file numerically (interprets data as numbers).
-nr  |  Sorts a file with numeric data in reverse order. Combines -n and -r options.
-k  |   Sorts a table based on a specific column number.
-c | Checks if the file is already sorted and reports any disorder.
-u | Sorts and removes duplicate lines, providing a unique sorted list.
-M  |  Sorts by month names.


#### Example:  Sorting a text file based on first letter of each line

~~~bash
sort company.data
~~~

produces:

~~~output
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
exxon       oil           energy         international   10000000
hp          printers      business       international     456340
mcdonalds   fast_food     restaurant     international   11000000
pge         natural_gas   energy         national           35640
xerox       copying       business       international    6000000
~~~



#### Sorting hierarchy:  lower case vs. upper case

Use the apple.data file, whose contents are:


~~~data
apPle
apple
Apple
appLe
applE
~~~


We sort the contents of this file.

~~~bash
sort apple.data
~~~

producing:

~~~output
apple
applE
appLe
apPle
Apple
~~~


And we see that lower case is "before" upper case.


Now onto numbers.


#### Example:  Sorting Numbers---As Strings

Numbers are not processed as numbers unless
the appropriate switch is used with the `sort` command.
The default is that numbers are treated as strings.


~~~bash
cat mynumbers.data
~~~


lists the contents of the file:

~~~
10
80
10000000
8051
805
20006

~~~
{: .output}

**Using `sort` with no command options results
in numbers ordered by character, as strings
or characters are ordered.**


~~~bash
sort mynumbers.data
~~~

produces:

~~~output
10
10000000
20006
80
805
8051
~~~
{: .output}


#### Example:  Sorting Numbers---As Numbers


Now sort by numerical value.

~~~bash
sort -n mynumbers.data
~~~


produces numbers in increasing order, as expected:

~~~output
10
80
805
8051
20006
10000000
~~~


Repeat the command in sorting by numerical value,
but send results to file.

~~~bash
sort -n mynumbers.data  -o sorted.output.numbers.out
~~~

You can also redirect output:

~~~bash
sort -n mynumbers.data  > sorted.output.numbers.out
~~~


Viewing the contents of the file:

~~~bash
cat sorted.output.numbers.out
~~~

Numbers are in increasing order, as expected.

~~~output
10
80
805
8051
20006
10000000
~~~


#### Example: Sorting Multiple Columns

We will now use _company.data_ to
sort multiple columns, alphabetically, in the prescribed order:
column 4, then column 3, and then column 2.
This means, for example, that if two rows have the same entry in column 4,
then they will be ordered based on their ordering for column 3.
If their column 3 values are the same, then they will be ordered based
on their column 2 ordering.

The switch `-k` is used to specify columns.

Consider the command

~~~bash
sort  -k4,4 -k3,3 -k2,2 company.data
~~~

The columns are specified with two column numbers, separated by `,`
because the syntax for specifying a column is `-k<first column>,<last column>`
so for sorting only on column 4, the command is `-k4,4`.

The heirarchy of commands is the columns in order of appearance in
the command, so rows are sorted on column 4 first, then column 3,
and then column 2.

And the output is

~~~output
exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000
xerox       copying       business       international    6000000
hp          printers      business       international     456340
mcdonalds   fast_food     restaurant     international   11000000
pge         natural_gas   energy         national           35640
dq          ice_cream     restaurant     national            3560
~~~



In column 4, _international_ comes before _national_.
In column 3, for column 4 being _international_,
_business_ should come before _energy_, but it does not.

What is wrong?  It is the different number of blanks
between words.
It screws things up.

But we have an approach.
In the _awk_ page, we generated a file with the company.data data
where only one blank is placed between entries on a line;
not the variable number of blanks.
This is file _company.one.data_ below:


~~~output
xerox copying business international 6000000
exxon oil energy international 10000000
mcdonalds fast_food restaurant international 11000000
chevron oil energy international 5200000
dq ice_cream restaurant national 3560
pge natural_gas energy national 35640
hp printers business international 456340
~~~


... then 

~~~bash
sort  -k4,4 -k3,3 -k2,2 company.one.data
~~~

produces the output that we want:

~~~output
xerox copying business international 6000000
hp printers business international 456340
chevron oil energy international 5200000
exxon oil energy international 10000000
mcdonalds fast_food restaurant international 11000000
pge natural_gas energy national 35640
dq ice_cream restaurant national 3560
~~~


Now, "business" comes before "energy" in column 3 of rows 1-4, for column 4
being "international."
Also, in the first two rows, "copying" comes before "printers"
for column 3 being "business" and column 4 being "international."