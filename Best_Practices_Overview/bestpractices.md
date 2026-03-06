# Best Practices Overview
2026-03-06

## Description:

This workshop consolidates the most important concepts, tools, and best practices from the ARC workshop series into a single, integrated session. We will concisely review summary best practices from the previous workshops this semester covering how to:

[Workshop list](https://docs.arc.vt.edu/usage/workshops.html)
 - connect to ARC systems securely
 - build and run computational jobs
 - monitor performance
 - manage data
 - apply efficient computing strategies effectively. 
 
 Designed for both new and experienced ARC users, this session provides a high-level review paired with practical tips.


## Spring 2026 Workshops so far...
- 2026-01-23 Advanced Research Computing Roadmap
- 2026-01-30 Connect to ARC Systems with VSCode
- 2026-02-06 Running Jobs on ARC Systems
- 2026-02-13 Monitoring Resource Utilization and Job Efficiency
- 2026-02-20 Managing Data on ARC File Systems
- 2026-02-27 Virtual Environments on ARC


## Outline:
1. ARC Systems Overview (Refresher)
- Summary of cluster types (standard, controlled, visualization)
- Storage types (/home, /projects, /scratch, archival, TMPDIR)
- Access points and support channels (Globus, OOD, 4Help, Office Hours)

2. [Secure Remote Development](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/2-secure.md)
- SSH key management and usage
- Connecting and coding via VSCode and Remote-SSH
- File system awareness and login node limitations
- Login node usage dos and don’ts

3. [Efficient Job Submission with Slurm](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/3-job_submission.md)
- Job types: batch vs. interactive
- QoS, partitions, memory settings
- Tools: sbatch, salloc, srun
    
4. [Job Monitoring and Optimization](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/4-monitoring.md)
- Tools: getusage, seff, billing calculator
- Tools: seff, htop, gpumon, jobload, sacct, Grafana
- Dashboard

5. [Data Management Essentials](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/5-data_management.md)
- permissions and ownership
- how to manage lots of small files

6. [Virtual Environments on ARC](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/6-python_env.md)
- Using conda conda commands (list, load, channels)
- How to submit jobs with conda environments 
- Sbatch and interactive jobs
- How to use conda within Jupyter Notebooks on OOD

7. [Support and Documentation](https://github.com/AdvancedResearchComputing/Workshops/blob/main/Best_Practices_Overview/7-support.md)
- ARC documentation site
- example code repository
- office hours
- help request
