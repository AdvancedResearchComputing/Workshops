# Beyond Pure Compute Considerations

Sometimes there are factors to consider beyond the execution of a job.

One is the use of Python and the use of virtual environments.

To run Python codes with virtual environments (VEs), the 
virtual environments should be built on the same type 
of compute node on which you are going to run your job.

Example 1:

_Requirement_:

I have a Python code that uses GPUs.
I can run on any of the four types of GPUs on the Falcon cluster.
And I want that flexibility to run on any of these compute node
types, because before I submit my job, I will look at the 
ARC-provided dashboards to see which nodes are least used, thinking
that my jobs will start sooner on that type of node.

_Solution (Partial)_:

This means that I have to create the VE that I will need on each
of the four types of compute nodes of Falcon.