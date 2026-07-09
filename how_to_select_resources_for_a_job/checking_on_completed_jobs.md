## Checking on Completed Jobs

When your slurm job completes, you can either remember the slurm job ID
from your terminal screen output (earlier in time), or you can
look at your slurm-generated output and error files, which should have
the slurm job ID in their names.

You specify that the job ID will appear in the slurm-generated output
and error files by putting `%j` in their filenames in the 
sbatch slurm script.
Examples were given early in this presentation.

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
