8. [Interactive versus batch jobs ⬅️ Previous:](./interactive_vs_batch_jobs.md)

# Checking on In-Progress Jobs

## ARC provided scripts

The commands in this section are executed on login nodes of the clusters on which
the user's jobs are running.

ARC provides convenience commands to get detailed information on current job resource utilization and access to dashboard pages customized for your running job:

 - Current job-level moment-in-time utilization: `showjobusage <jobid>`
 - Node-level utilization since job start: `getjobutilurl <jobid>`

Here, `<jobid>` is the Slurm job ID.
It can be obtained from running `squeue` on a login node of the cluster on which your
job is running.


## Connect to compute nodes to manually inspect jobs

_**Procedure**_

- Get a shell on a login node of the cluster your jobs are on.
- Type `squeue`.
- Get the slurm job ID of the job of interest.  Call this `<jobid>`.
- On terminal type, `scontrol show job --details <jobid>`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- You can also type on a terminal, `showjobusage <jobid>`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- ssh into a compute node, based on the compute node name, e.g., `ssh tc-dgx003`, `ssh owl007`.
- Use shell commands to inspect resource utilization such as
   - `top` or `htop`
   - `nvidia-smi`
   - `mpstat`
   - `nfsiostat 2 5 /scratch`

## Use the Grafana dashboard to check your jobs

This is primarily for GPU utilization, but can be useful for other resources.

Use the first four steps in the subsection above to get the 
compute node name (ID), partition, GPU indexes, and CPU IDs for the
Slurm job of interest.

If using GPUs in your job, use the [ARC dashboards](https://dashboard.arc.vt.edu/)
to view a time history of the performance of the GPU(s)
to ensure that your code is using the GPUs and using them efficiently.

These are a limited resources, so their efficient use is important to everyone.

  
  10. [Next: ➡️ Checking on completed jobs](./checking_on_completed_jobs.md)
