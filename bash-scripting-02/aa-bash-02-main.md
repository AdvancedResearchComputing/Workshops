# Bash Scripting--II


## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help and access to information, and links to those resources, are provided.

## Overview

Bash scripting.

> [!NOTE]
Most/many/all of the commands and examples given can be execute 
at the command line.
Even on the head nodes.
This is because the examples are very small and put almost zero load
on the system.

> [!NOTE]
You should try every example for the material that is of use
to you.
The reason to make this obvious statement is that
many/most (??) examples are incredibly fast to execute.
For these examples, you copy ALL of the contents of each example and paste ALL
of it into the terminal screen at once.
That is, for a 6-line example, you do not copy and paste
each individual line.
Rather, you copy it all, at once.
Then you paste at the command prompt on a terminal window and
hit return, and all of it will execute.
You can even run these on a head node because the examples run so fast
and take such few resources.
Many/most examples are that simple to execute:  copy and paste.

> [!NOTE]
We call this workshop "bash scripting."
A lot of people use this term.
But note that this topic encompasses multiple categories:

1. bash, which is a programming language (PL) because it has:
  - syntax
  - semantics
  - pragmatics.
2. utilities
  - there are many utilities that can be executed on their own.
  - they can also be execute right in a bash script---seamlessly.
  - they are incredibly powerful and add massively to the 
    bash-provided feature set.

> [!NOTE]
One of the reasons that (bash) scripting is so widely used is because 
of its compactness.
You can do a lot of work with a single or a few commands.
When commands are being presented and examples are given,
you might want to ask yourself:  How many lines of code would this
take if I had to write a code in Python or C to do the same work?


## Outline

1. [Control Structures:  IF Blocks](./control-structures-if.md)
2. [Control Structures:  CASE Blocks](./control-structures-case.md)
3. [Control Structures:  FOR Blocks](./control-structures-for.md)
4. [Control Structures:  WHILE Blocks](./control-structures-while.md)
5. [Iterating Over Collections](./iterating-over-collections.md)
6. [Input-Output Redirection](./io-redirection.md)
7. [Program Input-Output](./program-io.md)
8. [awk utility](./awk.md)