# Input-Output Redirection

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)


#### References.

See [https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents](https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents)

See [https://www.gnu.org/software/bash/manual/html_node/Redirections.html](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

#### Background

#### Motivation

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
- The symbol `<` refers to the stdin file descriptor.
- The symbol `>` refers to the stdout file descriptor.
- The symbols `2>` refers to the stderr file descriptor.
- The symbols `>>` mean to append to file descriptor that is stdout.
- The symbol `|` means piping, i.e., send the output of the current command as
input to the next command.

### Examples


#### Redirect Output

The command

~~~bash
ls
~~~

will write results to the terminal window


The command

~~~bash
ls > mydircontent
~~~

will write results to the _file_ **mydircontent*.


#### Redirect Output From Codes

Create the file _my_python.py_ with the one line below:

~~~python
print("  Hello ARC")
print("  Hey Abigail")
~~~

Run this code as follows:

~~~python
python my_python.py
~~~

When this code is run, the output appears in the terminal window.

Now, run the code again, but redirect the output to file _output.out_,
like so:

~~~python
python my_python.py >  output.out  
~~~

Note that the one redirect causes ALL output to be redirected to the 
specified output file _output.out_.



#### More Esoteric Examples


The command.

~~~bash
ls > dirlist 2>&1
~~~
{: .language-bash}

This command generates the output from `ls` and redirects it from
the terminal window, where it would normally be displayed,
to file _dirlist_.
This is because ">" means redirect the output.
Then, "2>&1" is parsed like this:  "2>" meaning for stderr,
assign stderr to the same handle (file descriptor) as "&1,"
where "&1" means a reference to stdout.

A second command.


~~~bash
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



#### Redirect Input

Let company.data contain


~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
dq          ice_cream     restaurant     national            3560
pge         natural_gas   energy         national           35640
hp          printers      business       international     456340
~~~


Then

~~~bash
head -n 4 < company.data
~~~

produces the first four lines of the file, thusly:

~~~output
xerox       copying       business       international    6000000
exxon       oil           energy         international   10000000
mcdonalds   fast_food     restaurant     international   11000000
chevron     oil           energy         international    5200000
~~~


#### Repeatedly Redirect Output (Append)

The operator `>>` means append.

`$RANDOM` generates a random number (integer) between 0 and 32768 (=2**15).

We are implicitly assuming that the file "myRandomNumbers does not exist.

In the example below, which is a very common pattern,
the file myRandomNumbers is instantiated with the `touch`
command, and the file is empty.
Subsequent "writes" to the files take the form of appends (`>>`)
so we are consistently updating the file with more information.

~~~bash
touch myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
echo "Random number:  ${RANDOM}"  >> myRandomNumbers
~~~



The output (for the executions on a cluster) consists
of four lines in file myRandomNumbers
To list the four lines,

~~~bash
cat myRandomNumbers
~~~


and it should show something similar to this (the actual numbers
will vary):

~~~output
Random number:  31804
Random number:  2584
Random number:  4114
Random number:  13550
~~~


#### Redirecting Standard Output and Standard Error At One Time.

We use the `&>` operator.

For a cluster that has a module system installed,
and it is active when logging on to the machine,
then a common action is


~~~bash
module avail &> all.modules.<date>
~~~

In file _all.modules.<date>_, all of the available modules
on the system will listed.
This is useful because when there are a lot of modules,
it is easy to search the file for modules of interest to
determine whether they exist.

The command above is equivalent to `module avail >> all.modules.<date>  2>&1`.

The output can look something (crudely) like this, listing only
the first 20 lines using `head -n 20 all.modules.owl.head.17.jun.2024`:


~~~output

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



### Appending Used To Redirect Standard Output and Standard Error at One Time.

We use the `&>>` operator, which is akin to the `&>` operator discussed
above.


~~~bash
touch myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
echo "Random number:  ${RANDOM}"  &>> myRandomNumbers02
~~~


The output (for the executions on my cluster) consists
of four lines in file myRandomNumbers
To list the four lines,

~~~bash
cat myRandomNumbers02
~~~

and it should show something similar to this (the actual numbers
will vary):

~~~output
Random number:  22161
Random number:  23270
Random number:  31012
Random number:  13850
~~~


# LEFT OFF

### Here strings and use of `<<<` operator.

The command inputs the string on the right of the operator `<<<`,
and substitutes in a tab for each whitespace character:

~~~bash
tr [:space:] "\t" <<< "Virginia Tech Go Hokies"
~~~


and it should show something similar to this
(variable spacing between words, based on tabs):


~~~output
Virginia	Tech	Go	Hokies
~~~

### Piping

Piping is a way to daisy-chain (i.e., sequence) several commands together to
accomplish some task.
In this chain, the output from the previous command is input to the
next command.

We provide it here because, strickly speaking, it is a tool
for redirecting output of one operation to be the input of
the next.

But we presented it earlier because it is so useful.



