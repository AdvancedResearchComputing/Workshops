# "BASH Maths"
[Previous Section > Subshells and Functions](./functions.md)
#### teaching: 30
#### exercises: 0
#### questions:
  - "How can we perform arithmetic in the BASH shell"

#### objectives:
  - "Detail maths operators."
  - "For both integer and floating point operations."

#### keypoints:
  - "`(( ))` is math context, and enables the use of C's integer arithmetic operators"
  - "`$(( ))` can be used in the same way as a command substitution"
  - "bash interprets `0X` strings as base 8, prefix strings or variables with `10#` to force base 10"
  - "`bc` can be used in bash to perform floating point calculations."

---

## Integer Math

The arithmetic operators that can be used within the math context are:

```text
  +  :  Addition
  -  :  Subtraction
  *  :  Multiplication
  /  :  Division
  ** :  Exponent
  %  :  Modulus
```

Bash variables are, in the general context, treated as strings. Integer maths can be carried out using **arithmetic expansion**, i.e., a maths context that tells the interpreter when to treat variables as numbers.  

The recommended form is `$(( ))`, which works like command substitution.

### Addition

```bash
i=3
j=$(($i + 1))
echo $j
```

```
4
```

You can also use the `(( ))` form:

```bash
a=3
((a=$a+7))
echo $a
```

```
10
```

Shorthand operators work as in C:

```bash
a=3
((a+=7))
echo $a
```

```bash
10
```

**let, expr and bc**  
Other programs can perform integer math, for example the "bash calculator" `bc`:

```bash
j=$(expr $i + 1)
let j=i+1
j=$(echo "$i+1" | bc)
```

In default operation, they obey the same integer‑math rules but lack the safety of the `$(( ))`/`(( ))` math context, so they are not covered further other than to note that it can be handy to have an interactive calculator in the shell:

```bash
bc -il
bc 1.07.1
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006, 2008, 2012-2017 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
2^30/10^9
1.07374182400000000000
pi = a(1)*4
c(pi/3)
.50000000000000000001
```


### Subtraction

```bash
i=13
j=$(($i - 7))
echo $j
```

```
6
```

Negative results work as expected:

```bash
i=2
j=$(($i - 7))
echo $j
```

```
-5
```

### Multiplication

```bash
i=11
j=$(($i * 7))
echo $j
```

```
77
```

### Division (integer)

```bash
i=77
j=$(($i / 7))
echo $j
```

```
11
```

Division discards the fractional part:

```bash
i=32
j=$(($i / 5))
echo $j
```

```
6
```

### Exponentiation

```bash
i=2
j=3
k=$(($i ** $j))
echo $k
```

```
8
```

### Modulo (remainder)

```bash
i=32
j=5
k=$(($i % $j))
echo $k
```

```
2
```

## Floating point arithmetic

Bash itself only does integer arithmetic. For floating‑point calculations use the external calculator **`bc`**.

### Division

```bash
i=32
j=5
k=$(bc <<<"scale=6; ${i}/${j}")
echo $k
```

```
6.400000
```

`scale=6` sets the number of digits after the decimal point.

### Multiplication

```bash
i=1.2
j=4.3
k=$(bc <<<"scale=3; ${i} * ${j}")
echo $k
```

```
5.16
```

### Subtraction

```bash
i=1.2
j=4.3
k=$(bc <<<"scale=3; ${j} - ${i}")
echo $k
```

```
3.1
```

### Gotcha – truncation

```bash
i=1.2
j=4.3
k=$(bc <<<"scale=0; ${j} - ${i}")
echo $k
```

```
3.1
```

Even with `scale=0` the result is not truncated to an integer; `bc` still prints the fractional part.

## Operators

C’s bitwise operators and the ternary operator are available in Bash arithmetic, but they are beyond the scope of this lesson.

## Integer / String Conversions

Leading zeros are common in strings that represent numbers (e.g. dates). Bash treats numbers that start with `0` as **octal** (base 8) and those that start with `0x` as hexadecimal. This can cause errors:

```bash
x=05
y=08
echo $(($x+$y))
```

```
-bash: 05+08: value too great for base (error token is "08")
```

Force base‑10 by prefixing the number with `10#`:

```bash
x=05
y=08
echo $((10#$x + 10#$y))
```

```
13
```

(Works only for non‑negative numbers.)

### Formatting numbers with leading zeros

Use `printf` to produce zero‑padded strings:

```bash
day=5
printf "day number %.2i\n" $day
```

```
day number 05
```

---

[Next Section > Symlinks](./symlinks.md)