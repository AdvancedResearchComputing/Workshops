# Program Input-Output

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)




### Background

#### Motivation

A computer program takes in input, performs some operations, and then
outputs results.
Here, we look at two major issues:

- How to input data/information into a code.
- How to specify where outputs are written.

__For Inputs:__

1. program-prompt mode:  enter (type) information during code execution at command prompts.
2. command line mode:
    - a. use command line arguments (CLAs)
    - b. store inputs in files.

The command line alternatives are used most often.

__For Outputs:__

1. Redirection:  output that is supposed to be written to screen is redirected to file.
2. Write output to output file, one line at a time.
3. Use of templates.  See episode _Generate Many Input/Configuration/Data/Script Files_.


We start with inputs.

#### Interactive Input:  Providing Input at a Command Prompt


This is the data file that we will work with.
These are fictitious company data.
The file is company.data.


~~~data
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
~~~



Here is a small code that prompts the user for a filename,
and reads and stores the filename in a program variable.
It then also reads a search string.
The code then prints the results of searching the
input file for the search string.

This code is file _mySearchCode01.sh_

~~~bash
#!/bin/bash


echo "Enter input file name:"
read infile
echo "The input file: $infile"
echo "Enter the string that you want to search for:"
read searchString
echo "Searching for string '$searchString' in file $infile."
echo " "
echo "The results follow"
echo " "
## This is the grep command; see the grep command.
grep $searchString $infile
~~~

Assuming you are in the same directory with the code, it is invoked using one of these:

- _bash mySearchCode01.sh_
- _sh mySearchCode01.sh_
- if the permissions on the file make it executable, then _./mySearchCode01.sh_


An execution of this code is as follows.
Results are written to the terminal screen.

~~~output
## This is the code invocation.
sh mySearchCode01.sh

## This is the running of the code.
Enter input file name:
company.data
The input file: company.data
Enter the string that you want to search for:
oil
Searching for string 'oil' in file company.data.

The results follow

exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000

~~~


Now we look at virtually the same problem, but we want to
write the results to a file, rather than to the terminal
screen.
To do this, we prompt the user for the output filename.
And we redirect output, with the `grep` command,
from the terminal to the output file.


This code is file _mySearchCode02.sh_



~~~bash
#!/bin/bash


echo "Enter input file name:"
read infile
echo "The input file: $infile"
echo "Enter output file name (where results will be stored):"
read outfile
echo "The output file: $outfile"
echo "Enter the string that you want to search for:"
read searchString
echo "Searching for string '$searchString' in file $infile."
echo " "
## This is the grep command; see the grep command.
grep $searchString $infile  > $outfile
echo " "
echo "done "
~~~


Assuming you are in the same directory with the code, it is invoked using one of:

- _bash mySearchCode02.sh_
- _sh mySearchCode02.sh_
- if the permissions on the file make it executable, then _./mySearchCode02.sh_



An execution of this code is as follows.
Results are written to the output file.

~~~output
## This is the code invocation.
sh mySearchCode02.sh

## This is the running of the code.
Enter input file name:
company.data
The input file: company.data
Enter output file name (where results will be stored):
company.out
The output file: company.out
Enter the string that you want to search for:
oil
Searching for string 'oil' in file company.data.


done
~~~



The output is stored in the file _company.out_ so let
us list it.

~~~bash
cat company.out
~~~

And the contents of the file are:

~~~output
exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000
~~~


Both of these examples are correct.
They work.
But almost no one does things this way:  too tedious.
One solution to this tediousness is to use command line arguments (CLAs).

#### Inputs:  Providing Command Line Arguments

Now suppose we want to specify all of the inputs
(input filename, output filename, search string)
when we invoke the program so that the program is
not prompting us for individual inputs.
That is, we are using command line inputs.
That is, all of the information is provided to the code
when it is invoked.

We use command line arguments for this purpose.

In this code listing, we have three command line arguments,
which are the same variables that we entered
interactively when the above code ran.

The code listing is as follows.
Notice how the code becomes more compact.

Command line arguments are specified in bash script
source files with format `$i` where _i_ goes from 1 to _n_,
where _n_ is the number of CLAs.

In the code below, _n=3_ so we have `$1`, `$2`, and `$3`.
Note the ordering is important:
- `$1` is the input file.
- `$2` is the output file.
- `$3` is the search string

... because this is the way the code is implemented.

**Coding suggestion**:  immediately, when code starts up,
assign CLAs to variables so that the variable names give the
CLAs meaning.  Using `$2` in an obscure piece of code 200 lines
down is not helpful.

This code is file _mySearchCode03.sh_


~~~bash
#!/bin/bash

# The command line arguments are entered in this
# REQUIRED order:
#   - input filename
#   - output filename
#   - search string

# Assignment of command line arguments (CLAs) to variables.
echo " Echo Inputs "
infile=$1
outfile=$2
searchString=$3

# Echo inputs
echo "input file: $infile"
echo "output file: $outfile"
echo "search string: '$searchString'"
echo " "


## This is the grep command; see the grep command.
grep $searchString $infile  > $outfile
echo " "
echo "done "
~~~



Assuming you are in the same directory with the code, it is invoked using one of:

- _bash mySearchCode03.sh_
- _sh mySearchCode03.sh_
- if the permissions on the file make it executable, then _./mySearchCode03.sh_


We invoke the command by using another bash script,
which is a file called _run.03_:

~~~bash
sh mySearchCode03.sh  company.data  company.03.out  oil
~~~

... or ...

~~~bash
chmod u+x mySearchCode03.sh
./mySearchCode03.sh  "company.data"  "company.03.out"  "oil"
~~~


The output is stored in the file _company.03.out_ so let
us list it.

~~~bash
cat company.03.out
~~~

And the contents of the file are:

~~~output
exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000
~~~




Suppose now that we want to run the code many times.
As in "thousands of times".

We do not want to sit at our computer and manually enter
every filename and every search string at every command prompt.
That would be agonizing.
This is what we did with the first couple of examples in this section.

What we do instead is use the ideas of the last example:
use command line arguments.
And we use a file _run.04_ to launch the
code _mySearchCode03.sh_.

File _run.04_ is below:

~~~bash
./mySearchCode03.sh  company.data  company.oil.04.out  oil
./mySearchCode03.sh  company.data  company.copying.04.out  copying
./mySearchCode03.sh  company.data  company.fast_food.04.out  fast_food
./mySearchCode03.sh  company.data  company.ice_cream.04.out  ice_cream
~~~


We invoke _run.04_ by typing _sh run.04_.

The screen looks like this:

~~~output
 Echo Inputs
input file: company.data
output file: company.oil.04.out
search string: 'oil'


done
 Echo Inputs
input file: company.data
output file: company.copying.04.out
search string: 'copying'


done
 Echo Inputs
input file: company.data
output file: company.fast_food.04.out
search string: 'fast_food'


done
 Echo Inputs
input file: company.data
output file: company.ice_cream.04.out
search string: 'ice_cream'


done
~~~


The code was run four times.  Even four is not a lot of times,
but it is a start.

Now, list the contents of the four output files.

~~~bash
cat   company.*.04.out
~~~

The output is:

~~~output
xerox       copying       business       international    6000000
mcdonalds   fast_food     restaurant     international   11000000
dq          ice_cream     restaurant     national            3560
exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000
~~~

This is not too useful.

We have lines of data, but which data go with which output file?

A better command is:

~~~bash
awk '(FNR==1){print ">> " FILENAME " <<"}1'   company.*.04.out
~~~



And now the output is much clearer:

~~~output
>> company.copying.04.out <<
xerox       copying       business       international    6000000
>> company.fast_food.04.out <<
mcdonalds   fast_food     restaurant     international   11000000
>> company.ice_cream.04.out <<
dq          ice_cream     restaurant     national            3560
>> company.oil.04.out <<
exxon       oil           energy         international   10000000
chevron     oil           energy         international    5200000
~~~

In the above, `FNR` is File Record Number, which is typically
the file line number.
So for the first line of each file, the filename is printed.

We were going along with a simple `cat` solution and then
we go to `awk`.
This is bash.
You want to do one thing.  You try something you know (like `cat`).
But it is not quite what you want.
There is a better solution, and it is not just a flag on
`cat` but rather an entirely different command (in this case, `awk`).
And you see, with this small example, why it is useful to
know a lot of bash programming.
(Note:  often, you CAN add another switch to the command that you are
using and it will give you the added features.
But sometimes not.)


We will do things with FOR loops to make this more extensible
later, to thousands of executions.


#### Inputs:  Reading Information From a JSON File Using `jq`

JSON stands for _JavaScript Object Notation_ and is widely used as an
ASCII (data) file format.
As but one example, it is used very often as the format
for configuration
files for complicated codes.

We will not be going over JSON file formats, but you will probably get the
main ideas.
It is, in essence, a system of writing down _key : value_ pairs,
where the _value_ can be a string, a list, an array, a map (dictionary),
or even another JSON file,
etc.
There are myriad links on the internet to learn JSON.

We focus on
the `jq` utility, that works by applying filters on a stream of json data.

`jq` is very powerful, but you have to know two big things about the input file:
1. file structure.
2. names of all keys.

Usually this information is readily available.

Finally, we can use `jq` right "out of the box."
Type `jq --version` and you should see the response `jq-1.6`.
Note:  another, probably later, version is perfectly fine.


Consider this JSON formatted file called _characters.json_:

~~~json
{
  "characters": [
    {
      "movie": "Cars",
      "name": "Guido",
      "type": "fork lift"
    },
    {
      "movie": "The Penguins of Madagascar",
      "name": "Kowolski",
      "type": "penguin"
    },
    {
      "movie": "Kung Fu Panda",
      "name": "Po",
      "type":  "dragon warrior"
    }
  ]
}
~~~


Look at the command below. `jq` is the program name.
`.character` has these semantics.
First, jq commands make ample use of periods (.).
They denote that the concatenated string next to it is
a _key_ in a _< key : value >_ pair.
In this case, the key is _characters_.
The file name in which the _characters_ key is to be
found is in _characters.json_.
This command returns the _value_ of the _<key : value>_
pair corresponding to key _characters_.

(The fact that the file has the same name as the key is a 
coincidence and it not necessary; perhaps a poor choice of
the same word.)

Issuing this command:

~~~bash
jq .characters characters.json
~~~

will produce this result, which is the _value_ of the
_< key : value >_ pair where the key in the file is
_characters_.


~~~json
  [
    {
      "movie": "Cars",
      "name": "Guido",
      "type": "fork lift"
    },
    {
      "movie": "The Penguins of Madagascar",
      "name": "Kowolski",
      "type": "penguin"
    },
    {
      "movie": "Kung Fu Panda",
      "name": "Po",
      "type":  "dragon warrior"
    }
  ]
~~~


First, note that arrays and lists are zero-indexed,
as in Python, C, C++, and Java, among other languages.

To get the first element of the _characters_ array,

~~~bash
jq .characters[0] characters.json
~~~


It will produce this result


~~~json
    {
      "movie": "Cars",
      "name": "Guido",
      "type": "fork lift"
    }
~~~



To get the name of the character in the second
element, do

~~~bash
jq .characters[1].name characters.json
~~~

It will produce this result


~~~bash
"Kowolski"
~~~


Note the two things that we said above that one has
to know about a _json_ file to use _jq_:
(1) the file structure, and
(2) the names of all keys.

We have to know the file structure so that we know how to bore
down into successive levels of keys (using the period `.` operator),
and we have to know what the key names are to retrieve the 
corresponding _values_.
Knowing these items enables us to write the following in the `jq`
command above:  `.characters[1].name`.
That is, we want the value corresponding to the key "name"
in the second element of "characters".

#### Using `jq` With JSON Files in Bash Scripts


Let us look at an even simpler data file _site.json_:

~~~json
{
  "SITE_DATA": {
    "URL": "example.com",
    "AUTHOR": "John Doe",
    "CREATED": "10/22/2017"
  }
}
~~~


We want a bash script that will read this file and assign the values
in <key, value> pairs to bash script variables.

Here is such a code called _jqCode02.sh_.

~~~
#!/bin/bash

# The command line arguments are entered in this
# REQUIRED order:
#   - input filename

# Assignment of command line arguments (CLAs) to variables.
infile=$1

# Echo inputs
echo "input file: $infile"
echo " "

typeset -A myarray

while IFS== read -r key value; do
    myarray["$key"]="$value"
done < <(jq -r '.SITE_DATA | to_entries | .[] | .key + "=" + .value ' "${infile}")

# show the array definition
typeset -p myarray

echo "  "

echo " Print array elements directly."
echo "URL = '${myarray[URL]}'"
echo "CREATED = '${myarray[CREATED]}'"
echo "AUTHOR = '${myarray[AUTHOR]}'"

echo "  "

# make use of the array variables
echo " Assign values to variables, then print variables."
myUrl="${myarray[URL]}"
myCreated="${myarray[CREATED]}"
myAuthor="${myarray[AUTHOR]}"


echo "URL = ${myUrl}"
echo "CREATED = ${myCreated}"
echo "AUTHOR = ${myAuthor}"

~~~
{: .language-bash}


The command line invocation to run the code is:

~~~
sh jqCode02.sh site.json
~~~
{: .language-bash}

Notice that the command line argument `site.json` is the input file name.

The output generated by this code and input file is below.
The first set of output is the array.
The second set is the array elements.
The third set is the values of bash variables.


~~~
input file: site.json
 
declare -A myarray=([CREATED]="10/22/2017" [URL]="example.com" [AUTHOR]="John Doe" )
  
 Print array elements directly.
URL = 'example.com'
CREATED = '10/22/2017'
AUTHOR = 'John Doe'
  
 Assign values to variables, then print variables.
URL = example.com
CREATED = 10/22/2017
AUTHOR = John Doe
~~~
{:   .output}


An input file could be huge and you may not want to
read in the contents of the entire file.

The example below shows how to obtain particular
variables and their values.
We get, basically, all of the values, but the key here
is that we get them one at a time, i.e., we are
getting one particular value at a time.

The filename is _human.json_ (note there is no "_" in "num fingers" and "num toes", which
will produce nulls).



~~~
{
  "height": "68",
  "weight": "210",
  "eye_color": "brown",
  "hair_color": "black",
  "num fingers": "10",
  "num toes":  "11",
  "wears_glasses": "true",
  "age": "19"
}
~~~
{:  .data}

The code to extract variables from the JSON file is below.

This file is _jqCode03.sh_.

Note that some of the assignment statements use _//  empty_
and others user _--exit-status_, depending on how you
want to handle variables that are specified, but not in the file.

~~~
#!/bin/bash

# The command line arguments are entered in this
# REQUIRED order:
#   - input filename

# Assignment of command line arguments (CLAs) to variables.
infile=$1

# Echo inputs
echo "input file: $infile"
echo " "


# You have to know the file format and the keys.
# If variable not found in json file, it will be assigned null.
v_height=$(jq --raw-output '.height // empty' "${infile}")
v_weight=$(jq --raw-output '.weight // empty' "${infile}")
v_eye_color=$(jq --raw-output '.eye_color // empty' "${infile}")
v_hair_color=$(jq --raw-output '.hair_color // empty' "${infile}")

echo "    v_height: ${v_height}"
echo "    v_weight: ${v_weight}"
echo "    v_eye_color: ${v_eye_color}"
echo "    v_hair_color: ${v_hair_color}"

# This will assign null value if reading not successful.
v_num_fingers=$(jq --exit-status --raw-output '.num_fingers' "${infile}")
v_num_toes=$(jq --exit-status --raw-output '.num_toes' "${infile}")
v_wears_glasses=$(jq --exit-status --raw-output '.wears_glasses' "${infile}")
v_age=$(jq --exit-status --raw-output '.age' "${infile}")


echo "    v_num_fingers: ${v_num_fingers}"
echo "    v_num_toes: ${v_num_toes}"
echo "    v_wears_glasses: ${v_wears_glasses}"
echo "    v_age: ${v_age}"
~~~
{: .language-bash}


The invocation is (note the command line argument):

~~~
sh jqCode03.sh human.json
~~~
{:  .language-bash}


The output follows

~~~
input file: human.json
 
    v_height: 68
    v_weight: 210
    v_eye_color: brown
    v_hair_color: black
    v_num_fingers: null
    v_num_toes: null
    v_wears_glasses: true
    v_age: 19
~~~
{:  .output}


This last example demonstrates that the nesting of json file
content can be arbitrarily deep and the ideas above still hold.

Here is a JSON file called _family.json_.
It has people's parents over a few generations.

~~~
{
  "mom": {
      "name": "Carole",
      "parents": {
          "mom": {
              "name": "Bernadine",
              "parents": {
                  "mom": "Gertrude",
                  "dad": "Felix"
              }
          },
          "dad": {
              "name": "Frank",
              "parents": {
                  "mom": "Heidi",
                  "dad": "Werner"
              }
          }
      }
  },
  "dad": {
      "name": "Bernard",
      "parents": {
          "mom": {
              "name": "Kate",
              "parents": {
                  "mom": "Kathy",
                  "dad": "Perry"
              }
          },
          "dad": {
              "name": "Mike",
              "parents": {
                  "mom": "Karen",
                  "dad": "Frank"
              }
          }
      }
  }
}
~~~
{:  .data}

This URL is very useful to ensure that your JSON file's contents
conform to the JSON standard:
_https://jsonlint.com/_

The code to extract variables from the JSON file is below.

Notice variable paths like `.mom.parents.mom.parents.dad`.

This file is _jqCode04.sh_.


~~~
#!/bin/bash

# The command line arguments are entered in this
# REQUIRED order:
#   - input filename

# Assignment of command line arguments (CLAs) to variables.
infile=$1

# Echo inputs
echo "input file: $infile"
echo " "


# You have to know the file format and the keys.
# If variable not found in json file, letter_v will be assigned null.
moms_name=$(jq --raw-output '.mom.name // empty' "${infile}")
mmds_name=$(jq --raw-output '.mom.parents.mom.parents.dad // empty' "${infile}")
dmds_name=$(jq --raw-output '.dad.parents.mom.parents.dad // empty' "${infile}")

echo "    My Mom's name is: ${moms_name}"
echo "    My Mom's Mom's Dad's name is : ${mmds_name}"
echo "    My Dad's Mom's Dad's name is : ${dmds_name}"

# This will assign null to variables not present.
dds_name=$(jq --exit-status --raw-output '.dad.parents.dad.name' "${infile}")
mms_name=$(jq --exit-status --raw-output '.mom.parents.mom.name' "${infile}")

echo "    My Dad's Dad's name is : ${dds_name}"
echo "    My Mom's Mom's name is : ${mms_name}"
~~~
{: .language-bash}


The invocation is (note the command line argument):

~~~
sh jqCode04.sh family.json
~~~
{:  .language-bash}


The output follows.

~~~
input file: family.json

    My Mom's name is: Carole
    My Mom's Mom's Dad's name is : Felix
    My Dad's Mom's Dad's name is : Perry
    My Dad's Dad's name is : Mike
    My Mom's Mom's name is : Bernadine
~~~
{:  .output}

# `zd` as an Alternative to `jq`

An alternative to `jq` is `zd`.
I am told it is very good; _https://zed.brimdata.io/docs/commands/zq_.


# Writing Output

We see in some of the above examples how output is written:
we use the `>` redirection operator that sends all of
the output that was going to go to the terminal screen,
to a file instead.
See the `grep` command in these examples above.

This suffices for many ? most ? nearly all ? of the practical cases.

There is an entire episode (section) on redirection,
titled "Input and Output Redirection".

Please see that episode for more details.

There is another way to write a particular type of output
using the `sed` command and you should look at that
episode, called "Sed and Regular Expressions".
See also episode "Generate Many Input/Configuration/Data/Script Files"
for a concrete example.


We will cover here another particular case.
That is, when you have to (want to) construct an output file
one line at a time.
This was also covered in the episode "Input and Output Redirection"
but we are going to emphasize a different aspect of it, here.

Before we go further, we summarize the methods for producing output files:
- use the `>` operator to redirect output to screen, to file.
- use `sed` in starting with a _template_ file and overriding selected strings
to produce a new file.
- use the `>>` append operator to build an output file line by line.

It is the third way that we address here.

We will do this by constructing an _sbatch_ script for _slurm_.
(You do not need to know anything about slurm or sbatch to understand
this example.)

The below file is _mySearchCode05.sh_.


~~~
#!/bin/bash

# Generate a slurm sbatch script.
# The command line arguments are entered in this
# REQUIRED order:
#   - time
#   - account
#   - partition
#   - memory
#   - number compute nodes
#   - number of tasks
#   - number of tasks per node
#   - number of cpus per task
#   - slurm output file base name
#   - slurm error file base name
#   - module name
#   - full executable invocation

# Assignment of command line arguments (CLAs) to variables.
echo " Echo Inputs "
outfile=$1

# Echo inputs
echo "output file: $outfile"
echo " "

echo "Enter the wall clock time (format:  hh:mm:ss or d-hh:mm:ss):"
read wallClockTime
echo "Enter the account to charge"
read account
echo "Enter the partition/queue to submit the job to"
read queue
echo "Enter the amount of memory needed in GB, e.g., 500G"
read memoryAmount
echo "Enter the number of compute nodes."
read numNodes
echo "Enter the number of tasks (e.g., MPI processes)."
read numTasks
echo "Enter the number of tasks per compute node."
read numTasksPerNode
echo "Enter the number of cpus per task."
read numCpusPerTask
echo "Enter the slurm output file base name."
read slurmOutBaseName
echo "Enter the slurm error file base name."
read slurmErrBaseName
echo "Enter the module name."
read moduleName
echo "Enter the job invocation."
read jobInvoke


echo "#!/bin/bash" > ${outfile}
echo " "  >> ${outfile}
echo "## SBATCH directives."  >> ${outfile}
echo "#SBATCH --time=${wallClockTime}" >> ${outfile}
echo "#SBATCH --account=${account}"  >> ${outfile}
echo "#SBATCH --partition=${queue}"  >> ${outfile}
echo "#SBATCH --mem=${memoryAmount}"  >> ${outfile}
echo "#SBATCH --nodes=${numNodes}"  >> ${outfile}
echo "#SBATCH --ntask=${numTasks}"  >> ${outfile}
echo "#SBATCH --ntask-per-node=${numTasksPerNode}"  >> ${outfile}
echo "#SBATCH --cpus-per-task=${numCpusPerTask}"  >> ${outfile}
echo "#SBATCH --output ${slurmOutBaseName}.%j.out"  >> ${outfile}
echo "#SBATCH --error ${slurmErrBaseName}.%j.err"  >> ${outfile}
echo "#SBATCH --errorfile=${numCpusPerTask}"  >> ${outfile}

echo " "  >>  ${outfile}
echo "## Load module."  >> ${outfile}
echo "module reset"  >> ${outfile}
echo "module load ${moduleName}"  >> ${outfile}
echo " "

echo " "  >>  ${outfile}
echo "## Invoke code."  >> ${outfile}
echo "${jobInvoke}"  >> ${outfile}
~~~
{:    .language-bash}


Note that the first redirect of output to ${outfile} is `>`, not
the append `>>` operator, because we want to overwrite the file,
starting fresh.
The remaining writes to ${outfile} are appends, i.e., `>>`.

We can invoke this file by putting the output file on the command line thusly.

~~~
./mySearchCode05.sh  sbatch.01.slurm
~~~
{:    .language-bash}


With suitable interactive inputs from the code execution,
we can generate a file that looks like this:

~~~
#!/bin/bash

## SBATCH directives.
#SBATCH --time=3:00:05
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --mem=400G
#SBATCH --nodes=3
#SBATCH --ntask=12
#SBATCH --ntask-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --output slurm.01.out.%j.out
#SBATCH --error slurm.01.err.%j.err
#SBATCH --errorfile=1

## Load module.
module reset
module load silly

## Invoke code.
./run.go
~~~
{:    .output}






