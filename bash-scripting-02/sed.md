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

~~~
echo hello > input.txt
sed -e "s/hello/world/" input.txt
~~~
{: .language-bash}
~~~
world
~~~
{: .output}


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

~~~
sed -e "s/hello/world/" input.txt > output.txt
~~~
{: .language-bash}
The script we are using here is a substitution (indicated by the `s` at the start of the
script). The first string (`hello`) is what is being searched for, while the second string
(`world`) is the string that will be used as a replacement.

Sed can be passed multiple inputs, it will treat these as a single stream:

~~~
echo goodbye > input_pt2.txt
sed -e "s/goodbye/world/" input.txt input_pt2.txt
~~~
{: .language-bash}
~~~
hello
world
~~~
{: .output}

It can also be passed multiple scripts, which will be run in sequential order:
~~~
sed -e "s/goodbye/world/" -e "s/l/a/" input.txt input_pt2.txt
~~~
{: .language-bash}
~~~
healo
worad
~~~
{: .output}

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

~~~
sed -e "s/goodbye/world/" -e "s/l/a/g" input.txt input_pt2.txt
~~~
{: .language-bash}
~~~
heaao
worad
~~~
{: .output}


Rather than search the whole input for match you can, if you know the exact line you wish
to process, specify a line number (in this case, line 2):

~~~
echo 'hello' > input_lines.txt
echo 'hello' >> input_lines.txt
sed "2 s/hello/world/" input_lines.txt
~~~
{: .language-bash}

~~~
hello
world
~~~
{: .output}


Note that sed starts indexes from 1, not 0.


> ## Providing scripts via a file.
>
> Sed allows the use of a file for providing the scripts for processing your files. This
> file should contain one script per line, and passed using `-f` instead of `-e`, e.g.:
> ~~~
> echo "s/goodbye/world/" > myscript.sed
> sed -f myscript.sed input.txt input_pt2.txt
> ~~~
> {: .language-bash}
> ~~~
> hello
> world
> ~~~
> {: .output}
{: .callout}




> ## Editing dates for a complex configuration file
>
> Jon has a configuration file (`namelist.input` in the `wrf_configuration` directory)
> that he uses for running the Weather Research and Forecast
> (WRF)  model. He wants to run this daily, keeping all of
> the configuration the same except for the start and end dates. These will need to be
> changed each day that the model is run, so that the start date is today, and the end
> date is today + 3 days. Can you automate this using `sed`? The template configuration
> file itself does not need to be useable, so can be modified if that would help you.
>
> > ## Solution
> >
> > There are two ways to do this. The first is to specify the lines you want to change,
> > and change only those lines. However this is a fragile solution, as any changes to the
> > template configuration file could change the line numbering, breaking your script.
> >
> > A more robust solution is to replace the dates in the template file with clear
> > identifier strings. These should be something you would not normally see in a script
> > (e.g. I tend to use a string such as `%%DAY%%` or `%%MONTH%%`). Then you can carry out
> > a global sed action for each string requiring changing, without worrying that you
> > might make any unwanted changes.
> {: .solution}
{: .challenge}




## Regular Expressions

Grep uses regular expressions (often abbreviated to _regex_),
sequences of characters which define the string(s) to be searched for. Sed uses the same
regex patterns for it's searches, and we will cover some basic principles of using these
here.

> ## Regex syntax and interoperability
>
> Regular expressions are implemented in a number of different programming languages.
> These all follow similar rules, but there will be differences, often subtle, between
> each of these implementations.
>
> Many implementations follow the feature-rich regex syntax that was developed first for
> the Perl language.
> However UNIX command line programs tend to use the older 'POSIX' regex
> standards. These are further split into the POSIX Basic (BRE) and POSIX Extended Regular
> Expression (ERE) standards. Below we will teach you the ERE standard, because this has
> a more readable syntax which is closer to that of the more modern regex implementations.
> More information on the difference between the two POSIX standards can be found
> [here](http://www.regular-expressions.info/posix.html).
>
> To use ERE in sed the `-E` flag must be used. We will do this below, even in situations
> where it is not necessary, to get you in the habit of using it in your own code.
{: .callout}

Regular expressions rely on the use of literal characters and metacharacters to construct
the search term. Metacharacters are characters which have a special meaning (such as `.`
represents any single character). If you wish to search for a literal character which
happens to be a regex metacharacter, then it will need to be "escaped," that is, preceded
by a `\` character. For example:
~~~
echo "Hello. World" > input.txt
sed -E -e 's/\./.../' input.txt
~~~
{: .language-bash}
~~~
Hello... World
~~~
{: .output}
Note that the string which is being used as a replacement is not a regex pattern, so the
periods in this did not need escaping.

> ## Forgetting to escape a metacharacter
>
> What string would sed return if the `\` character was not used in the above regex?
>
> > ## Solution
> >
> > The first character found will be replaced, giving an output:
> > ~~~
> > ...ello. World
> > ~~~
> > {: .output}
> >
> > The search was not global though, so the rest of the string remains unchanged. Only if
> > a `g` were added to the end of the script then it will replace all characters in the
> > string with `...`.
> {: .solution}
{: .challenge}

### Matching Ranges of Characters

One of the most common patterns used in regex is the definition of a list or range of
characters, which can be denoted using square brackets. E.g.:
~~~
sed -E -e "s/[HW]/J/g" input.txt
~~~
{: .language-bash}
~~~
Jello. Jorld
~~~
{: .output}
This list of upper case characters to replace is very focused, but if you did not know in
advance what the upper case characters would be you can use the list `[A-Z]`. Similarly,
to replace all lower case letters use the list `[a-z]`, and to replace any digit us
`[0-9]`. These can be combined as you require, for example, to match all characters (of
any case) between B and H you would use `[B-Hb-h]`.

> ## Creating new strings
>
> What regex expressions would you use to create the following strings from the
> `Hello. World` string in the `input.txt` file?
> 1. `Halla. Warld`
> 2. `Heno. Worn`
>
> > ## Solution
> > 1. `sed -E -e "s/[eo]/a/g"`
> > 2. `sed -E -e "s/l[ld]/n/g"`
> {: .solution}
{: .challenge}

### Matching Repeated Instances

It can be useful to match more, or less, than a single instance of a particular element in
the search string. This can be done by adding one of these special characters:
- `*` matches the preceding element zero or more times
- `+` matches the preceding element one or more times
- `?` matches when the preceding element appears zero or one time
- `{VALUE}` matches the preceding element the specified number of times defined by `VALUE`;
ranges can be defined by `{VALUE,VALUE}`

The elements that these can be used on can be either single characters, or sets of
characters. E.g.:
~~~
sed -E -e "s/l{2}o/n/g" input.txt
~~~
{: .language-bash}
~~~
Hen. World
~~~
{: .output}
This is particularly useful for changing date strings, e.g.:
~~~
YEAR=2021
sed -E -e "s/[0-9]{4}/${YEAR}/g" <(echo 'the date is: 23-04-2020')
~~~
{: .language-bash}
~~~
the date is: 23-04-2021
~~~
{: .output}
Here we change the date to that set in a previously set variable (note the use of double
quotation marks, so that the shell will interpret the string and replace the variable name
with the required value).


### Matching Line Endings

The `^` and `$` metacharacters can be used to respectively assert the position of the
start or end of a line. This allows you to "anchor" your search at either end of a line.
For example, if we are provided with a YEAR variable which only contains the last two
digits, but we know that the year digits will always be at the end of the line, we can
search for `[0-9]{2}` without risking changing the day or month:
~~~
YEAR=21
sed -E -e "s/[0-9]{2}$/${YEAR}/g" <(echo 'the date is: 23-04-2020')
~~~
{: .language-bash}
~~~
the date is: 23-04-2021
~~~
{: .output}

### Back References and Subexpressions

We will skip this.

A back-reference is a regex command which refers to a previous part (or subexpression) of
the matched regular expression. They can be used to repeat patterns within a regex search
or, as we will do here, pass part of the matched regex forward to the replacement string.
Back references are specified by a single escaped digit (e.g. `\1`; up to nine are allowed
in a single regex), while the subexpression is indicated using `()` brackets.

A common use of these is pulling out a single element of the search, e.g. the year from a
date string:
~~~
date | sed -E -e "s/^.*([0-9]{4}).*$/\1/g"
~~~
{: .language-bash}
~~~
2021
~~~
{: .output}
Note how the 4-digit year is stored in a subexpression, while the strings before and after it are included in the match using `^.*` and `.*$`.


## BASH logic and regex

In the logic and maths lesson you were introduced to the `[[ ]]` command, which is used
for logical control structures. This command also allows regex patterns to be used,
checking to see if a given string matches the regex or not. This comparison is performed
using the `=~` operator. For example:

~~~
YEAR=1999
if [[ $YEAR =~ ^[0-9]{2}$ ]]; then
  echo "year is in 2 digit format"
elif [[ $YEAR =~ ^[0-9]{4}$ ]]; then
  echo "year is in 4 digit format"
else
  echo "year is in unrecognized format"
fi
~~~
{: .language-bash}
~~~
year is in 4 digit format
~~~
{: .output}


Note that the `^` and `$` metacharacters have been used to ensure the pattern matches the
whole string, and that no partial matches are made by mistake.


We can also print the year, with a small addition to the previous example.

~~~
YEAR=1999
if [[ $YEAR =~ ^[0-9]{2}$ ]]; then
  echo "year ${YEAR} is in 2 digit format"
elif [[ $YEAR =~ ^[0-9]{4}$ ]]; then
  echo "year ${YEAR} is in 4 digit format"
else
  echo "year ${YEAR} is in unrecognized format"
fi
~~~
{: .language-bash}
~~~
year 1999 is in 4 digit format
~~~
{: .output}

It is a small addition, but useful in that it may make it
easier to observe errors (by printing the year being evaluated).


### Further Learning

Library Carpentry have a longer [introduction to regex](https://librarycarpentry.org/lc-data-intro/)
course (from which some of this material has been taken). If you will be working with, and
processing, a lot of text files then you will find this course useful. Do note, however,
it is written with the more advanced regex implementations in mind, so some features
mentioned in that course will not be available for shell programming.


{% include links.md %}

