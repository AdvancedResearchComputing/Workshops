# "Variables and Arrays"
[Previous Section > Cron and Wget](./cron-wget.md)
#### teaching: 10
#### exercises: 5
#### questions:
  - "How can I store information without writing it to file"
#### objectives:
  - "Learn how to create and reference a variable"
  - "Learn how to create and reference an indexed array"
#### keypoints:
  - "BASH variables can store a single piece of information"
  - "BASH arrays can store an indexed lists of information"
  - "`{}` denotes a code block, and are essential for referencing arrays"
  - "`[@]` denotes all of an array, while `[X]` denotes the value at position `X`"
  - "`${#VAR}` returns the length of the string"
  - "`${#ARRAY[@]}` returns the number of items in the array"
---

## Variables

[comment]: # (In the shell novice course you were, indirectly, introduced to bash variables, when working)
[comment]: # (with loops: http://swcarpentry.github.io/shell-novice/05-loop/index.html)

Assign a value to a variable and print it. Assignment means using the `=` sign **with no spaces on either side of the sign**.

```bash
school="longview"
echo "my school is ${school}."
```

```
my school is longview.
```

- No spaces around `=`  
- Double‑quotes protect spaces inside the value  
- Use `$` (or `${}`) **only when reading** the variable, not when assigning it  

To obtain the value, prefix the name with `$` (curly braces are optional but avoid parsing ambiguities):

```bash
echo ${school}
```

```
longview
```

### Simple loop example

```bash
for thing in list of things
do
  echo ${thing}
done
echo 'variables persist:' ${thing}
```

```
list
of
things
variables persist: things
```

Variables can also be defined directly inside a script:

```bash
echo ${thing}
thing=this
echo ${thing}
```

```
things
this
```

**Exploring Shell Variables**  
Use `declare -p` to see a variable’s definition. Pipe the output to `grep` or `less` to find what you need.  
```bash
declare -a arrayName   # declares arrayName as an array
declare -r var01       # makes var01 read‑only
declare -g myGlobalVar="I am a global."  # global variable
```  


To delete a variable, use `unset` **without** the `$` prefix:

```bash
thing=stuff
unset thing
```

**Referencing a non‑existent variable**  
What happens if you reference a variable that doesn’t exist?  
```bash
thing=stuff
unset thing
echo ${thing}
```  
<details><summary>**Solution**</summary> – it expands to an empty string (no error).
</details>  

## Arrays

BASH arrays store an indexed list of values.

```bash
listthings=( these are my things )
```

**Whitespace warning**  
Spaces separate array elements. To keep spaces inside an element, quote it:  
```bash
listthings=( these "are my" things )
```  

Show the array definition with `declare -p`:

```bash
declare -p | grep -w listthings
```

```
declare -a listthings='([0]="these" [1]="are my" [2]="things")'
```

### Referencing Arrays

| Command                                 | Output | Explanation |
|----------------------------------------|--------|-------------|
| `echo ${listthings[1]}`                | `are my` | Value at index 1 |
| `echo $listthings[1]`                  | `these[1]` | `$listthings` expands to the first element (`these`), then the literal `[1]` is appended |
| `echo ${listthings[@]}`                | `these are my things` | All elements joined by spaces |
| `echo $listthings`                     | `these` | Same as `${listthings[0]}` |
| `echo ${#listthings[@]}`               | `3` | Number of elements in the array |

<details><summary>**Expand for Solutions**</summary>
1️⃣ `are my` </br>
2️⃣ `these[1]` </br>
3️⃣ `these are my things`</br>
4️⃣ `these`</br>
5️⃣ `3`
</details>


### Looping over an array:

```bash
for thing in ${listthings[@]}
do
  echo ${thing}
done
```

Output (note that the element `"are my"` is split because it isn’t quoted in the loop):

```
these
are
my
things
```

### Verify, Verify, Verify

Readability matters for any language, including Bash. Always double‑check that your variables contain what you expect before using them in larger scripts.


[Next > Subshells and Functions](./functions.md)