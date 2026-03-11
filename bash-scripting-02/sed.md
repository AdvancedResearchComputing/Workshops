# sed Utility

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)

#### Overview

Workflows often require the editing of configuration files or scripts, or the searching of
these for specific information to copy. This lesson will introduce a tool for editing
files, as well as regular expressions, which can be used to make your searches more
powerful.
Additional power is provided because once your search is complete, sed can be
used to act on those search results.

[Sed](https://www.gnu.org/software/sed/manual/sed.html) is a stream editor. It can be used
to perform basic text transformations on an input stream, which can be a file, or it can
be passed from a pipeline, allowing it to be combined with other tools.


#### Disclaimer

Below in the examples, we have substitution specifications such as `'s/hello/world/'`
and `'s/goodbye/world/'` and `'s/l/a/'` and `'s/[HW]/J/g'`.
Instead of the single quotes surrounding the substitute, s, string,
I use double quotes so that variables and their values will be
interpreted correctly.
For example, the last example would be `"s/[HW]/J/g"` instead of `'s/[HW]/J/g'`.

#### Basic Syntax

~~~bash
sed s/<existing string>/<replacement string>/[g|c]
~~~

where:
- "g" means replace globally throughout document.
- "c" means replace one instance at a time, and get confirmation from user on each
  such instance.

#### Examples


To demonstrate the basic usage of sed, we will create a text file (`input.txt`)
containing the string
`hello`, and use sed to change this to `world`.

The first line uses the "redirection" operator `>` to take the output
from the `echo` command, which would be a "print" of "hello" to the terminal screen,
and redirect it into the file "input.txt".

The second line then takes as input the just-made file, and substitutes "world"
for "hello" (for the first occurrence of "hello") in the file's content.

The "output" below is written to screen, which is also the default for `sed`.
Note that the content of the file "input.txt" remains unchanged from
line 2.

~~~bash
echo hello > input.txt
sed -e "s/hello/world/" input.txt
~~~


~~~output
world
~~~


The `-e` flag indicates that the first parameter (`s/hello/world/`) is a script to be
applied to the stream, while the following non-option parameters (`input.txt`) are input
files.
The `-e` flag also tells `sed` to make the changes _in place_ so that if there are multiple substitutions
(see below, where we'll do this),
then all of the substitutions are made in composing the output string/stream.
Sed will, by default, print all the processed input, so that it can be saved for later use,
if you redirect the output into a file.
Below, we do this with the redirection operator `>` again, as we did above,
but now we are writing the output of the `sed` command to file "output.txt".

~~~bash
sed -e "s/hello/world/" input.txt > output.txt
~~~



The script we are using here is a substitution (indicated by the `s` at the start of the
script). The first string (`hello`) is what is being searched for, while the second string
(`world`) is the string that will be used as a replacement.

Sed can be passed multiple inputs, it will treat these as a single stream:

~~~bash
echo goodbye > input_pt2.txt
sed -e "s/goodbye/world/" input.txt input_pt2.txt
~~~


~~~output
hello
world
~~~


It can also be passed multiple scripts, which will be run in sequential order:
~~~bash
sed -e "s/goodbye/world/" -e "s/l/a/" input.txt input_pt2.txt
~~~

~~~output
healo
worad
~~~


You will note that the second (and first) substitution strings
have been applied to both of the input
files, but only one `l` has been replaced in "hello," which is the content
of file "input.txt."
This is because the search was not global, that
is, as soon as one match string is found it is replaced, and then
this substitution process, on this file, is completed, and
consequently, sed moves onto the next script.

If you want to replace *all* matching strings, then you need to specify that a script
should be applied globally, by appending a `g` at the end of
the substitution string that begins with `s/`, e.g.:

~~~bash
sed -e "s/goodbye/world/" -e "s/l/a/g" input.txt input_pt2.txt
~~~


~~~output
heaao
worad
~~~


Rather than search the whole input for match you can, if you know the exact line you wish
to process, specify a line number (in this case, line 2):

~~~bash
echo 'hello' > input_lines.txt
echo 'hello' >> input_lines.txt
sed "2 s/hello/world/" input_lines.txt
~~~


~~~output
hello
world
~~~


Note that sed starts indexes from 1, not 0.


#### Providing Scripts Via a File

Sed allows the use of a file for providing the scripts for processing your files. This
file should contain one script per line, and passed using `-f` instead of `-e`, e.g.:


~~~bash
echo "s/goodbye/world/" > myscript.sed
sed -f myscript.sed input.txt input_pt2.txt
~~~


~~~output
hello
world
~~~






#### Regular Expressions

Grep uses regular expressions (often abbreviated to _regex_),
sequences of characters which define the string(s) to be searched for. Sed uses the same
regex patterns for it's searches, and we will cover some basic principles of using these
here.

#### Regex Syntax and Interoperability

Regular expressions are implemented in a number of different programming languages.
These all follow similar rules, but there will be differences, often subtle, between
each of these implementations.

Many implementations follow the feature-rich regex syntax that was developed first for
the Perl language.
However UNIX command line programs tend to use the older 'POSIX' regex
standards. These are further split into the POSIX Basic (BRE) and POSIX Extended Regular
Expression (ERE) standards. Below we will teach you the ERE standard, because this has
a more readable syntax which is closer to that of the more modern regex implementations.
More information on the difference between the two POSIX standards can be found
[here](http://www.regular-expressions.info/posix.html).

To use ERE in sed the `-E` flag must be used.


#### When sed Characters are Needed in Text

There are characters that are used by sed to perform operations.
Two of them are `.` and `/`.
To use them for text needs, i.e., you need to print a forward slash (/), 
you need to "escape them" using the `\` (backslash) key.


Regular expressions rely on the use of literal characters and metacharacters to construct
the search term. Metacharacters are characters which have a special meaning (such as `.`
represents any single character). If you wish to search for a literal character which
happens to be a regex metacharacter, then it will need to be "escaped," that is, preceded
by a `\` character. For example to change a period to an ellipsis:

~~~bash
echo "Hello. World" > input.txt
sed -E -e 's/\./.../' input.txt
~~~


~~~output
Hello... World
~~~

Another example:  say you want to replace in text every occurrence of three consecutive
forward slashs (/) with three dashes (---), and write the resulting text
to an output file named my_output.  Then

~~~bash
sed "s/\/\/\//---/g" input.file  > my_output
~~~


One of the most common patterns used in regex is the definition of a list or range of
characters, which can be denoted using square brackets. E.g.:

~~~bash
sed -E -e "s/[HW]/J/g" input.txt
~~~


~~~output
Jello. Jorld
~~~


#### Using Multiple Characters in Substitutions

This list of upper case characters to replace is very focused, but if you did not know in
advance what the upper case characters would be you can use the list `[A-Z]`. Similarly,
to replace all lower case letters use the list `[a-z]`, and to replace any digit us
`[0-9]`. These can be combined as you require, for example, to match all characters (of
any case) between B and H you would use `[B-Hb-h]`.

Examples.  The original string is `Hello. World` in file _input.txt_.

To produce this output `Halla. Warld`, you would use the command

~~~bash
sed "s/[eo]/a/g"  input.txt
~~~

To produce this output `Heno. Worn`, you would use the command

~~~bash
sed "s/l[ld]/n/g"  input.txt
~~~


#### Matching Repeated Instances

It can be useful to match more, or less, than a single instance of a particular element in
the search string. This can be done by adding one of these special characters:
- `*` matches the preceding element zero or more times
- `+` matches the preceding element one or more times
- `?` matches when the preceding element appears zero or one time
- `{VALUE}` matches the preceding element the specified number of times defined by `VALUE`;
ranges can be defined by `{VALUE,VALUE}`

The elements that these can be used on can be either single characters, or sets of
characters. E.g.:

~~~bash
sed -E -e "s/l{2}o/n/g" input.txt
~~~


~~~output
Hen. World
~~~


This is particularly useful for changing date strings, e.g.:

~~~bash
YEAR=2021
sed -E -e "s/[0-9]{4}/${YEAR}/g" <(echo 'the date is: 23-04-2020')
~~~


~~~output
the date is: 23-04-2021
~~~


Here we change the date to that set in a previously set variable (note the use of double
quotation marks, so that the shell will interpret the string and replace the variable name
with the required value).


#### Matching Line Endings

The `^` and `$` metacharacters can be used to respectively assert the position of the
start or end of a line. This allows you to "anchor" your search at either end of a line.
For example, if we are provided with a YEAR variable which only contains the last two
digits, but we know that the year digits will always be at the end of the line, we can
search for `[0-9]{2}` without risking changing the day or month:

~~~bash
YEAR=21
sed -E -e "s/[0-9]{2}$/${YEAR}/g" <(echo 'the date is: 23-04-2020')
~~~

~~~output
the date is: 23-04-2021
~~~


#### Back References and Subexpressions

We will skip this.

A back-reference is a regex command which refers to a previous part (or subexpression) of
the matched regular expression. They can be used to repeat patterns within a regex search
or, as we will do here, pass part of the matched regex forward to the replacement string.
Back references are specified by a single escaped digit (e.g. `\1`; up to nine are allowed
in a single regex), while the subexpression is indicated using `()` brackets.

A common use of these is pulling out a single element of the search, e.g. the year from a
date string:

~~~bash
date | sed -E -e "s/^.*([0-9]{4}).*$/\1/g"
~~~

~~~output
2021
~~~

Note how the 4-digit year is stored in a subexpression, while the strings before and after it are included in the match using `^.*` and `.*$`.


#### BASH Logic and Regex

In the logic and maths lesson you were introduced to the `[[ ]]` command, which is used
for logical control structures. This command also allows regex patterns to be used,
checking to see if a given string matches the regex or not. This comparison is performed
using the `=~` operator. For example:

~~~bash
YEAR=1999
if [[ $YEAR =~ ^[0-9]{2}$ ]]; then
  echo "year is in 2 digit format"
elif [[ $YEAR =~ ^[0-9]{4}$ ]]; then
  echo "year is in 4 digit format"
else
  echo "year is in unrecognized format"
fi
~~~

~~~output
year is in 4 digit format
~~~



Note that the `^` and `$` metacharacters have been used to ensure the pattern matches the
whole string, and that no partial matches are made by mistake.

- `^` matches from the beginning of the string.
- `$` matches from the end of the string.
- if you use both, you are stating what has to be the entire string.


We can also print the year, with a small addition to the previous example.

~~~bash
YEAR=1999
if [[ $YEAR =~ ^[0-9]{2}$ ]]; then
  echo "year ${YEAR} is in 2 digit format"
elif [[ $YEAR =~ ^[0-9]{4}$ ]]; then
  echo "year ${YEAR} is in 4 digit format"
else
  echo "year ${YEAR} is in unrecognized format"
fi
~~~


~~~output
year 1999 is in 4 digit format
~~~

It is a small addition, but useful in that it may make it
easier to observe errors (by printing the year being evaluated).


#### Further Learning

Library Carpentry have a longer [introduction to regex](https://librarycarpentry.org/lc-data-intro/)
course (from which some of this material has been taken). If you will be working with, and
processing, a lot of text files then you will find this course useful. Do note, however,
it is written with the more advanced regex implementations in mind, so some features
mentioned in that course will not be available for shell programming.




