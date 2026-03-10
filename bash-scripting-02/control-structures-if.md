# Control Structures:  IF Statement

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



## `if` Statements

If blocks or conditional statements are useful when there is a finite
number of alternatives to consider,
and the work a code or script needs to do is dependent on which alternative
is true.

It is hard to overstate the variations of `if` statements.
We cover many here, but not all.

Alternatively, many workflows are not a fixed sequence
of codes, and (almost) all workflows will
have exceptional cases in which
operations should be halted (if, for example, a file is missing, or a
calculation would
fail).
Hence, error detection is a major use of `if` statements.
Bash has the `if` control structure, which can be used to control your workflow
in these situations.

In its most basic form, this control structure will test for a condition, then execute
a set of program statements if that condition is true.

The code associated with the first conditional that evaluates `true` will
be executed.

Various `if` block constructs are available to evaluate these
alternatives.

`if` starts a block and `fi` always ends a block.
The statements in between these two keywords can vary a lot.

The conditional is inside the double square brackets, `[[ . ]]` or `[[ conditional ]]`
and the first conditional that evaluates true is the path that the
code executes.


In the examples, the following are keywords:

- `if` starts an IF block
- `fi` ends an IF block
- `then` denotes statements to execute if the corresponding conditional is true
- `else` identifies statements to execute if no conditional evaluates "true."
- `elif` denotes the occurrence of a conditional following either an `if` keyword
    and conditional or an `elif` keyword and conditional.

We go through some examples.
First we deal with numbers.
Common operators for numbers are:

- `-eq` for _equals_
- `-gt` for _greater than_
- `-ge` for _greater than or equal to_
- `-lt` for _less than_
- `-le` for _less than or equal to_

#### Some Basic Structures of `if` blocks.

In the examples below, `<< statement(s) >>` means one or more bash statements
or utility commands.

The basic structure of an "_if-then_" block is

~~~bash
if [[ CONDITIONAL ]]
then
  << statement(s) >>
fi
~~~


The basic structure of an "_if-then-else_" block is

~~~bash
if [[ CONDITIONAL ]]
then
  << statement(s) >>
else
  << statement(s) >>
fi
~~~

The basic structure of an "_if-then-elif_" block is

~~~bash
if [[ CONDITIONAL01 ]]
then
  << statement(s) >>
elif [[  CONDITIONAL02]]
then
  << statement(s) >>
fi
~~~


The basic structure of an "_if-then-elif-else_" block is

~~~bash
if [[ CONDITIONAL01 ]]
then
  << statement(s) >>
elif [[  CONDITIONAL02]]
then
  << statement(s) >>
else
  << statement(s) >>
fi
~~~

In the structure above, you can have any number of `elif` blocks.
They come after the `if` portion and before the `else` portion.


The keyword `else` is often used to denote an error condition.
That is, the `if` and `elif` substructures test for conditions you would 
expect.
If none of these conditions are met---which may or may not be
a surprise to the writer of the code---then the `else` subblock
prints an error message and the code halts.
Note:  this does not always happen, but this approach is widely 
used.


#### Some Notes and Tips


- Always leave one or more blanks before and after the above operators like `-lt`.
- Always have one or more blanks before and after `[[` and `]]`.

The following code is not recommended beccause it is harder to read.
Putting spaces between variables and operators (e.g., _-gt_ and _-lt_)
and constants will 
make your code more readable, particularly with the `if` operators.

This will work:

~~~bash
age=43
if [[ $age-gt30 ]]
then
  echo "Man, you are old."
fi
~~~

... but this is easier to grasp:

~~~bash
age=43
if [[ $age -gt   30 ]]
then
  echo "Man, you are old."
fi
~~~

And the output is:


~~~output
Man, you are old.
~~~


Note that all of the code in the code blocks can be copied
from these pages and pasted directly into a terminal
window, at the command prompt (you must be at a command
prompt).
All commands will work this way.

All of the examples below will run.

Basic `if` block with one conditional.

~~~bash
age=43
if [[ $age -gt 30 ]]
then
  echo "Man, you are old."
fi
~~~


Basic `if` block with ``if-then-else'' structure.

~~~bash
age=43
if [[ $age -ge 30 ]]
then
  echo "Man, you are old."
else
  echo "Man, you are young."
fi
~~~


~~~output
Man, you are old.
~~~




Basic `if` block with ``if-then-else if'' structure.

So this code snippet has two conditionals.


~~~bash
age=43
if [[ $age -gt 30 ]]
then
  echo "Man, you are old."
elif [[ $age -lt 31 ]]
then
  echo "Man, you are young."
fi
~~~


~~~output
Man, you are old.
~~~




Below is an example where both conditionals are true, but only
the first is executed because that conditional is
evaluated first.


~~~bash
age=43
if [[ $age -ge 30 ]]
then
  echo "I am the first true statement."
elif [[ $age -gt 40 ]]
then
  echo "I am the SECOND true statement."
fi
~~~


~~~output
I am the first true statement.
~~~





Basic `if` block with "if-then-else if-then-else" structure.


~~~bash
age=43
if [[ $age -gt 50 ]]
then
  echo "Man, you are old."
elif [[ $age -lt 40 ]]
then
  echo "Man, you are young."
else
  echo "You have a weird age."
fi
~~~


~~~output
You have a weird age.
~~~



Nested `if` blocks with ``if-then-else if-then-else'' structure.


~~~bash
zip_code=22903
zc_bb=24060
zc_cb=24073

if [[ $zip_code -gt 22000 &&   $zip_code -lt 25000     ]]
then
  echo "You live in Virginia (VA)."
  if [[ $zip_code -eq $zc_bb ]]
  then
      echo "You live in Blacksburg, VA."
  elif [[ $zip_code -eq $zc_cb ]]
  then
      echo "You live in Christiansburg, VA."
  else
      echo "You live in Charlottesville, VA."
  fi
else
  echo "I do not know where you live."
fi
~~~



The output is:

~~~output
You live in Virginia (VA).
You live in Charlottesville, VA.
~~~



Strings can be evaluated.

But the operators are different.

[!NOTE]
It is a point of confusion that the operators for strings are
are the SAME those for numbers in C, C++, Java, Python, and other PLs.

See the tables below for compendiums of operators.

~~~bash
if [[ b > a ]];then
  echo "b is greater than a"
fi
~~~

Since it is true that b is greater than a, the output is:

~~~output
b is greater than a
~~~



These are lexicographic comparisons of the strings, using the alphabetical order. Other
non-numeric conditions available are `<`, `>=`, `<=`, `==` and `!=` (described in the
table at the end of this section):

~~~bash
if [[ b != a ]];then
  echo "b is not the same as a"
fi
~~~


~~~output
b is not the same as a
~~~

For arithmetic comparisons inside `[[ ]]` brackets we instead would use the operators `-gt`,
`-lt`, `-le`, `-ge`, `-eq` and `-ne`:

~~~bash
if [[ 8 -gt 7 ]];then
  echo "8 is greater than 7"
fi
~~~


Since it is true that 8 is greater than 7, the string is printed and
the output is:

~~~output
8 is greater than 7
~~~


For arithmetic expressions we can also use `(( ))`, as described in the section above:

~~~bash
if (( 8 > 7 ));then
  echo "8 is greater than 7"
fi
~~~



And the output is the same as for the previous code.


~~~bash
a=7
b=8

if (( $b > $a ));then
  echo "8 is greater than 7"
fi
~~~

~~~output
8 is greater than 7
~~~

~~~bash
a=7
b=8

if (( (( $b + $a ))  > (( $a - $b))   ));then
  echo "15 is greater than -1"
fi
~~~


~~~output
15 is greater than -1
~~~


#### String Equality


Common operators for strings are:

- `==` for _equality_
- `!=` for _inequality_


String example testing for equality.

~~~bash
string1="I am a libra."
string2="I am a taurus."

echo "  string1 is $string1"
echo "  string2 is $string2"
echo "  string1 is "  "$string1"
echo "  string2 is "  "$string2"


if [ "$string1" == "$string2" ]; then
    echo "You guys are the same zodiac."
else
    echo "You guys are different zodiac."
fi
~~~

And the output is:

~~~output
You guys are different zodiac.
~~~



String example testing for equality.
Strings are case sensitive.

~~~bash
#!/bin/bash
string1="I am a libra."
string2="I am a LIBRA."

echo "  string1 is $string1"
echo "  string2 is $string2"
echo "  string1 is "  "$string1"
echo "  string2 is "  "$string2"


if [ "$string1" == "$string2" ]; then
    echo "You guys are the same zodiac."
else
    echo "You guys are different zodiac."
fi


# Change the case.
string2b=`echo "$string2" | tr '[:upper:]'   '[:lower:]' `

echo "  string1 is $string1"
echo "  string2b is $string2b"
echo "  string1 is "  "$string1"
echo "  string2b is "  "$string2b"


if [ "$string1" == "$string2b" ]; then
    echo "You guys are the same zodiac."
else
    echo "You guys are different zodiac."
fi

~~~



~~~output
  string1 is I am a libra.
  string2 is I am a LIBRA.
  string1 is  I am a libra.
  string2 is  I am a LIBRA.
You guys are different zodiac.
  string1 is I am a libra.
  string2b is i am a libra.
  string1 is  I am a libra.
  string2b is  i am a libra.
You guys are different zodiac.
~~~


Note that the second occurrence of "You guys are different zodiac." is __not__
caused by the zodiac word, but rather because string1 has capital "I"
and string2b has lower case "i".


Operators within a conditional statement permit
more complicated expressions, as we saw for numbers.


Operators in conditionals when dealing with numbers:
Logical _and_ is `-a`.
Logical _or_ is `-o`.





end

-------------------------------------


This `(( ))` structure with __numerical__ values, confusingly,
uses the same operators as the
__non-numeric__ conditionals in the `[[ ]]`
environment, rather than being the same as the numerical operators.


> ## Logical Test
>
> Which of these conditionals are True, which are False, and which don't work?
>
> 1. `[[ 4 -eq 4 ]]`
> 2. `[[ be == eb ]]`
> 3. `[[ 4 == 4 ]]`
> 4. `[[ 4 == 04 ]]`
> 5. `(( 4 == 04 ))`
> 6. `(( 4 -eq 04 ))`
>
> > ## Solution
> >
> > 1. True.
> > 2. False.
> > 3. True (but a string, not arithmetic comparison).
> > 4. False, because it is a string comparison.
> > 5. True, because this is a math context.
> > 6. Error, because `-eq` can't be used within a math context
> {: .solution}
{: .challenge}


> ## Arithmetic Comparisons of Strings
>
> You should never do this, if you can help it.
> This type of programming and coding is not good; it is error-prone.
>
> Be aware that if you try to make an arithmetic comparison of strings,
> the `[[ ]]` command converts any non-numeric strings to variable names.
>
> ~~~
> a=2
> b=6
> if [[ "b" -gt "a" ]];then
>  echo "this is slightly less obvious"
> fi
> ~~~
> {: .language-bash}
> ~~~
>
> ~~~
>
{: .callout}





> ## One bracket or two?
>
> `[[ ]]` is a, relatively, new command, which is not universally available in other,
> non-bash, shells. Previous to this there was `[ ]` (synonymous for the `test` command),
> which is more portable than `[[ ]]`, but is not as powerful or robust. `[ ]` wont be
> covered here - more information on the differences between these can be found here:
> [http://mywiki.wooledge.org/BashFAQ/031](http://mywiki.wooledge.org/BashFAQ/031)
{: .callout}






## Logical _and_ and _or_

Operators within a conditional statement permit
more complicated expressions.


Operators in conditionals when dealing with numbers:
Logical _and_ is `&&`.
Logical _or_ is `||`.


__Logical AND__

~~~
age=60
wrinkles=1
if [[ $age -gt 50 ]] && [[ $wrinkles -eq 1 ]]
then
   echo "You are consistent."
else
   echo "You are unusual."
fi
~~~
{: .language-bash}


And the output is:

~~~
You are consistent.
~~~
{: .output}


__Logical OR__

~~~
age=1
if [[ $age -lt 2 ]] || [[ $age -gt 70 ]]
then
   echo "You are extreme."
else
   echo "You are in between."
fi
~~~
{: .language-bash}

And the output is:

~~~
You are extreme.
~~~
{: .output}



More string evaluations in `if` statements.
We are throwing more (realistic) code
into the mix.



__Logical AND__

~~~
age_category="baby"
wrinkles="yes"
if [[ "$age_category" = "baby" ]] && [[ "$wrinkles" = "no" ]]
then
    echo "You are freaky."
elif [[ "$age_category" = "baby" ]] && [[ "$wrinkles" = "yes" ]]
then
    echo "You are normal."
else
    echo "I don't know what you are."
fi
~~~
{: .language-bash}

~~~
You are normal.
~~~
{:  .output}


__Logical OR__

~~~
color="yellow"
if [[ $color = "yellow" ]] ||  [[ $color = "orange" ]]
then
   echo "You are bright and shiny."
else
   echo "You are subdued."
fi
~~~
{: .language-bash}


~~~
You are bright and shiny.
~~~
{:  .output}

## Operator Summary

There are three types of operators for these conditional expressions:
file, numeric, and non-numeric. Each will return true (0) if the condition is met,
or false (1) if the condition is not met. These operators are slightly different for
`[[ ]]` and `(( ))` expression testing, as shown in the following two tables.


| conditional expressions for `[[ ]]` |
| object or non-numeric | numeric or boolean | description |
|----------|--------|--------|
| -e | | file exists |
| -d | | file is a directory |
| -f | | file is a regular file |
| -z | | variable does not exist |
| >  |  -gt | greater than |
| <  |  -lt | less than |
| >= |  -ge | greater than or equal to |
| <= |  -le | less than or equal to |
| == |  -eq | equal |
| != |  -ne | not equal |
|| ! | logical NOT |
|| && | logical AND |
|| \|\| | logical OR |


| conditional expressions for `(( ))` |
| numeric or boolean | description |
|--------|--------|
| >  | greater than |
| <  | less than |
| >= | greater than or equal to |
| <= | less than or equal to |
| == | equal |
| != | not equal |
| ! | logical NOT |
| && | logical AND |
| \|\| | logical OR |


## Strings and Regular Expressions

Strings can be evaluated using regular expressions.

The operator is `=~`.
The variable must be to the left of the `=~` and the regular
expression must be to the right of the `=~`.

You can put these commands inside a file or, easier,
just copy and paste this right into the terminal window
at the command prompt.

~~~
mylist="    here4weGo     4692     herewe"

for a in $mylist
do

    echo " "
    echo " ------ "
    echo "$a"
    if [[ "$a" =~ ^[0-9]+$ ]]; then
        echo " The string contains only numbers."
    elif [[ "$a" =~ ^[A-Za-z]+$ ]]; then
        echo " The string contains only letters."
    else
        echo " The string contains numbers and letters."
    fi

done
echo " "
echo "done"
~~~
{: .language-bash}

The `^` symbol means start matching at the beginning of the string.
The `[0-9]` means match any number digit.
The `+` means that there can be one or more occurrences of `[0-9]`, i.e., one or more
occurrences of number digits.
The `$` means match at end of string.
So the `^` and `$` together means that only the "characters" between them
can occur in the totality of the string.



~~~
 ------ 
here4weGo
 The string contains numbers and letters.
 
 ------ 
4692
 The string contains only numbers.
 
 ------ 
herewe
 The string contains only letters.
 
done
~~~
{:  .output}
