⬅️ [Previous: Summary of Steps](summary_of_steps.md) | [Next: Step 2:  Use of VS Code on compute nodes ➡️](step_2_every_session.md)

## Step 1:  One-Time Setup

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
   Example:  `cp config config.backup.<date>`
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

You may already have the "Remote - SSH" package installed.
If you are using VS Code on ARC cluster login nodes, then you have it installed.
To determine whether you have it, start VS Code.
Click on the Extensions icon in the left command bar of VS Code.
In the pane to the right, you should see a subsection called "Installed," meaning
this is a list of installed packages.
If you see "Remote - SSH" in this section, then it is installed.

These are the steps to install if you do not have the "Remote - SSH" package
installed.

1. Open VSC on your local machine.
2. Go to the far left command bar and click the `Extensions` button.
3. In the Extensions search bar, type `Remote - SSH`.
4. Find the `Remote - SSH` package in the list of choices provided from the search
   (there should be a blue `Install` button associated with each package).
   1. Click the `Install` button corresponding to `Remote - SSH` and the package will be installed into VSC.



⬅️ [Previous: Summary of Steps](summary_of_steps.md) | [Next: Step 2:  Use of VS Code on compute nodes ➡️](step_2_every_session.md)