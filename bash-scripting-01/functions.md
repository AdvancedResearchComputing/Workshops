
# "Subshells and Functions"
[Previous Section > Variables and Arrays](./variables.md)
#### Teaching: 30
#### Exercises: 10

#### Questions:
  - "How can you organise your code into functional blocks?"
  - "How can you import settings from other files into your scripts?"

#### Objectives:
  - "Explain how BASH functions operate"
  - "Explain the difference between local and global variables"
  - "Explain how to import bash files into your environment"

#### Key points:
  - environment variables are accessible by all programs run from that shell
  - `export` turns a (private) shell variable into an environment variable
  - `()` creates a subshell
  - `{}` creates a code block within the current shell
  - `$()` allows a subshell to be used for command substitution, for saving the output as a variable
  - `<()` allows a subshell to be used for process substitution, for passing the output to another program
  - `read var1 var2 <<<$()` can be used to save more than one output from a command substitution
  - `function NAME() {}` creates a function code block
  - code inside functions are not executed on creation, and can be used repeatedly after creation
  - `. script.sh` and `source script.sh` enable the importing of code and variables from other scripts


## Shell and Environment Variables

[comment]: # (In the shell novice course you were introduced to writing and using shell scripts,)
[comment]: # (http://swcarpentry.github.io/shell-novice/06-script/index.html)

When a shell process is created (e.g. a script is launched), an **environment** is created that holds variables needed for the shell to interact with the OS (home directory, display, etc.).  

* **Environment (global) variables** – visible to *all* processes in that environment.  
* **Shell (local) variables** – visible **only** to the process that created them.

A subshell (a new process) does **not** inherit the *shell* variables of its parent unless they are exported.

```bash
# test.sh
echo $var1
echo $var2
```

```bash
var1=23
export var2=12
bash test.sh
```

```
12
```

`export` turns a shell variable into an environment variable, making it visible to child processes.

**Exploring Environment Variables**  
List all exported variables with:  
```bash
declare -px
```  


Environment variables are also accessible from other languages, e.g.:

```bash
python -c "import os; print(os.environ['var2'])"
```

Similar mechanisms are available in R, Matlab, and many other environments.

## Subshells

A **subshell** runs in a **new process** created with `()`. It inherits a *copy* of the parent’s environment, but changes inside the subshell do **not** affect the parent.

```bash
x=5 ; (echo $x)
```

```
5
```

```bash
x=5 ; (echo $x; x=3; y=2; echo $x $y) ; echo $x $y
```

```
5
3 2
5
```

### Code blocks `{}`

Curly braces create a **code block** *without* forking a new process. Changes to variables persist after the block ends.

```bash
x=5 ; { echo $x; x=3; y=2; echo $x $y; } ; echo $x $y
```

```
5
3 2
3 2
```

> [!NOTE]
> Unlike C/C++, Bash `{}` blocks do **not** introduce a new scope; they share the same variable space.  


## Command Substitution

Capture the output of a command (run in a subshell) with `$()`:

```bash
x=4; echo $x; x=$(y=5; echo $x$y); echo $x
```

```
4
45
```

> [!NOTE]
> **Back‑quotes are deprecated** – use `$()` instead.  


### Exercise: Date variables

Jon wants the current **year, month, and day** as variables.

<details>
<summary>Solution</summary>

```bash
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
```
</details>

Now for **yesterday’s** date:

<details>
<summary>Solution</summary>

```bash
PREV_YEAR=$(date -d "-1 day" +%Y)
PREV_MONTH=$(date -d "-1 day" +%m)
PREV_DAY=$(date -d "-1 day" +%d)
```
</details>

### Using the dates in a script

Update `manunicast_download.sh` to use today’s date in the URL.

<details>
<summary>Solution</summary>

```bash
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

PREV_YEAR=$(date -d "-1 day" +%Y)
PREV_MONTH=$(date -d "-1 day" +%m)
PREV_DAY=$(date -d "-1 day" +%d)

WEBROOT="http://manunicast.seaes.manchester.ac.uk/charts/manunicast/"

ADDRESS="${WEBROOT}${YEAR}${MONTH}${DAY}/d02/meteograms/meteo_ABED_${PREV_YEAR}-${PREV_MONTH}-${PREV_DAY}_1800_data.txt"
wget "$ADDRESS"
```
> [!TIP]
> *Tip*: Wrap variable names in `${}` and the whole string in quotes to avoid word‑splitting issues.  

</details>

## Process Substitution

`<()` feeds the output of a command to another command **as if it were a file**.

```bash
diff <(echo 3) <(echo 5)
```

```
1c1
< 3
---
> 5
```

Nesting works as expected:

```bash
cat <(echo "year is $(date +%Y)") \
    <(echo "month is $(date +%m)") \
    <(echo "day is $(date +%d)")
```

```
year is 2024
month is 07
day is 18
```

More details: <https://www.tldp.org/LDP/abs/html/subshells.html>

## Functions

Functions are labelled code blocks that can be reused.

```bash
functionname () {
    commands
}
# or
function functionname () {
    commands
}
```

Functions can read, modify, and create variables in the current shell.

```bash
var1='E'
examplechange () { var1='D'; }
echo $var1   # → E
examplechange
echo $var1   # → D
```

### Arguments

```bash
readingargs () { echo $#; echo $1; echo $2; }
readingargs "arg1" "arg2"
```

```
2
arg1
arg2
```

### Local variables

```bash
combineargs () { local var1=$1$2; echo $var1; }
var1="start"
var2="end"
combineargs $var1 $var2
echo $var1   # → start (unchanged)
```

```
startend
start
```

If `local` is removed, both `var1` and `var1` in the caller are overwritten, producing:

```
startend
startend
```

### Returning values

Use `echo` and capture the output.

```bash
funcresult="$(combineargs $var1 $var2)"
echo "$funcresult"
```

```
startend
```

Multiple values can be read into separate variables:

```bash
read arg1 arg2 <<<$(returnargs "start here" "end")
echo "$arg1"
echo "$arg2"
```

<details><summary> **Solution**  </summary>
The first word goes to `arg1`; the remainder (including spaces) goes to `arg2`.  
```
start
here end
```  
Be careful: any whitespace inside a returned field will be split, and extra fields are appended to the last variable.  
</details>

### Return status

`return $N` sets the function’s exit status (useful for error checking), but it **does not** pass data back to the caller.

## Functionalising the date commands

Create a reusable date‑offset function.

Use it like:

```bash
read year month day <<<$(determine_next_date - 1 $year $month $day)
```

<details>
<summary>Solution</summary>

```bash
determine_next_date () {
    # usage: determine_next_date [+/-] [#days] [year] [month] [day]
    local next_year=$(date -d "$3$4$5 $1 $2 day" +%Y)
    local next_month=$(date -d "$3$4$5 $1 $2 day" +%m)
    local next_day=$(date -d "$3$4$5 $1 $2 day" +%d)
    echo "$next_year $next_month $next_day"
}
```
</details>

## Sourcing Bash Scripts

Instead of invoking a script as a separate process, you can **source** it so that its code runs in the current shell:

```bash
. script.sh
# or
source script.sh
```

Sourcing is ideal for loading configuration variables or functions (e.g., `.bashrc`, `.bash_profile`) because it works in your current shell.

It can be problematic though, if the script being executed has any "early exit" functionality because the `exit` command will end the calling shell.

**Task** – Move `determine_next_date` to a separate file (`function_date_math.sh`), source it, and verify it still works.  

<details>
<summary>**Solution**</summary>
Create `function_date_math.sh` containing the function definition above, then in your main script add:

```bash
source ./function_date_math.sh
read year month day <<<$(determine_next_date - 1 $year $month $day)
```

Test with `date` and `echo $year $month $day` to confirm the values are correct.  
</details>
---
[Next Section > Logic and Math](./logic_and_math.md)