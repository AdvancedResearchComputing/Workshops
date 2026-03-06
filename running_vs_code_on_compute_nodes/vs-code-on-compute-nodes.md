# Operating VS Code On Compute Nodes


## Ideas Behind This Workshop

1. VS Code is a popular IDE for developing code and other files.
2. Running VS Code is allowable on head nodes IF
   1. You do not run with plugins, e.g., do not run with AI plugins.
   2. You do not run code:  no code execution, no major code debugging.
3. Why these restrictions?
   1. Because head nodes are communal resources that all users make use of _**simultaneously**_.
   2. (Compute nodes, on the other hand, _**ARE**_ used by a selected few users at a time according to Slurm scheduler operations.)
   3. So if you are consuming lots of resources on head nodes, then you are degrading 
          the performance of the head nodes for all other users.
       1. VS Code is a _**primary**_ way that users consume too many resources on head nodes.
   4. It is most useful to think of yourself and all other 1000 ARC users as being in the same boat:
         we need to be respectful of others, by following agreed upon procedures, so that everyone
         can work efficiently and get their work done.
4. To summarize:  I want to use VS Code to do my work and
   1. I want to debug and run my code.
   2. I want to use AI or other plugins.
5. How do I do this?
6. By running your instance of VS Code on a _**compute**_ node.
7. This workshop is all about running VS Code on compute nodes.



## Organization

### Applicability

1. These procedures apply to Tinkercliffs (TC), Owl, and Falcon clusters.


### Prerequisites

1.  ssh installed on your local machine (comes with most laptops). [SSH keys](sshkeys)
2.  If working remotely, have [VT VPN](https://www.nis.vt.edu/ServicePortfolio/Network/RemoteAccess-VPN.html) installed on your laptop (local machine).
3.  ARC [account](https://arc.vt.edu/account).
4.  Project for file storage.  Not absolutely critical for this workshop, but critical for your work.
5.  [allocation](allocations) to charge "jobs" to.
6.  


### Major Activities

1. VS Code
   1. Install VS Code (VSC) on your laptop.
   2. Install the `Remote-ssh` plugin in your VSC.
   3. Make sure you have a 
2. Laptop (or local machine)
   1. Alter the _config_ file under directory _.ssh_ as below





## Altering Your ssh Config File for Wildcard ProxyJump

The idea.

1.  Create a set of commands to help you automate the process of accessing a compute
node on which to run VSC.
2.  You do this inside of the `config` file that is located in the `~/.ssh` directory.

Directions.

1. On your laptop, go to `~/.ssh` directory.
2. Make a copy of your config file.  Example  `cp -p config config.backup.<date>`
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


What this does:

- Any hostname matching one of the patterns (e.g., `tc006`, `tc-xe001`, `fal012`, `owl-hm03`) will automatically:
  - SSH to the appropriate login node (`tinkercliffs2`, `falcon2`, `owl3`), then
  - ProxyJump into the compute node.
- Negative patterns like `!tc1` and `!tc2` ensure that the login nodes themselves do **not** use ProxyJump, so you can still run `ssh <your_VT_PID>@tinkercliffs2.arc.vt.edu` directly.


```{note}
Always use a login node for the **same cluster** where you plan to run jobs (e.g., `tinkercliffs1`/`tinkercliffs2` for `tc*` nodes).
``` 


## Credits

1. Eslam Huessein for developing the document in the [ARC doc](https://docs.arc.vt.edu/usage/vscode_remote_ssh.html)