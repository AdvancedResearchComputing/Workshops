# Operating Visual Studio (VS) Code On Compute Nodes


## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help and access to information, and links to those resources, are provided.


## Ideas Behind This Workshop

1. VS Code (VSC) is a popular IDE for developing code and content
   for other files.
2. Running VS Code is allowable on head nodes _**IF**_:
   1. You do not run with plugins, e.g., do not run with AI plugins.
   2. You do not run code:  no code execution, no major code debugging.
3. Why these restrictions?
   1. Because head nodes are communal resources that all users make use of _**simultaneously**_.
   2. Compute nodes, on the other hand, are used by a _**selected few**_ users at a time according to Slurm scheduler operations.
   3. So if you are consuming lots of resources on head nodes,
          then you are degrading 
          the performance of the head nodes for all other users.
       1. VS Code is a _**primary**_ way that users consume too many resources on head nodes.
   4. It is most useful to think of yourself and all other
         1000 ARC users as being in the same boat:
         we need to be respectful of others, by following agreed upon procedures, so that everyone
         can work efficiently and get their work done.
4. To summarize the purpose of this workshop:
   I want to use VS Code to do my work and
   1. I want to debug and run my code from within VSC, and/or
   2. I want to use AI or other plugins with VSC.
5. How do I do this?
6. By running your instance of VS Code on a _**compute**_ node 
   (and not a _**head**_ node).
7. This workshop focuses on how to run VSC on ARC compute nodes.


---------------------------------------

---------------------------------------


## Organization

---------------------------------------

---------------------------------------

### Applicability

1. These procedures apply to Tinkercliffs (TC), Owl, and Falcon clusters.
2. If your code uses CPUs only, then you should run VSC on clusters 
   and partitions on them that are CPU-only.
3. If your code uses GPUs, then you should run VSC on clusters 
   and partitions on them that have GPUs.


### Prerequisites

1.  Have SSH installed on your local machine (comes with most laptops). [SSH keys](https://docs.arc.vt.edu/usage/sshkeys.html) is a great way to configure ssh and the clusters so that 
    login is fast.
2.  If working remotely, have [VT VPN](https://www.nis.vt.edu/ServicePortfolio/Network/RemoteAccess-VPN.html) installed on your laptop (local machine).
3.  Have an ARC [account](https://arc.vt.edu/account).
4.  Have an ARC Project for file storage.  Not absolutely critical for this
    workshop, because you can here use `/home/<username>` for this workshop, but critical for your work long-term.
      1. If you are a professor (i.e., PI), then create a project [here](https://docs.arc.vt.edu/pi_info/allocations.html).
      2. If you are a student, find a professor to work with.
5.  Have an [allocation](https://docs.arc.vt.edu/pi_info/allocations.html) to charge "jobs" to.


### Major Activities

We order the activities into setup steps that you execute
one time and steps that you repeat every time you use 
VSC on a compute node.

1. One-Time Setup Steps
   1. Laptop (or local machine)
      1. Alter the `config` file under directory `~/.ssh` as below.
   (meaning that the directory `.ssh` is located right below
   your $HOME directory).
   2. VS Code
      1. Install VS Code (VSC) on your laptop.
      2. Install the `Remote-ssh` plugin in your VSC app.
2. Steps To Use for Every VS Code Session on Compute Node
   1. Request an interactive job on the ARC clusters.
      1. From a terminal window on your local machine, make an `ssh`
         connection to a head node whose compute nodes you want to
         run VSC on.
      2. From this head node, make a request of slurm, via the `interact` command,
      to provide you with your specified resources (on a compute node).
      3. Note `hostname` of the _**compute**_ node you are given.
   2. From your laptop, using VSC, connect to the compute node directly.
      1. You will need that hostname of the compute node.
3. Actions to take for authenticity problem, if you get the message
   in VSC:  "the authenticity of host cannot be established"


---------------------------------------

---------------------------------------



## One-Time Setup

---------------------------------------

---------------------------------------

### Altering Your SSH `config` File for Wildcard ProxyJump

We want to set up our ssh configuration on our local computer so that 
VSC can be run directory on a compute node of the ARC clusters.

#### The Idea

1.  Create a set of commands to help you automate the process of
    accessing a compute node on which to run VSC.
2.  You do this inside of the `config` file that is located in the `~/.ssh` directory of your laptop/tower (i.e., your local machine).

#### Directions

1. On your laptop, go to the `~/.ssh` directory.
2. Make a copy of your config file so you can return to that state if need be.
   Example:  `cp -p config config.backup.<date>`
3. Alter your `config` file by opening it with an editor.
   1. Example editor, `vi`.
   2. Go to end of file.
   3. Paste in the contents below:

Below is an example---but a powerful one---covering several ARC clusters. Replace `<your_VT_PID>` with your VT username and adjust the patterns or login nodes if needed:

<<< begin paste material >>>

```ssh
# Tinkercliffs compute nodes (advanced)
# Automatically jump through a Tinkercliffs login node when you ssh to any compute node
# like "tc006", "tc-xe003", etc.
Host !tc1 !tc2 tc-intel* tc0* tc1* tc2* tc3* tc-lm* tc-gpu* tc-dgx* tc-xe*
    ProxyJump <your_VT_PID>@tinkercliffs2.arc.vt.edu
    User <your_VT_PID>

# Falcon compute nodes
Host fal0* fal1*
    ProxyJump <your_VT_PID>@falcon2.arc.vt.edu
    User <your_VT_PID>

# Owl compute nodes (excluding the owl1 login node itself)
Host !owl1 owl0* owl1* owl-hm* owlmln*
    ProxyJump <your_VT_PID>@owl3.arc.vt.edu
    User <your_VT_PID>
```
<<< end paste material >>>

   4. Save the file `config`.
   5. Exit the file.

#### What This Does

- Any hostname matching one of the patterns (e.g., `tc006`, `tc-xe001`, `fal012`, `owl-hm03`) will automatically:
  - SSH to the appropriate login node (`tinkercliffs2`, `falcon2`, `owl3`), then
  - ProxyJump automatically onto the compute node.
- Negative patterns like `!tc1` and `!tc2` ensure that the login nodes themselves do _**NOT**_ use ProxyJump, so you can still run `ssh <your_VT_PID>@tinkercliffs2.arc.vt.edu` directly.


```{note}
Always use a login node for the **same cluster** where you plan to run jobs (e.g., `tinkercliffs1`/`tinkercliffs2` for `tc*` nodes).
``` 

### Install VS Code on Your Laptop

If you do not have VSC installed on your laptop or tower, 
search for VSC online and download and install the app.
One download site is [here](https://code.visualstudio.com/download).

###  Launch the VSC App and install the Remote - ssh Package

1. Open VSC on your local machine.
2. Go to the far left command bar and click the `Extensions` button.
3. In the Extensions search bar, type `Remote - SSH`.
4. Find the `Remote - SSH` package in the list of choices provided from the search
   (there should be a blue `Install` button associated with each package).
   1. Click the `Install` button corresponding to `Remote - SSH` and the package will be installed into VSC.

---------------------------------------

---------------------------------------

## Using VS Code on an ARC Compute Node

---------------------------------------

---------------------------------------

By "session" we mean make a connection through VSC on your laptop
to an ARC cluster compute node and do your work.

These are the steps for one session and need to be repeated for each
subsequent session.

The major steps to execute, which we describe in more detail below, are:

1. From a cluster head node, request an interactive Slurm job
   through a terminal window.
   1. You will be provided a compute node (name).
2. Use VSC, running on your laptop, to connect to the compute node
   provided in the previous step.
3. Do your work through VSC on the compute node, which may entail 
   using (AI) packages, debugging code, and running code.
4. Be careful to relinquish the interactive job resources when you are finished.

> [!NOTE]

```{note}
Save our work frequently in VSC.  When the interactive job ends, your VSC connection to the compute node WILL end and you will lose any work that you have not saved.
```

### Log Into an ARC Cluster Head Node

We need to log into an ARC cluster head node so that
we can request resources on a compute node.

Logging onto a head node, can be performed using any of the following:

1. A terminal window on your laptop.
2. A terminal window obtained through [ARC's Open OnDemand](https://ood.arc.vt.edu) (OOD).


Execute the commands in _**ONE**_ of the two following subsections
(per the listing immediately above), to
log into a head node using a terminal window.

#### Recommended Way:  Using a Terminal Window on Your Laptop to Log Into an ARC Cluster Head Node

1. Open a terminal window on your laptop.
2. ssh into a cluster head node for the cluster where you want to do VSC work.
   1. For example, if you want to log into the owl head node 2:
      1. `ssh <user_name>@owl2.arc.vt.edu`
3. Now you are logged into a head node.

#### Alternative Way:  Using a Terminal Window Through Open OnDemand (OOD) to Log Into an ARC Cluster Head Node

1. Go to the [ARC OOD landing page](https://ood.arc.vt.edu).
2. At the command bar at the top of the page (currently in maroon),
   click the `Clusters` drop down and select one of the Falcon, Owl,
   or Tinkercliffs shell access for a head node corresponding to the
   cluster on which you want to use a compute node for VSC.
3. You will be placed on a terminal window.
4. You are now logged into a head node.

### Request Compute Node Resources From a Cluster Head Node

Use the `interact` command to request compute node resources.

Note that these are the resources that you will have access to
while using VSC, so this should guide your specification of resources.

A common command structure for a **CPU-based** interactive job is:

```
interact --account=<account> --partition=<partition> --nodes=<num compute nodes> --ntasks-per-node=<num tasks per compute node> --cpus-per-task=<num cpus per task>  --constraint=<constraints>  --mem=<memory amount>   --time=02:00:00
```

Example for Tinkercliffs:

```
interact --account=<account> --partition=normal_q --nodes=1 --ntasks-per-node=1 --cpus-per-task=4 --constraint=amd  --mem=4GB  --time=04:00:00
```

A common command structure for a **GPU-based** interactive job is:

```
interact --account=<account> --partition=<partition> --nodes=<num compute nodes> --ntasks-per-node=<num tasks per compute node> --cpus-per-task=<num cpus per task>  --mem=<memory amount>  --gres=<gpu resources> --time=02:00:00
```

Example for Falcon

```
interact --account=<account> --partition=l40s_normal_q --nodes=1 --ntasks-per-node=1 --cpus-per-task=4  --mem=4GB --gres=gpu:1 --time=04:00:00
```

Since all GPU-based partitions have only a single node type, 
the `--constraint` switch is not used when requesting GPU resources.
See [constraints](https://docs.arc.vt.edu/usage/job_scheduling/01_slurm_overview.html#slurm-constraints) for more details.
But a GPU-based interactive job needs `--gres` to specify the 
number of GPUs needed.

Since these are the resources that you will use with VSC,
the time allotment you specify (via `--time`) should be the amount of
time that you will be using VSC.

The `interact` command will "return" when Slurm has the resources to 
provide to you, that you requested.
On the terminal screen, you will be placed on the compute node.
This is the compute node on which you will run VSC.

The name of the compute node can be seen in your command prompt.
Alternatively, you can type `hostname` on the terminal screen and it will also
provide you with the name of the compute node.

You will need the name of the compute node below.

For this terminal, just keep it open, i.e., do not shut down this terminal
window or log off of the compute node.
Each of these undesirable actions will cause you to lose your resources
on the compute node and you will not be able to use VSC on the compute
node.
You can use this terminal to show how much of your requested time has been
used, using `squeue -u $USER`.


### Starting VS Code From Your Laptop to Run on a Compute Node


This is where the `ProxyJump` work done in the setup portion of this
workshop works for us.

The steps are:

1. In VSC on your laptop, open **Remote-SSH → Connect to Host…**.
   1. In detail:
      1. Click `View` in the command bar.
      2. Then choose `Command Palette...`.
      3. In the text box that now appears at the top middle of your
         VSC IDE, type `Remote-SSH → Connect to Host…` and select
         that option from the dropdown list.
2. Enter the compute node name directly (this is the output from the `hostname` command above) and hit "return."
3. This is where you might encounter the _**Authentication Problem**_ referred to in the major section 3 below.  That section describes how to solve this
problem.
4. If all is going well,
   you should see at lower right of the new VSCode window, something like
   "Downloading VS Code Server".  This is good.
5. IF/When prompted, choose `Linux` as the remote platform.
6. VS Code’s remote server now runs on the compute node instead of the login node.
7. You should see a blue box at the lower left stating `SSH: <hostname>`, indicating that you are connected to the ARC compute node `<hostname>`.
8. Another way to verify that you are on a compute node is to select
   `Terminal` from the VSC main menu and then select `New Terminal`.
   Your VSC diplay should show you a terminal at the bottom and the 
   command prompt should include the `<hostname>`, indicating that
   you are on that compute node.

#### Do Your Work

If familiar with VS Code, at this point, begin your work.
If this is new to you, you might consider the following steps.

1. Start your work by opening your working directory (e.g. `/home/<username>` or `/projects/...`).
   1. You can do this by clicking on the Explorer icon at the far left of the VS Code screen.
   2. In the entry field at the top center, you can enter your path `/projects/...` as stated above.
   3. You will get an explorer window on the far left in which you can
      navigate files and directories.

#### End Your VS Code Session      

1. To end your VS Code session:
   1. Click the aforementioned blue box at
      lower left `SSH: <hostname>`
   2. A dropdown list will appear at the top center.
   3. From this list, select `Close Remote Connection`.


> [!NOTE]
As mentioned earlier, save your work regularly and be cognizant of your
remaining time in your interactive job/session.
In the terminal window where you entered the `interact` command and where
you are now on the compute node, you can enter `squeue -u $USER` to see
how much time of your interactive time has _EXPIRED_ and therefore infer
how much time you have left.


### End Your Entire Working Session

Your working session will end in one of two ways:

1. Your interactive job's time will expire and your interactive job will end, and all resources will be revoked (including your connection through VSC).
So you do not need to close anything---everything will be closed for you.
2. You finish your work and end your session.
   1. In VSC, follow the last major bullet in the section above, "Do Your Work and Then End Your Session."
   2. In the terminal screen where you issued the `interact` command, type `exit`.
      1. This will log you off of the compute node and put you back on the head node.
      2. This will end your interactive job and hence will make impossible any further action on the compute node with VSC.
      3. If you have to deal with the "authenticity problem" in the major section below, this should also end the `ssh` session that you created directly from your laptop.

> [!NOTE]
> Please remember, when you are finished,
> to `exit` at the command prompt in the terminal where
> you have entered the `interact` command.
> This is one of the dominant ways---across all clusters and all activity
> types---that resources are wasted.
> If you do not `exit` off of the compute node, and you are not using
> the provided resources, then you tie up those
> resources for others who could otherwise use them.

---------------------------------------

---------------------------------------


## Actions to Take if You Receive an Authentication Problem Within VS Code While Connecting to the ARC Compute Node.

---------------------------------------

---------------------------------------

It is highly likely that at some point, you will run into this situation/problem.

This is because:
1. one authentication is used for all (compute) nodes of a cluster.
   1. So when you log into one compute node, the system may recognize that this is the same authentication that is used for other compute nodes.
2. each user must be authenticated.
   1. So when you log in, you must be recognized.

In both cases, the clusters will want you to reauthenticate.

In the section above where you are using VSC to connect
to the cluster compute node, by selecting 
`Remote-SSH → Connect to Host…`
and then entering the `<hostname>`, you could get a message
in the same box where you entered `<hostname>` the faint
message in gray:  "_the authenticity of host cannot be established_."

This is what you do to re-establish authenticity.

From your laptop, open a terminal window and connect _**DIRECTLY**_ to the compute node.
The steps are:

1. Open a terminal window on your laptop.
   1. If you used a laptop terminal window above to log into the head 
      node and request compute node resources, then open a second terminal window now.  (You need a separate
      terminal window for this.)
2. Establish an `ssh` connection _**DIRECTLY**_ to the compute node
   1. Enter `ssh <compute node host name>`
      1. where `<compute node host name>` is the output from the `hostname` command above.
   2. You will be asked some question to establish authenticity; enter `yes`.
3. Just leave this terminal window as is, e.g., do not close it. 

Now, you should be able to return to the [steps for connecting VS Code](#starting-vs-code) to connect to the cluster compute node.

## Acknowledgment

1. Eslam Huessein for developing the [document in
   the ARC DOCS](https://docs.arc.vt.edu/usage/vscode_remote_ssh.html).
   This workshop is largely based on his information and document.
