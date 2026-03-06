# Best Practices Overview
2026-03-06

## Description:

This workshop consolidates the most important concepts, tools, and best practices from the ARC workshop series into a single, integrated session. We will concisely review summary best practices from the previous workshops covering how to:

 - connect to ARC systems securely
 - build and run computational jobs
 - monitor performance
 - manage data
 - apply efficient computing strategies effectively. 
 
 Designed for both new and experienced ARC users, this session provides a high-level review paired with practical tips.


## Spring 2026 Workshops so far...
2026-01-23 Advanced Research Computing Roadmap
2026-01-30 Connect to ARC Systems with VSCode
2026-02-06 Running Jobs on ARC Systems
2026-02-13 Monitoring Resource Utilization and Job Efficiency
2026-02-20 Managing Data on ARC File Systems
2026-02-27 Virtual Environments on ARC


## Outline:
1. ARC Systems Overview (Refresher)
    a. Summary of cluster types (standard, controlled, visualization)
    b. Storage types (/home, /projects, /scratch, archival, TMPDIR)
    c. Access points and support channels (Globus, OOD, 4Help, Office Hours)

2. [Secure Remote Development](2-secure)
    a. SSH key management and usage
    b. Connecting and coding via VSCode and Remote-SSH
    c. File system awareness and login node limitations
    d. Login node usage dos and don’ts

3. [Efficient Job Submission with Slurm](3-job_submission)
    a. Job types: batch vs. interactive
    b. QoS, partitions, memory settings
    c. Tools: sbatch, salloc, srun
    
4. [Job Monitoring and Optimization](4-monitoring)
    a. Tools: getusage, seff, billing calculator
    b. Tools: seff, htop, gpumon, jobload, sacct, Grafana
    c. Dashboard

5. [Data Management Essentials](5-data_management)
    a. permissions and ownership
    b. how to manage lots of small files

6. [Virtual Environments on ARC](6-python_env)
    a. Using conda conda commands (list, load, channels)
    b. How to submit jobs with conda environments 
    c. Sbatch and interactive jobs
    d. How to use conda within Jupyter Notebooks on OOD

7. [Support and Documentation](7-support)
    a. ARC documentation site
    b. example code repository
    c. office hours
    d. help request
