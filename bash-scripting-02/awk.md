# awk Utility

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)

#### Overview

Given a data file, one often wants to extract a subset of rows or columns
from the data, possibly based on a search of the data.
Another need is to reformat data in a file.
`awk` can be used to accomplish these and other tasks.

[awk](https://https://www.gnu.org/software/gawk/) is a
utility that interprets a special-purpose programming language that
makes it possible to handle simple data-reformatting jobs.


https://www.geeksforgeeks.org/awk-command-unixlinux-examples/

#### Basic Command

The basic format of an `awk` command is:

~~~bash
awk options 'selection _criteria {action}' input-file > output-file
~~~


#### Disclaimer About Redirecting Output File(s) For All Examples

In the examples below, we will omit the "> output-file" but this can be
added to the end of every command below to write the results
to file output-file, instead of to the terminal, as is done now.

#### Base data file that will be manipulated

We will use the following data, in file `company.data`,
for a few companies, in several examples.


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

`awk` uses 1-indexing to identify columns.
That is, the first column, with "xerox" at the top,
is column 1 (not column 0), and is referenced by $1.
Similarly the column with "international" at the top is
identified with index $4.

#### Variable `$0`

Note that variable `$0` contains the entire contents of a line.


### Print contents of a file


To print the contents of the data file, do

~~~bash
awk '{print}' company.data
~~~


which generates this output:

~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
~~~

One could more easily use `cat company.data`.



#### Print a subset of lines of the data file


To print all lines of the file that are restaurants 
(more precisely, print all lines that have the string "restaurant" in them):

~~~bash
awk '/restaurant/ {print}' company.data
~~~


which generates this output:

~~~output
mcdonalds   fast_food     restaurant     international   11000000
dq          ice_cream     restaurant     national            3560
~~~


One could execute the following, because `$0` means "the entire line":

~~~bash
awk '/restaurant/ {print $0}' company.data
~~~


One could also invoke `grep restaurant  company.data`
... but that is another story.


#### Print a Subset of Fields of the Subset of Lines of the Data File


To print only the names of the restaurants, we
print only the values in column 1 (via the `print $1`)
of lines that have "restaurant".

~~~bash
awk '/restaurant/ {print $1}' company.data
~~~


which generates this output:

~~~output
mcdonalds
dq
~~~



#### Print a Subset of Fields of the Subset of Lines of the Data File With Extra Characters

To print only the names and the business focus of the restaurants,
with characters (in this case, "  \*--\*  ") in between,

~~~bash
awk '/restaurant/ {print $1  "  *--*  "  $2}' company.data
~~~


which generates this output:

~~~output
mcdonalds  *--*  fast_food
dq  *--*  ice_cream
~~~



#### Print Only The Unique Values of a Field

To print only the unique industries of the companies,

~~~bash
awk '{a[$3]++} END{for(b in a) print b}'  company.data
~~~


which generates this output:

~~~output
restaurant
energy
business
~~~


Here, all of the values in column 3 are put into a map as keys,
where keys in (key, value) pairs are unique.
Then, the `END` keyword means that AFTER all values in column 3 are put into a map,
which only stores unique values,
i.e., after all of the rows are processed,
the FOR loop is executed.




#### Prepend the Line Number to the File's Data, Using Keyword NR


To print each line in full, but also prepending each line
with a line number,

~~~bash
awk '{print NR,$0}' company.data
~~~


which generates this output (line numbers in first column):

~~~output
1 xerox       copying       business       international    6000000
2 exxon       oil           energy         international   10000000
3 mcdonalds   fast_food     restaurant     international   11000000
4 chevron     oil           energy         international    5200000
5 dq          ice_cream     restaurant     national            3560
6 pge         natural_gas   energy         national           35640
7 hp          printers      business       international     456340
~~~


Here, the `NR` is a running count of the number of lines read in
and `$0` means the entire line.


#### Printing a range of lines of a file


To print a range of lines (here, lines 3 through 6 inclusive),

~~~bash
awk 'NR==3, NR==6 {print NR,$0}' company.data
~~~


which generates this output:

~~~output
3 mcdonalds   fast_food     restaurant     international   11000000
4 chevron     oil           energy         international    5200000
5 dq          ice_cream     restaurant     national            3560
6 pge         natural_gas   energy         national           35640
~~~


Here, `NR` is used to specify bounds on the line numbers.



#### Printing data resulting from two operations

To print a range of lines (here, lines 3 through 6 inclusive)
but only those lines whose business is energy
(no, it is those lines that have energy ANYWHERE in them;
there is no logic saying where "energy" must appear),
we first obtain the desired lines using the first `awk`
command (the one on the left), and then we send or "pipe"
those results (indicated by the pipe symbol "|") into the
`awk` command to keep only those lines where "energy" appears.

~~~bash
awk 'NR==3, NR==6 {print NR,$0}' company.data  | awk '/energy/ {print $0}'
~~~


which generates this output:

~~~output
4 chevron     oil           energy         international    5200000
6 pge         natural_gas   energy         national           35640
~~~



The first part of the command is the same as the previous command.
Then, we use the "pipe'' (i.e., "|") to send the output from this
first part to the second part, where only lines with "energy" are
printed.

We will look at piping more in a later episode.

The above result can also be obtained from:

~~~bash
awk 'NR==3, NR==6 {print NR,$0}' company.data  | grep energy
~~~

We will look at `grep` more closely later.



#### Performing Numerical Comparisons

Comparisons can be made, and only those lines whose comparisons
are true, are printed.

~~~bash
awk '$5 > 1000000' company.data
~~~

which generates this output:

~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
~~~



#### Performing multiple comparisons


Comparisons of values between upper and lower bounds can
be made, using the AND operator (i.e., "&&"),
and only those lines whose comparisons
are true, are printed.

~~~bash
awk '$5 > 100000 && $5 < 1000000' company.data
~~~

which generates this output:

~~~output
hp          printers      business       international     456340
~~~


#### Convert a file's contents to a different format

Convert the file from a (multi) space separated file to
a CSV (comman separated value) data

~~~bash
awk -v OFS=',' '{$1=$1; print}' company.data
~~~

which generates this output:

~~~output
xerox,copying,business,international,6000000
exxon,oil,energy,international,10000000
mcdonalds,fast_food,restaurant,international,11000000
chevron,oil,energy,international,5200000
dq,ice_cream,restaurant,national,3560
pge,natural_gas,energy,national,35640
hp,printers,business,international,456340
~~~


The `-v` flag takes as its first argument a comma separated list of variable_name=value pairs.


This command is anything but obvious.
The assignment to element 1 of each line, via the
$1=$1 assignment causes $0, the entire line, to
be reconstructed using OFS (i.e., using the comma).
That is, the output file separator (OFS) being assigned
a comma reconstructs the line, $0, with the separator.

Second example:  we want precisely one blank space between 
consecutive entries on a line (instead of commas).

~~~bash
awk -v OFS=',' '{$1=$1; print}' company.data  | awk -F',' -v OFS=' ' '{$1=$1; print}'
~~~


We are using piping again with the`|` symbol.
The first `awk` creates the CSV file.  That result gets inputted to the second 
command (notice that there is no filename) and `-F','` means read the data as CSV
(which is the output of the first command) and output it with a space separating
consecutive values.



This can be a drawback for all bash and tool commands
used in this workshop:  the ability to be so terse.


**REMEMBER:  conciseness is not always great; readability
and comprehension are more important.**




