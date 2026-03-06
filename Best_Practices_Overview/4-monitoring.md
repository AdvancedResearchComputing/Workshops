# Job Monitoring and Performance Optimization

## Tools: getusage, billing calculator
`getusage` - show month-to-date account status and usage breakdown
```

[brownm12@tinkercliffs2 ~]$ getusage --account arcadm
Cluster: tinkercliffs
  Account: arcadm
    Account total:       750,000.00
    Account running:           0.00 --> Service Units committed for completing running jobs
    Account used:            160.48 (0.0%)
    Account available:   749,839.52 (100.0%)
    PI available:      1,999,839.51 (100.0%) out of 2,000,000.00 Service Units shared among all PI's accounts
    Actual available:    749,839.52

    User breakdown:
      maaayat         Used:         0.00 h | Running:         0.00 h
      sarahghazanfari Used:         0.56 h | Running:         0.00 h
      nbraunsc        Used:         0.00 h | Running:         0.00 h
      ainababs0       Used:        10.47 h | Running:         0.00 h
      smali           Used:       142.54 h | Running:         0.00 h
      bsandbro        Used:         1.91 h | Running:         0.00 h
      ...
```
### Coldfront
[ColdFront](https://coldfront.arc.vt.edu) > "Billing Calculator"
Estimate billing cost of a job.

## Inspect performance and efficiency of a running job
`showjobusage <jobid>`

 - Inspect running processes on each node
 - Inspect current CPU utilization per process and in aggregate
 - Inspect memory usage per process and in aggregate
 - Inspect GPU usage per process and in aggregate
 - Get summary information for the job
 - Get hints (warnings) about low resource utilization

## Dashboard
[ARC dashboard](https://dashboard.arc.vt.edu)
 - cluster-level usage and utilization stats
 - find available resources
 - view node-level resource utilization over time

For a running or completed job, get URLs for the allocated nodes tuned to the timeline of the job:
`getjobutilurl <jobid>`

Next > [Data Management Essentials](5-data_management)