# Input-Output Redirection

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)


#### References.

See [https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents](https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents)

See [https://www.gnu.org/software/bash/manual/html_node/Redirections.html](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

# Background

### Motivation

A computer program can be written to take inputs
from the computer screen (terminal window) and to write outputs to the
computer screen (terminal window).
Then the shell can wrap the computer program, without modifying
the program, so that inputs can be read from files and outputs
written to files.
The shell does this by manipulating file handles for
duplicating,
opening,
closing,
and
changing references.


### Basics

- Standard input (stdin) is file descriptor 0.
- Standard output (stdout) is file descriptor 1.
- Standard error (stderr) is file descriptor 2.
- The symbol "<" refers to the stdin file descriptor.
- The symbol ">" refers to the stdout file descriptor.
- The symbols "2>" refers to the stderr file descriptor.
- The symbols ">>" mean to append to file descriptor that is stdout.
- The symbol "|" means piping, i.e., send the output of the previous command as
input to the next command.

# Examples


### Redirect output

The command

~~~
ls
~~~
{:  .language-bash}

will write results to the terminal window


The command

~~~
ls > mydircontent
~~~
{:  .language-bash}

will write results to the _file_ mydircontent.


### A more detailed example


The command.

~~~
ls > dirlist 2>&1
~~~
{: .language-bash}

This command generates the output from `ls` and redirects it from
the terminal window, where it would normally be displayed,
to file dirlist.
This is because ">" means write to stdout.
Then, "2>&1" is parsed like this:  "2>" meaning for stderr,
assign stderr to the same handle (file descriptor) as "&1,"
where "&1" means a reference to stdout.

Our second command.


~~~
ls 2>&1 > dirlist
~~~
{: .language-bash}

This command first assigns stderr (i.e., "2>") to the same
file descriptor as stdout ("&1").
The default stdout is the terminal window, so now stderr
is written to the terminal window (which, in the default scenario,
stderr would already be written to the terminal window).
Then, "> dirlist" means that stdout is now changed from the
terminal window to a file called dirlist.



### Redirect input

Let company.data contain


~~~
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
~~~
{:  .output}

Then

~~~
head -n 4 < company.data
~~~
{:  .language-bash}

produces

~~~
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
~~~
{:  .output}


### Repeatedly redirect output (append)

The operator `>>` means append.

`$RANDOM` generates a random number (integer) between 0 and 32768 (=2**15).


~~~
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
~~~
{:  .language-bash}


The output (for the executions on my cluster) consists
of four lines in file myRandomNumbers
To list the four lines,

~~~
cat myRandomNumbers
~~~
{:  .language-bash}

and it should show something similar to this (the actual numbers
will vary):

~~~
Random number:  31804
Random number:  2584
Random number:  4114
Random number:  13550
~~~
{:  .output}


### Redirecting standard output and standard error at one time.

We use the `&>` operator.

For a cluster that has a module system installed,
and it is active when logging on to the machine,
then a very common action is


~~~
module avail &> all.modules.<date>
~~~
{:  .language-bash}

In file _all.modules.<date>_, all of the available modules
on the system will listed.
This is useful because when there are a lot of modules,
it is easy to search the file for modules of interest to
determine whether they exist.

The command above is equivalent to `module avail >> all.modules.<date>  2>&1`.

The output can look something (crudely) like this, listing only
the first 20 lines using `head -n 20 all.modules.owl.head.17.jun.2024`:


~~~

------------------------------------------------- /cm/local/modulefiles --------------------------------------------------
   apps              (L)    cmd               gcc/11.2.0         mariadb-libs    openldap        slurm/slurm/23.02.7 (L)
   boost/1.77.0             cmjob             ipmitool/1.8.18    module-git      python3
   cluster-tools/9.2        dot               lua/5.4.6          module-info     python39
   cm-bios-tools            freeipmi/1.6.8    luajit             null            shared   (L)

------------------------------------------------- /usr/share/modulefiles -------------------------------------------------
   DefaultModules (L)

------------------------------------------------- /cm/shared/modulefiles -------------------------------------------------
   blacs/openmpi/gcc/64/1.1patch03    hdf5_18/1.8.21                              mpich/ge/gcc/64/3.4.2
   blas/gcc/64/3.10.0                 hpl/2.3                                     mvapich2/gcc/64/2.3.7
   bonnie++/2.00a                     hwloc/1.11.11                               netcdf/gcc/64/gcc/64/4.8.1
   cm-pmix3/3.1.4                     hwloc2/2.7.1                                netperf/2.7.0
   cm-pmix4/4.1.1                     intel-cluster-runtime/ia32/2019.6           openblas/dynamic/0.3.18
   default-environment                intel-cluster-runtime/intel64/2019.6 (D)    openmpi/gcc/64/4.1.2
   fftw3/openmpi/gcc/64/3.3.10        intel-tbb-oss/ia32/2021.4.0                 openmpi4/gcc/4.1.2
   gdb/10.2                           intel-tbb-oss/intel64/2021.4.0              ucx/1.10.1
   globalarrays/openmpi/gcc/64/5.8    iozone/3_492
~~~
{:  .output}


### Appending to standard output and standard error at one time.

We use the `&>>` operator, which is akin to the `&>` operator discussed
above.


~~~
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
~~~
{:  .language-bash}


The output (for the executions on my cluster) consists
of four lines in file myRandomNumbers
To list the four lines,

~~~
cat myRandomNumbers02
~~~
{:  .language-bash}

and it should show something similar to this (the actual numbers
will vary):

~~~
Random number:  22161
Random number:  23270
Random number:  31012
Random number:  13850
~~~
{:  .output}


### Here strings and use of `<<<` operator.

The command inputs the string on the right of the command,
and substitutes in a tab for each whitespace character:

~~~
tr [:space:] "\t" <<< "Virginia Tech Go Hokies"
~~~
{:  .language-bash}

and it should show something similar to this
(variable spacing between words, based on tabs):


~~~
Virginia	Tech	Go	Hokies
~~~
{:  .output}

### Piping

Piping is a way to daisy-chain (i.e., sequence) several commands together to
accomplish some task.
In this chain, the output from the previous command is input to the
next command.

We provide it here because, strickly speaking, it is a tool
for redirecting output of one operation to be the input of
the next.

But we presented it earlier because it is so useful.



{% include links.md %}

