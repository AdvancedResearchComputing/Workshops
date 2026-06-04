# Using Open OnDemand (OOD) on ARC Clusters

## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help from VT ARC and access to information, and links to those resources, are provided.  Examples:
- determine and attend office hours
- submit help tickets (for errors, problems, or request a consultation)
- obtain listings of workshops (and video recordings and notes files)
- view video tutorials
- run example codes
- understand overall cluster status and performance, as well as those of your jobs, via dashboards
- more

## SSH (Secure SHell)

####  What is ssh?

ssh is a method and a mechanism for securely accessing computing-related resources;
in our case, the ARC clusters and servers.

####  What can it do for me?

You must log in to the clusters---even for using OOD you must
log in to the VT network---and ssh is the way to log in.

####  Is it a pain to use default procedures?

ssh includes the requirement for two-factor authentiation (2FA).  Hence, the two steps are:
1. Use ssh to specify the machine you wish to reach.
2. Complete 2FA.

If one only had to do this one time, it would not be a big issue.
But when working on ARC clusters, one may have more than a dozen terminals
open at one time (each terminal login requires the two steps above).
If you take your laptop home, and work from home in the morning/evening, and work at VT during the day,
you may have multiple sets of logins (across terminals each day).
It gets old/tedious really fast.


####  What can I do to make its use easy and fast?

There are two major tasks to complete.
Both are one-time setups.
Then you use the results to streamline logging into ARC clusters in quite significant ways.
For example, you can log into, say, four different terminal screens in about 5-10 seconds.

##### Task 1

Using ssh keys and a setup procedure, you can set up your computer (e.g., laptop) so that
logins to clusters are fast (essentially instantaneous) and easy (involves about six key strokes).
From a practical perspective, this setup with ssh keys enables you to issue the `ssh` command and
have it validate you, as a user, automatically, thereby bypassing the "manual" 2FA process.

##### Task 2

One can also set up aliases for the clusters so that you do not have to do this:  `ssh my_vt_pid@tinkercliffs1.arc.vt.edu`.
Instead, you can do something like this:  `ssh tc1`.

## Workshop Goals

The goals of this workshop are to demonstrate these procedures and have
you execute them yourself, so that at the end of the work, you have
these one-time setup procedures COMPLETED and you can access the ARC 
clusters quickly.


## Other Resources

### ARC Docs Page

This page [https://docs.arc.vt.edu/usage/sshkeys.html](https://docs.arc.vt.edu/usage/sshkeys.html) contains details for constructing ssh keys
on both Mac and Windows laptops.

Here, we focus on Macs.

### Video

There are two excellent videos on ssh keys linked on the ARC Video page [https://docs.arc.vt.edu/usage/video.html#general-connections](https://docs.arc.vt.edu/usage/video.html#general-connections).


## Prerequisites

One of two cases:
1. Physically be on the VT campus and connect to the _eduroam_ network.
2. Be off campus and use VPN to access the VT network.  Installing VPN instructions are at [https://www.nis.vt.edu/ServicePortfolio/Network/RemoteAccess-VPN.html](https://www.nis.vt.edu/ServicePortfolio/Network/RemoteAccess-VPN.html).


## Context of the Solution

We show below a laptop (which is your laptop [or tower]) and
your home directory (storage location) that is accessible across
the Tinkercliffs (TC or tc), Owl (or owl), and Falcon (or falcon)
clusters.

![context](./figures/context-v01.png)

## Outline

- [Background, Motivation, and Learning Objectives](./bmlo.md)
- [Accessing OOD](./access-ood.md)
- [Navigating Directories and Files](./directories-files.md)
- [Viewing Active Jobs on Clusters](./active_job.md)
- [Obtaining a Cluster Shell (Terminal)](./cluster-shell.md)
- [Running R-studio](./R-studio.md)
- [Running Matlab](./matlab.md)
- [Running Jupyter notebooks](./jupyter.md)
- [Running Remote Desktop](./remote-desktop.md)
- [Running LLM Chatbot](./llm-chatgpt.md)
- [Running VS Code](./vs-code.md)



## Relinquishing Resources When Done With an OOD Job

This will be mentioned in different individual lessons, 
but because it is such a major issue---wasting ARC resources---we
also present it here.

> [!NOTE]
> Over all ARC systems, not `Cancel`ing (i.e., giving back) OOD resources when you
> are done with them is a HUGE source of wasted resources.

> [!NOTE]
> This is a waste of resources for you and for all users.

## Acknowledgments



## References


