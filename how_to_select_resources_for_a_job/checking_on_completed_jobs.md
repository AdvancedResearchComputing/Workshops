9. [Checking on in-progress jobs ⬅️ Previous:](./checking_on_in_progress_jobs.md)

## Checking on Completed Jobs

As before, you will need to know the Slurm job ID to inspect resource utilization for a completed job. `squeue` will not show information for completed jobs. You can usually recover the jobid from output files in the job directory, or you can use
`sacct` for jobs which were running at some point "today" or `sacct --start=YYYY-MM-DD` to show info about older jobs.

Now, from a terminal screen, issue:

`seff <slurm-job-ID>`

This will give you the memory and CPU utilization of your job.

You can use these data to inform you as to whether you should change
your resource allocations.

For example, you may have used very little memory from that assigned
to your job.
In this case, in the next job of this type, you can reduce the
amount of memory requested.

**You want to use the `seff` command to build your intuition
about cluster performance.**

As with running jobs you can access node-level utilization via dashboard URLs with: `getjobutilurl <jobid>`
