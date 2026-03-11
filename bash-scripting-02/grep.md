# Searching For Strings in a File:  grep

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)

#### Base Data File that will be Manipulated

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

`grep` is a lot like `awk` in that you can search for
strings in a file.

But whereas `awk` is used a lot for columnar data, `grep`
is often used for free-form text, i.e., the
data are not typically associated with a column.
Grep is easier for courser-grained searches.

Searches within grep by default are CASE SENSITIVE.
There is a way to relax this.

#### Syntax

~~~bash
grep  <switches>  <search string>  <file>   [> output_file]
~~~


#### Example:  Basic

Search for all occurrences of "international" in file "company.data".

~~~bash
grep international company.data
~~~


Output is all lines where the character string _international_ appears
at least once.


~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
hp          printers      business       international     456340
~~~


What is output with this command?

~~~bash
grep national company.data
~~~

#### Example:  Search For Strings That Only Start At Beginning Of Line


We might want to search for strings that appear at the beginning
of a line.
In this case, we use the carrot symbol, `^`.
We search for all lines that start with "e".


~~~bash
grep ^e company.data
~~~


There are many lines with an _e_ in them, but only one line that
starts with an _e_.
Output is

~~~output
exxon       oil           energy         international   10000000
~~~

#### Example:  Search For Strings That Exist Only At End Of Line


We might want to search for strings that appear at the end
of a line.
In this case, we use the dollar symbol, `$`.


~~~bash
grep 560$ company.data
~~~


There are many lines end with _0_, but only one line that
ends with an _560_.
Output is

~~~output
dq          ice_cream     restaurant     national            3560
~~~


#### Example:  Search With Case IN-Sensitivity ... and ... Print Line Numbers

We might want to know the line numbers of the occurrences of
our search string; we use the `-n` flag for this.
We might want to perform a search that is case insensitive;
we use the `-i` flag.


~~~bash
grep -n  -i ^nfl  sports.data
~~~


Note that the output is not changed to lower case, as in
the search string.
The output is pre-pended with the line number,
in this case _2_.

Output is

~~~output
2:NFL      football.
~~~


#### Example:  Finding Lines That Do NOT Match


Finding the complement of a pattern is often used.

I want all of the lines that do NOT contain _sport_ in _sports.data_


~~~bash
grep -v "sport"  sports.data
~~~



Output is

~~~output
NFL      football.
That is easy:     golf.
~~~