# Control Structures:  CASE Statement

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



## `case` Statement



The case statement is much like an `if` block and can be used
essentially interchangeably.
The first pattern that matches/satisfies the expression
is executed.

> [!NOTE]
You have to include the `;;` after the statements of each
pattern, otherwise, the shell will execute all of the 
statements from that point through the rest of the 
CASE statement, until a `;;` is reached.

#### Format for CASE Statement

Format for the case statement:



~~~bash
case EXPRESSION in

  PATTERN_1)
    STATEMENTS
    ;;

  PATTERN_2)
    STATEMENTS
    ;;

  PATTERN_N)
    STATEMENTS
    ;;

  *)
    STATEMENTS
    ;;
esac
~~~

> [!NOTE]
> The `*)` is the equivalent of the `if` statement's `else` keyword.


Example.


~~~bash
home_state="Nebraska"

echo "Your home state is ${home_state}."
echo " "

case ${home_state} in

  "Illinois")
    echo "You are a Fighting Illini."
    ;;

   "Nebraska")
    echo "You are a cornhusker."
    ;;

  "Missouri")
    echo -n "You are from the Show Me state."
    ;;

  "Oklahoma")
    echo "You are a Sooner."
    ;;

  "Kansas")
    echo "You are a Jayhawker."
    ;;

  "Indiana")
    echo "You are a Hoosier."
    ;;

  *)
    echo "I never heard of that place."
    ;;
esac
~~~



~~~output
You are a cornhusker.
~~~


A different kind of example,
where multiple entries, separated by `|`, can give the same result.

~~~bash
month="January"
case $month in

  February)
      echo "There are 28 or 29 days in $month.";;

  April | June | September | November)
      echo "There are 30 days in $month.";;

  January | March | May | July | August | October | December)
      echo "There are 31 days in $month.";;

  *)
      echo "Unknown month. Please check whether you entered the correct month name: $month";;
esac
~~~



~~~output
There are 31 days in January.
~~~

