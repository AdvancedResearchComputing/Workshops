# "Motivation for Bash Scripting and Learning Objectives"
#### teaching: 20
#### exercises: 0
#### questions:
  - "Why should I spend my time learning bash scripting?"
#### objectives:
  - "What are the advantages of bash scripting."
  - "What are the disadvantages of bash scripting."
#### keypoints:
  - "Bash is a programming language, i.e., it has all of the control structures of a modern PL."
  - "It also has supporting methods that are powerful, analogous to packages and libraries in Python."
  - "But it does not have the IDE support and environments that most modern PLs have."
  - "So writing `big` codes with bash is really not done."
  - "The language is compact:  you can do a lot with a little code.  But it can be obtuse to read and understand."
  - "One of the key points is to learn when bash is appropriate, and when more sophisticated programming approaches are warranted."
  - "Finally, bash helper methods are not 'successive' in the sense that if you are using one command in a bash script and you are adding incremental features, you may incorporate more switches into the one command.  But, you may reach a point where adding the next features takes you to a different command."
  - "In bash, there is usually more than one way to do a job."
---

# Background  

## Motivation  

### Candidate Users  

Bash scripting is useful for:

- Software developers.  
- Software users.  
- Data scientists.  
- Data generators.  
- Data analysts.  

These types of jobs are prevalent in all kinds of engineering, science, business, law, and humanities.

### High Level Ideas:  Best Practices  

Think about automating your jobs (rather than “by‑hand” manipulation).

**Why?**

1. Faster in the long run.  
2. Provides reproducibility.  
3. Provides (at least partial) provenance.  
4. Conveys ideas to other users faster.  
5. Easier to share what you have done and others might do likewise.

### Key Positive Features  

Key features of bash (scripting) are:

1. Highly portable.  
2. Has all of the features of a (modern) programming language.  
3. Many operations have compact syntax (which can also be a negative).  
4. It is mainly used for string and text manipulation, versus number crunching.  
5. It can be used to create/delete files and directories, so it can set up your file structure.  
6. There is a group of helper methods that can be used seamlessly with bash that give bash a lot of power.  
7. Because of these helper methods, there is usually more than one way to accomplish a task.  
8. As an example of compactness in a good way, "workflows" can be built with small amounts of code using “piping” (`|`).  
9. Although bash scripting is not used for large codes because other PLs provide much better capabilities, it is a very powerful **complement** to these PLs and larger codes (e.g., for building and altering configuration, input, and output files).  
10. This is why entire bodies of research can be done using large pre‑existing computer programs (e.g., ABACUS and ANSYS) and bash scripting.  
11. Several (many?) of the commands are optimized for compute hardware and hence run fast even on very large data sets.

### Key Negative Features  

1. It does not have the development environments that other PLs have.  
2. Default behavior can be bad: in some cases, if a variable assignment is erroneous, the command will be skipped and program execution will continue on without the user realizing the problem.  
3. Hence, error handling is not great.  
4. Debugger support not great.  
5. Consequently, bash scripts are commonly small and do one particular job.  
6. As a consequence, you do not see a lot of bash code that contains many functions (methods, subroutines).  
7. It is not the language of choice for computational codes.

# Learning Objectives  

A working knowledge of:

1. `linux/unix` `date` command  
2. `cron` jobs  
3. `wget` for downloading files  
4. Bash variables and assignments  
5. Shell and environment variables, variable visibility, subshells, and code blocks  
6. Process substitution  
7. Functions  
8. Sourcing (`source`) scripts  
9. Math operations (mostly integers)  
---
Second session - this afternoon:
---
10. Control structures: `if`, `for`, `while`, `case`  
11. `sed`  
12. `awk`  
13. Sorting  
14. Program input and output  
15. Other useful commands  
16. Real examples  

# “Best” Practices  

Often bash scripts are suitable to complete “helper” tasks.

### Examples  

1. Straight‑forward pre‑processing of data.  
2. Straight‑forward post‑processing of data.  
3. Creating files from templates.  
4. Creating files from scratch.  
5. Simple control of workflows (e.g., a sequence of activities/codes).  
6. Performing checks of codes or data.  
7. Checking the status of jobs.  

### Bash Scripting Versus Python  

If bash is so great, should I use bash for all programming of “helper” tasks? **No.**

There are trade‑offs.  I think of bash vs. Python.

**Bottom line:**

1. If I am doing sophisticated operations a lot, or have many functions, I will use Python.  
2. If I need real numbers (vs. integers), I will use Python—period.  
3. If I am going to write ~200 lines of code or more, I will use Python.  
4. If I think I will need a debugger, I will use Python.  

**Why not just ditch bash?**

1. Bash is great in the sense that a lot of work can be done with one or two lines of code; it is very compact, in some respects.  
2. You can embed other utilities (e.g., `sed`, `awk`, piping) into bash scripts to get even more done with little code.  
3. Bash has a lot of file I/O (input/output) options.  
4. When bash works, it “shines.”

# Further Help / Courses  

Carpentries workshops are presented by VT University Libraries.  
They teach an introductory UNIX course.  

**Next course offering:**  See the TLOS website to register.

# Additional Documentation  

There are several thorough‑looking bash scripting guides on the internet. Here are some:

- <https://tldp.org/LDP/abs/html/index.html>  
- <https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html>  
- <https://www.gnu.org/software/bash/manual/html_node/>

----------------------------
[Next Section > Dates](./dates.md)