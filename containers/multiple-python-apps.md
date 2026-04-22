# Constructing and Running a Container With Multiple Python Apps


##### Navigate

[Back to Main Page](./main-containers.md)



## `%apprun` versus `%runscript`


If one has multiple applications, and therefore multiple entry points
into a container
(one for each app),
you want to use `%apprun` rather than `%runscript` in the definition file.

This example has a basic python environment that suffices
for all of the python apps.
Hence, we use the same definition file structure
as before.
However, every app can have/require a different 
environment and this can be addressed.
See this [Apptainer page](https://apptainer.org/docs/user/main/definition_files.html#scif-apps).

## Context

We are working in some field, say biology.
There is a collection of codes that are fundamental to
perform say, evolutionary biology analyses on 
test samples.
One can collect all of these codes
(there can be 5, 10, or even hundreds of such codes)
into one container, making it available to a lab
or the broader community.

Here, we take a much simplified approach and we 
create a container that houses four python codes
that perform different operations on a user-specified string.
So these four codes are intended to represent a
much larger set of real-world executable codes.


## Preconditions


See the preconditions for this work [here](./preliminaries.md).




#### Construct the Definition File

Create file _multi_app.def_ file immediate below.
(This is the same name used in the earlier and simpler multi-app container.)

Notes:

1. We start with (i.e., bootstrap)
a Miniconda Docker container.
This is so that we can generate a tailored virtual
environment, if we wish.
Here, we only update the version of python to 3.14.
2. But one can add packages by including more
`conda install -y <package_name>` commands.
3. The four Python source code files are given at the end of
this page, for completeness.
4. The argument `"$@"` means any number of arguments.
   

```
Bootstrap: docker
# From: ubuntu:22.04
From: continuumio/miniconda3



%files
    # Copy a python script from your host machine to the container
    tokenize.py         tokenize.py
    count_tokens.py     count_tokens.py
    classify_tokens.py  classify_tokens.py
    letter_counts.py    letter_counts.py


%post
    apt-get update -y
    conda update -y conda
    conda install -y python=3.14


# Application 1: 'tokenize'
%apprun tokenize
    echo "Running python app tokenize"
    python tokenize.py "$@"

%applabels tokenize
    Name tokenize
    Version 1.0

# ----------------------------------------

# Application 2: 'count_tokens'
%apprun count_tokens
    echo "Running python app count_tokens"
    python count_tokens.py "$@"

%applabels count_tokens
    Name count_tokens
    Version 1.0

# ----------------------------------------

# Application 3: 'classify_tokens'
%apprun classify_tokens
    echo "Running python app classify_tokens"
    python classify_tokens.py "$@"

%applabels classify_tokens
    Name classify_tokens
    Version 1.0

# ----------------------------------------

# Application 4: 'letter_counts'
%apprun letter_counts
    echo "Running python app letter_counts"
    python letter_counts.py "$@"

%applabels letter_counts
    Name letter_counts
    Version 1.0


```

#### The Build Script for the SIF

Create the bash script _run.build.sif_ as follows.

```
apptainer   build   --fakeroot   python_string.sif    multi_app.def
```

#### Commands/Scripts for Running the Codes Within the Container

The codes each take one string as the sole argument.
The string should be wrapped in double-quotes like this:

```
"What is your favorite color?"
```


For the _tokenize_ application, the script _run.app.tokenize.sif.sh_ contains

```
apptainer run  --app tokenize  python_string.sif  "How many football games will the Hokies win this year?"
```

You should see output:

```
Running python app tokenize
  The inputted string :  How many football games will the Hokies win this year?
  The tokens in the inputted string are:
How
many
football
games
will
the
Hokies
win
this
year?
```


For the _count_tokens_ application, the file _run.app.count_tokens.sif.sh_ contains

```
apptainer run  --app count_tokens  python_string.sif  "How many football games will the Hokies win this year?"
```

You should see output:

```
Running python app count_tokens
  The inputted string :  How many football games will the Hokies win this year?
  The number of tokens in the inputted string are: 10
```

For the _classify_tokens_ application, the file _run.app.classify_tokens.sif.sh_ contains

```
apptainer run  --app classify_tokens  python_string.sif  "How many football games will the Hokies win this year?"
```

You should see output:

```
Running python app classify_tokens
  The inputted string :  How many football games will the Hokies win this year?
  The number of tokens that start with a vowel is :  0
  The number of tokens that start with a consonant is :  10
```


For the _letter_counts_ application, the file _run.app.letter_counts.sif.sh_ contains

```
apptainer run  --app letter_counts  python_string.sif  "How many football games will the Hokies win this year?"
```

You should see output:

```
Running python app letter_counts
  The inputted string :  How many football games will the Hokies win this year?
  Number of characters in string :  54
  Letter occurrences counts are :
  letter :   H   count :  2
  letter :   o   count :  4
  letter :   w   count :  3
  letter :   m   count :  2
  letter :   a   count :  4
  letter :   n   count :  2
  letter :   y   count :  2
  letter :   f   count :  1
  letter :   t   count :  3
  letter :   b   count :  1
  letter :   l   count :  4
  letter :   g   count :  1
  letter :   e   count :  4
  letter :   s   count :  3
  letter :   i   count :  4
  letter :   h   count :  2
  letter :   k   count :  1
  letter :   r   count :  1
  letter :   ?   count :  1
```




#### Python Stand-Alone Codes

Not included in these codes, but easy enough to do---and
it should be done---is to check that there is one 
CLA in the invocation and that it is a string.

Code _tokenize.py_:

```
import sys

my_string=sys.argv[1]
tokens = my_string.strip().split()
num_tokens = len(tokens)

print("  The inputted string : ",my_string)
print("  The tokens in the inputted string are:")

for itime in range(0, num_tokens):
    print(tokens[itime])
```

Code _count_tokens.py_:

```
import sys

my_string=sys.argv[1]
tokens = my_string.strip().split()
num_tokens = len(tokens)

print("  The inputted string : ",my_string)
print("  The number of tokens in the inputted string is:", len(tokens))
```


Code _classify_tokens.py_:

```
import sys

my_string=sys.argv[1]

counter_vowel=0
counter_consonant=0

tokens = my_string.strip().split()
num_tokens = len(tokens)

print("  The inputted string : ",my_string)

for itime in range(0, num_tokens):
    itoken = tokens[itime]
    if itoken[0] in "aeiou":
        counter_vowel += 1
    else:
        counter_consonant += 1

print("  The number of tokens that start with a vowel is : ",counter_vowel)
print("  The number of tokens that start with a consonant is : ",counter_consonant)
```



Code _letter_counts.py_:

```
import sys

my_string=sys.argv[1]

d_letter_count = dict()

len_string = len(my_string)

print("  The inputted string : ",my_string)

print("  Number of characters in string : ",len_string)

for itime in range(0, len_string):
    ichar = my_string[itime]

    # Do not allow non-alphabetic characters.
    if ichar == " " or ichar == "." or ichar == ",":
        continue

    if ichar not in d_letter_count:
        d_letter_count[ichar]=1
    else:
        d_letter_count[ichar] +=1

print("  Letter occurrences counts are :")

for ikey in d_letter_count:
    print("  letter :  ", ikey, "  count : ",d_letter_count[ikey])
```


