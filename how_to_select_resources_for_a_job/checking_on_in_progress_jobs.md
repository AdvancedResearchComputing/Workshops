# Checking on In-Progress Jobs

#### If Your Job Uses GPUs

If using GPUs in your job, use the grafana dashboards to ensure that your code is using the GPUs.

These are a limited resources, so their efficient use is important to everyone.

_**Procedure**_

- Go to a terminal for the cluster your jobs are on.
- Type `squeue`.
- Get the slurm job ID of the job of interest.  Call this `sjid`.
- On terminal type, `scontrol show job --details sjid`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- You can also do:  on terminal type, `showjobusage sjid`.
   - Get the compute node IDs of the compute nodes that you are using (these should also be shown on `squeue` results).
   - Get the GPU indexes of the GPUs you are using.
- Go to the dashboards below (per cluster).
  - Dashboards
    - [TC dashboard](https://dashboard.arc.vt.edu/d/acfsdp9/arc-cluster-efficiency-tinkercliffs?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-tc-oss&var-partition=$__all)
    - [Owl dashboard](https://dashboard.arc.vt.edu/d/acgv4cq/arc-cluster-efficiency-owl?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-owl-oss&var-partition=$__all)
    - [Falcon dashboard](https://dashboard.arc.vt.edu/d/cej373w7tbmkgd/arc-cluster-efficiency-falcon?orgId=1&from=now-12h&to=now&timezone=browser&var-datasource=prometheus-falcon-oss&var-partition=$__all)
- On the dashboard
    - Select your compute node ID (the one from the step above).
    - On that screen, look at the plot of GPU utilization and click on the GPU index (indexes)
      for the GPUs that your job is using. 
    - Look at the GPU utilization plot and confirm that GPU usage is as you expect.


#### If Your Job Uses CPUs

Follow the steps in the previous subsection:
- `squeue`
- `scontrol show job --details sjid` or `showjobusage sjid`

... to obtain:
- Your slurm job ID `sjid`.
- The compute nodes on which you are running.
- The CPU IDs that are running your code on each compute node.
- From a terminal screen on the cluster on which your job is running,
  ssh into each compute node of your list.
  - Example:  if your job is running on the TC compute
    node tc003, then enter `ssh tc003`
  - Type `htop -u $USER`
  - Look at the plot on the top of the resulting page.
  - Note that you have to "add 1" to each CPU ID that you get
    from the `scontrol` and `showjobusage`
    commands above
       - This is because the linux commands number CPUs starting
         at zero, while htop numbers themn starting at 1.
           - Example:  if one a TC compute node, there are 128 CPUs or cores,
             then:
                - `scontrol` and `showjobusage` will number them 0 to 127.
                - `htop` will number them 1 to 128.
  - Look at the CPUs (cores) on this upper graphic and see the instantaneous
    utilization for each core that is running your code.
  - Confirm that the CPUs are being used.
      