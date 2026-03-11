# "Scheduling Recurring Jobs and Downloading Files"
[Previous Section > Dates](./dates.md)
#### teaching: 10
#### exercises: 5
#### questions:
  - "How can we schedule regular compute jobs"
  - "How can we download files outside of a web-browser"
#### objectives:
  - "Understanding some of the tools available for addressing regular needs."
#### keypoints:
  - "`crontab` can be used for scheduling regular tasks"
  - "`wget` can be used for scripting your data download process"
  - "Tool syntax is not always consistent across different unix flavours"
---

## Scheduling tasks with CRON

Often workflows need to be repeated at regular intervals—checking for updates in source data, running maintenance tasks, or producing regular updates to services. These tasks can be automated using the [cron](https://en.wikipedia.org/wiki/Cron) job scheduler. Cron is available on most UNIX‑based systems (although, on many HPC platforms, access to cron will be blocked for ordinary users). You can find out if you have it installed (and what tasks you have scheduled) using the `crontab` (cron table) command:

```bash
crontab -l
```

To configure cron it is easiest to create a configuration file, which will be read simply using the command:

```bash
crontab [config.txt]
```

Each line of this file will represent a job, and will look like:

```text
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * <command to execute>
```

This notation can be a little confusing, but online tools such as [crontab.guru](https://crontab.guru/) are available for checking your configurations, to ensure that cron will run jobs at the times you expect.

> **Scheduling jobs**  
> Jon wants to set two data download tasks, one to run at 2:45 am every Monday, and one which runs at 2:00 pm on the 1st and 15th of each month. What notation should he use to set these jobs (you can use [crontab.guru](https://crontab.guru/) to work it out)?  
>   
> **Solution**  
> - `45 2 * * 1` – 2:45 am on every Monday  
> - `00 14 1,15 * *` – 2 pm on the 1st and 15th of the month  
> {: .solution}
> {: .challenge}

> **OS‑X and cron**  
> macOS does include cron, but it is difficult to use because of the security settings. If you wish to use cron on macOS you will need to enable Full Disk Access within the *Security & Privacy* settings menu for the program `/usr/sbin/cron`.  
> {: .callout}

## Example

I want to create a cron job that writes the date to the same file, appending the new info, every day at midnight.

First I list my current cron jobs:

```bash
crontab -l
```

To specify a new cron job, first set up a new file:

```bash
touch myCronOutput
```

This creates an empty file so that our cron job can write into it.

Now specify the cron job by editing your cron table:

```bash
crontab -e
```

You will be placed in the `vi` editor. Execute these commands (inside `vi`):

```text
i
0 0 * * *  date >> myCronOutput
<Escape>
:w
:q
```

This returns you to the command prompt.

Over the next days you can inspect `myCronOutput` to see the file grow with the output of the `date` command.

You can also run:

```bash
crontab -l
```

to verify that your new entry appears in the cron table.

## Downloading using wget

Workflows often need to retrieve input or source files automatically from the web. `wget` (GNU Wget) enables retrieval of files over HTTP, HTTPS, FTP, and FTPS. It supports resuming aborted downloads, recursive fetching, filename wild‑cards, and timestamp‑based conditional downloads.

The simplest usage is to give the URL of the file you want:

```bash
wget http://manunicast.seaes.manchester.ac.uk/charts/manunicast/20200105/d02/meteograms/meteo_ABED_2020-01-04_1800_data.txt
```

If you give a directory URL, `wget` will download the directory listing as an HTML file:

```bash
wget http://manunicast.seaes.manchester.ac.uk/charts/manunicast/20200105/d02/meteograms
```

### Recursive download

To download an entire directory tree, use `-r` (recursive) together with `-np` (no‑parent) so that `wget` does not climb up to parent directories. You can also limit the download to particular extensions with `-A`.

Download a single file recursively (creates the same directory hierarchy locally):

```bash
wget -r -np http://manunicast.seaes.manchester.ac.uk/charts/manunicast/20200105/d02/meteograms/meteo_ABED_2020-01-04_1800_data.txt
```

Download **all** `.txt` files in that directory:

```bash
wget -r -np -A txt http://manunicast.seaes.manchester.ac.uk/charts/manunicast/20200105/d02/meteograms/
```

> **Restricting web crawling to a single domain**  
> To prevent `wget` from following links off‑site, use the `-D [domain]` flag (e.g., `-D manchester.ac.uk` or `-D manunicast.seaes.manchester.ac.uk`).  
> {: .callout}

> **Using wildcards in file names**  
> The HTTP protocol does not support wildcards, but the FTP protocol does. If the server provides FTP access, you can use wildcards with `wget`.  
> {: .callout}

## Scheduling the download job

1. Change to the `data_download` directory inside the `data-adv-shell` repository.  
2. Edit `crontab_settings.txt` to:  
   - Set a time 3–4 minutes in the future.  
   - Set the correct absolute path to `manunicast_download.sh`.  
3. Install the crontab:

   ```bash
   crontab crontab_settings.txt
   ```

If it works, the downloaded file will appear on your Desktop within a few minutes. If not, inspect `stderr.log` (also on the Desktop) for error messages.

When you’re done, remove the crontab entry:

```bash
crontab -r
```


----------
[Next > Variables and Arrays](./variables.md)