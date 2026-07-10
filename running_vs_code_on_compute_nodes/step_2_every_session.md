⬅️ [Previous: Step 1:  Setup](step_1_setup.md) | [Next: Step 3:  Potential access issue and solution ➡️](step_3_possible_error.md)

---

## Step 2:  Using VS Code on an ARC Compute Node



By "session" we mean make a connection through VSC on your laptop
to an ARC cluster compute node and do your work.

These are the steps for one session and need to be repeated for each
subsequent session.

The major steps to execute, which we describe in more detail below, are:

1. From a cluster login node, request an interactive Slurm job
   through a terminal window.
   1. You will be provided a compute node (name).
2. Use VSC, running on your laptop, to connect to the compute node
   provided in the previous step.
3. Do your work through VSC on the compute node, which may entail 
   using (AI) packages, debugging code, and running code.
4. Be careful to relinquish the interactive job resources when you are finished.

> [!NOTE]
> Save our work frequently in VSC.
> When the interactive job ends, your VSC connection to the compute
> node WILL end and you will lose any work that you have not saved.


### Log Into an ARC Cluster Login Node

We need to log into an ARC cluster login node so that
we can request resources on a compute node.

Logging onto a login node, can be performed using any of the following:

1. A terminal window on your laptop.
2. A terminal window obtained through [ARC's Open OnDemand](https://ood.arc.vt.edu) (OOD).


Execute the commands in _**ONE**_ of the two following subsections
(per the listing immediately above), to
log into a login node using a terminal window.

#### Recommended Way:  Using a Terminal Window on Your Laptop to Log Into an ARC Cluster Login Node

1. Open a terminal window on your laptop.
2. ssh into a cluster login node for the cluster where you want to do VSC work.
   1. For example, if you want to log into the owl login node 2:
      1. `ssh <user_name>@owl2.arc.vt.edu`
3. Now you are logged into a login node.

#### Alternative Way:  Using a Terminal Window Through Open OnDemand (OOD) to Log Into an ARC Cluster Head Node

1. Go to the [ARC OOD landing page](https://ood.arc.vt.edu).
2. At the command bar at the top of the page (currently in maroon),
   click the `Clusters` drop down and select one of the Falcon, Owl,
   or Tinkercliffs shell access for a login node corresponding to the
   cluster on which you want to use a compute node for VSC.
3. You will be placed on a terminal window.
4. You are now logged into a login node.

### Request Compute Node Resources From a Cluster Head Node

You are on an ARC cluster login node.

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

For more about the `constraint` switch, 
see [constraints](https://docs.arc.vt.edu/usage/job_scheduling/01_slurm_overview.html#slurm-constraints) for more details.
A GPU-based interactive job needs `--gres` to specify the 
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


### Using VS Code From Your Laptop to Run on a Compute Node


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
3. A new VS Code Instance will pop up---the one that is trying to start on the compute node.
4. One of two paths now occurs:
   - Success path:
     - A pop-up box may appear.  If so, select the `/Users/<your_user_name>/.ssh/config` option.
     - Go down to the lower right of the IDE, and click the "Connect" button.
     - VS Code will launch a new IDE instance.
   - Problem path:
     - You might encounter the _**Authentication Problem**_ referred to in the
       [summary of steps](./summary_of_steps.md) below.
       In the new VS Code instance, in the upper middle of the IDE,
       you will see a message in very light gray---which is very difficult to 
       see---that there is an authentication problem.
       [That section (Step 3)](./step_3_possible_error.md) describes how to solve this problem.
       A tip-off that there is a problem is that the new VS Code instance is trying to connect to the 
       compute node named `hostname`, and in the lower left of this new window, in blue, it will just
       keep "spinning," showing "Opening Remote..."
5. If all is going well, then in the new VS Code instance,
   you should see at lower right something like
   "Downloading VS Code Server".  This is good.
6. IF/When prompted, choose `Linux` as the remote platform.
7.  VS Code’s remote server now runs on the compute node instead of the login node.
8.  You should see a blue box in the new VS Code IDE instance 
   at the lower left stating `SSH: <hostname>`, indicating that you are connected to the ARC compute node `<hostname>`.
9.  Another way to verify that you are on a compute node is to select
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
      1. This will log you off of the compute node and put you back on the login node.
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


---

⬅️ [Previous: Step 1:  Setup](step_1_setup.md) | [Next: Step 3:  Potential access issue and solution ➡️](step_3_possible_error.md)