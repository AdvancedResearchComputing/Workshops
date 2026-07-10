## Step 3:  Actions to Take if You Receive an Authentication Problem Within VS Code While Connecting to the ARC Compute Node

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

Now, you should be able to return to the Section above
"_Using VS Code From Your Laptop to Run on a Compute Node_" to connect to the cluster compute node.
When you go back to that section and those directions, (1) close the VS Code instance that was
trying---unsuccessfully---to connect to the compute node and (2) start over at the beginning of
those instructions.