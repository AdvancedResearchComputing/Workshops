8. [Interactive versus batch jobs ⬅️ Previous:](./interactive_vs_batch_jobs.md)

# Checking on In-Progress Jobs

## ARC provided scripts:

ARC provides convenience commands to get detailed information on current job resource utilization and access to dashboard pages customized for your running job:

 - Current moment-in-time utilization: `showjobusage <jobid>`
 - Node-level utilization since job start: `getjobutilurl <jobid>`

## Connect to compute nodes to manually inspect

If using GPUs in your job, use the dashboards to ensure that your code is using the GPUs.

These are a limited resources, so their efficient use is important to everyone.

_**Procedure**_

- Get a shell on the cluster your jobs are on.
- Type `squeue`.
- Get the slurm job ID of the job of interest.  Call this `<jobid>`.
- On terminal type, `scontrol show job --details <jobid>`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- You can also do:  on terminal type, `showjobusage <jobid>`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- Use shell commands to inspect resource utilization such as
   - `top` or `htop`
   - `nvidia-smi`
   - `mpstat`
   - `nfsiostat 2 5 /scratch`
  
  10. [Next: ➡️ Checking on completed jobs](./checking_on_completed_jobs.md)