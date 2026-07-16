# Data Management

---
[Next: File systems ➡️](02_file_systems.md)


## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help and access to information, and links to those resources, are provided.  Examples:

- determine and attend office hours
- submit help tickets (for errors, problems, or request a consultation)
- obtain listings of workshops (and video recordings and notes files)
- view video tutorials
- run example codes
- understand overall cluster status and performance, as well as those of your jobs, via dashboards
- more


## Overview:  Background and Motivation

### File Systems

1. Unlike a laptop or tower that typically has one
hard drive, clusters typically have several
different storage devices.
2. Storage devices have different characteristic
   (size, speed of access, persistency) and
   hence there are multiple devices with strengths
   for different needs.
3. We will talk about these for ARC clusters.


### File and Directory Permissions

1. You want to control who has access to your files.
2. Default permissions are set up for files and 
   directories that are best for a wide range of cases.
   - Permissions enable you and your advisor 
     to control "access" to files and directories.
     - For example, with files, there are ways to 
       control each of:
       - who can see a file.
       - who can view the file contents.
       - who can edit the file contents.
       - who can execute (an appropriate) file. 
   - So that when a student leaves, the advisor has access.
   - The PI will have access anyway; ARC will ensure that,
     but things run smoother if permissions are set up
     this way a priori. 
3. But you may have particular needs.
4. So we explain the ideas behind permissions and
   show how to change file
   and directory permissions.

### Umask

1. _**If you are considering changing your umask, we ask that you 
   first submit a help ticket [here](arc.vt.edu/help) and describe
   your need.**_
   - We can talk about this together.
   - We get tickets from students and professors about not PIs
     not being able to access their students' files.
   - Sometimes the student has already left.
   - This can be a significant frustration for PIs.
   - The permissions that we have allow PIs to look
     into student directories.  
2. The default permissions, mentioned above, for files
   and directories are established and assigned to
   files and directories based on a user-assigned umask.
3. So each user can change their umask, but we do not 
   advise changing it unless you have a very compelling need.
4. We will describe the umask concept, tell you its
   default value, and how to change it.
5. Changing your user umask will change the default
   permissions on files and directories that were described
   above.

### File Ownership

1. When a file or directory is first created, in addition
   to permissions assigned to it, ownership is also assigned.
2. There are two types of ownership:
   - individual ownership (usually the person who creates
     the file)
   - group ownership (usually the group designated
     by the PI that the student is working under).
3. Because individual ownership is rarely changes
   (one reason is for prevenance), we focus on how
   to change group ownership.

### Data Recovery and Long-Term Storage

1. It is paramount to realize that YOUR DATA ARE NOT
   BACKED UP on the ARC clusters.
2. If you want/need your data backed up, you must take
   the steps to do so.
3. This decision is a university-wide decision based
   primarily on cost; it is prohibitively expensive
   to back up all data on ARC clusters.
4. There is a backup service provided by ARC but it 
   is subject to particular conditions.



## Learning Objectives

1. Understand storage on ARC cluster.
2. Know how to set and change file/directory permissions.
3. Know what umask is and whether you should change
   it (probably not).
4. File and directory ownership, how to change 
   ownership, and how ownership is intimately tied to
   permissions.   
5. Understand that your data are not backed up by ARC.


## Detailed Topics

1. [File systems](./02_file_systems.md)
2. [File and directory permissions](./03_file_permissions.md)
3. [umask](./04_umask.md) (`*`)
4. [File and directory ownership](./05_file_ownership.md)
5. [Data recovery and LT storage](./06_data_recovery_and_long_term_storage.md)
6. [Best practices](./07_best_practices.md)

`*` This material is more in-depth and should be skipped for one-hour workshop.
   Subsequent sections are not dependent on this material.


### Prerequisites

- You will need an ARC account to follow along and set up these tools.
- Access to a VT network (e.g., _eduroam_ on campus or _VPN_ off campus)

### Applicability

A very large portion of this content is applicable to 
any compute cluster.

### Acknowledgment

These notes were constructed largely from workshop materials
initially prepared by Matt Brown and Sophia Lima.

---
[Next: File systems ➡️](02_file_systems.md)
