# "Dates"
[Previous Section > Intro](./intro.md)
#### teaching: 10
#### exercises: 5
#### questions:
  - "How can we deal with date maths on the command line"
#### objectives:
  - "Understanding some of the tools available for addressing regular needs."
#### keypoints:
  - "Using `date` for your date and time calculations will save you a lot of hassle"
  - "Tool syntax is not always consistent across different unix flavours"
---

## Date maths

On UNIX systems the system time and date information can be found using the `date` command:

```bash
date
```

```
Wed 27 Jan 2021 11:52:17 GMT
```

This will return a formatted string (likely) containing information on the day, date, time, and timezone, as shown above.

The command can be used for more than just finding the current time, though. It can also create formatted strings containing other dates and times, as well as calculate dates relative to either the current time or another given time. Below is a short introduction on how to use this command on Linux systems.

> **Linux vs OSX**  
> Although all UNIX systems will have a `date` program, the exact syntax for using it can vary from system to system, due to differing implementations of the Unix standards. The two systems you are most likely to encounter are Linux‑based systems (such as Debian, and RHEL) and the freeBSD‑based macOS system. These use quite different syntaxes, so care must be taken to use the correct syntax for the system you are on.  
> Below we will focus on the Linux syntax, as this is most common for HPC environments. Where the macOS syntax is different this will be highlighted in a separate note.

The output string for the `date` command can be formatted by adding `+[format string]`. The options are defined in the `date` man page, but some common ones are:

* `%Y` – four‑digit year  
* `%m` – two‑digit month  
* `%d` – two‑digit day of month  

These can be used individually, or combined as you wish. For example:

```bash
date +%Y
```

```
2024
```

```bash
date +%Y-%m
```

```
2024-07
```

```bash
date +"%Y %d"
```

```
2021 27
```

In the last example we enclose the format string in quotation marks to preserve the space in the formatted output.

To display a date that is not “now”, you can use `-d [date string]`. The most convenient date string for our purposes is `YYYYMMDD`, e.g.:

```bash
date -d "20120423"
```

```
Mon Apr 23 00:00:00 EDT 2012
```

> **Displaying dates that are not “now” on macOS**  
> On macOS, you have to explicitly set the format of the date string that you pass to `date`, using `-f "[format string]" "[date string]"`. You also need to prevent `date` from resetting the system clock by passing the `-j` flag. The macOS equivalent to the Linux command above is:  
> ```bash
> date -j -f "%Y%m%d" "20120423"
> ```

### Date Offsets

To calculate an offset from a given date (either “now” or a supplied date), add the desired offset into your date string. The offset can be composed of several elements, for example:

```bash
date -d "20210127 +3 day +1 month -18 year"
```

```
Sun Mar  2 00:00:00 EST 2003
```

The advantage of using `date` for this calculation is that it automatically handles month‑ and year‑boundary transitions—something that would require a lot of manual checks for month lengths, leap years, etc.

You can pass the `--debug` flag to `date` if you would like an explanation of how it is parsing the date:

```bash
> date -d "this monday + 1 month" --debug
date: parsed day part: this Mon (day ordinal=0 number=1)
date: parsed relative part: +1 month(s)
date: input timezone: system default
date: warning: using midnight as starting time: 00:00:00
date: new start date: 'this Mon' is '(Y-M-D) 2026-03-16 00:00:00'
date: starting date/time: '(Y-M-D) 2026-03-16 00:00:00'
date: warning: when adding relative months/years, it is recommended to specify the 15th of the months
date: after date adjustment (+0 years, +1 months, +0 days),
date:     new date/time = '(Y-M-D) 2026-04-16 00:00:00'
date: '(Y-M-D) 2026-04-16 00:00:00' = 1776312000 epoch-seconds
date: timezone: system default
date: final: 1776312000.000000000 (epoch-seconds)
date: final: (Y-M-D) 2026-04-16 04:00:00 (UTC)
date: final: (Y-M-D) 2026-04-16 00:00:00 (UTC-04)
Thu Apr 16 12:00:00 AM EDT 2026
```

> **Offset calculation order**  
> The calculation proceeds from the largest incremental unit downward. This is most important when the offset crosses month boundaries, but it can be relevant in other scenarios as well.

> **Calculating date offsets on macOS**  
> On macOS, each offset element is supplied as a separate string preceded by `-v`. The elements are applied in the order you provide them, giving you explicit control over the process. The macOS equivalent to the Linux command above is:  
> ```bash
> date -j -v "-18y" -v "+1m" -v "+3d" -f "%Y%m%d" "20210127"
> ```

---
[Next Section > cron and wget](./cron-wget.md)