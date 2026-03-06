# Job Submission and Management

## Job types: batch vs. interactive
### batch
Clusters are designed and run most efficiently with batch jobs:
 - create a script `myjob.slurm`
 - submit the job `sbatch myjob.slurm`

 ARC hosts a GitHub repo with lots of [example scripts](https://github.com/AdvancedResearchComputing/examples) for different software packages available on ARC.

### interactive
Some tasks and workflows rely on user interactions during the task. For example, code and script development, software installations, and GUIs.

`interact --account=<slurm account>` is a good starting point for an interactive command-line job.

OnDemand is a web interface for interactive GUI apps: [ood.arc.vt.edu](https://ood.arc.vt.edu).

>[!NOTE]
> Interactive jobs still get dedicated access to cluster resources. You must end the job to release the resources back to the cluster.

## QoS, partitions, memory settings
Cluster pages on [https://docs.arc.vt.edu](https://docs.arc.vt.edu) provide detailed explanations of available QoS's, partitions, and node configurations:

[Tinkercliffs](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
[Owl](https://docs.arc.vt.edu/resources/compute/01owl.html)
[Falcon](https://docs.arc.vt.edu/resources/compute/02falcon.html)

Next > [Job Monitoring and Optimization](4-monitoring)

    