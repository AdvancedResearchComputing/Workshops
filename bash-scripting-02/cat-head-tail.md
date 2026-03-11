# Accessing Portions of File Contents:  cat and head and tail

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


#### `cat` Command

`cat` is short for concatenate or concatenation.

You can use `cat` to:

1. concatenate (i.e., join) files together
2. display contents of a file.


Given the above files reside in your current directory, you can 
issue any of:

~~~bash
cat company.data
cat sports.data
cat mynumbers.data
cat mynumbers2.data
~~~


Issuing the last command (i.e., the last line of the four lines immediately above) gives:

~~~output
10           73
80           92
10000000     3
8051         973
805          1342
20006        793
~~~


To redirect the output to a file, one simply uses the `>` symbol.
Here we concatenate the first two files above and store the result
in file `combine.data`.

~~~bash
cat company.data  sports.data  > combine.data
~~~

`combine.data` now contains


~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
What is the greatest sport?
NFL      football.
What is the worst sport?
That is easy:     golf.
Is that even a sport?
~~~




#### `head` Command

List the first lines of a file.

The `-n` switch specifies the number of lines.
The default is 20 lines.


~~~bash
head -n 3 sports.data
~~~



Output is

~~~output
What is the greatest sport?
NFL      football.
What is the worst sport?
~~~


The `-v` flag is useful when issuing a command on multiple
files, since it causes the filename to be written above the
data for that file.

~~~bash
head -v -n 5 company.data  mynumbers.data sports.data
~~~



Output is

~~~output
==> company.data <==
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560

==> mynumbers.data <==
10
80
10000000
8051
805

==> sports.data <==
What is the greatest sport?
NFL      football.
What is the worst sport?
That is easy:     golf.
Is that even a sport?
~~~



By contrast, the `-q` (quiet) switch will suppress the filenames when
multiple filenames are specified.

~~~bash
head -q -n 5 company.data  mynumbers.data sports.data
~~~


Output is

~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
10
80
10000000
8051
805
What is the greatest sport?
NFL      football.
What is the worst sport?
That is easy:     golf.
Is that even a sport?
~~~




#### `tail` Command

List the last lines of a file.

The "count" of lines starts from the last line, and works
up the file.
So, to see just the last line of file "hog" one writes `tail -n 1 hog`.


The `-n` switch specifies the number of lines.


~~~bash
tail -n 2 sports.data
~~~



Output is

~~~output
That is easy:     golf.
Is that even a sport?
~~~


The same sorts of commands used above for `head` can also
be used for `tail`.





