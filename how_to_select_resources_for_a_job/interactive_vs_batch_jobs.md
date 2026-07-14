# Interactive Versus Batch Jobs

### Loose Definitions

**Interactive Job**:  Process by which:
- You specify your resource needs.
- You submit the resource needs to slurm.
- You receive those resources and are notified.
- You _manually_ use those resources to do work.
- You will be directly interacting with the resources for the entire time they are allocated
- You have allocated to you those resources until one of these events:
  - You exceed your allotted time for the resources.
  - You finish your work early and _manually_ relinquish the resources.


**Batch Job**:  Process by which:
- You specify your resource needs _AND_ the work you want done with those resources.
- You submit the resource needs _AND_ job definition to slurm.
- You receive those resources _AND_ your job definition starts running on those resources.
- You have allocated to you those resources until one of these events:
  - You exceed your allotted time for the resources.
  - Your work finishes and the resources are automatically relinquished.

### General Guidelines for Their Use (There are Always Exceptions)

_Use of interactive jobs_:

 - Workflow development and testing
 - You are doing scoping studies and you want to:
    - determine what the analysis steps are
    - see intermediate results
    - (e.g., you are exploring and uncertain.)
 - You need visualization.
 - You have very few jobs to run.
  
Note: for all of these cases above, except for visualization, you can still use
batch jobs (below).

_Use slurm batch jobs_:

- You know your analysis steps, or you may have only one or two issues to resolve.
- You are doing scoping studies, but you do not need to see 
 on-the-fly intermediate results; only the results are sufficient.
- You do not need visualization in the job.
- You have many, many jobs to run (say, 15 or 1000 or more)

### Choosing the Type of Job:  Interactive or Batch

If you can run either interactive or batch mode, then we prefer that you run batch mode.

This provides maximum benefit to you and everyone else.

**Why choose batch job?**

 - The slurm scheduler can make far better use of resources if left to itself.
   - Human intervention (via interactive jobs) can only reduce the efficiency of slurm.
 - EVERYONE benefits when this happens.
 - Specifics:
   - Interactive jobs
     - (1) Interactive jobs may not start when you are around.
       - In this case, resources are assigned to you but you are not using them.
       - So the resources sit idle waiting for you; others cannot use these resources.
     - (2) When a person is done with an interactive job, they must explicitly give back the resources.
       - If a user does not give the resources back, then resources are idle
         until the job wall time is reached.
       - Idle resources are wasted resources; others cannot use these resources.
   - Batch jobs, by their nature, do not suffer these inefficiencies.
     - So resources spend more time devoted to running jobs with batch mode.

The above reasoning is just to present the issues.

But remember this ...

**You should choose the job type that you need:  if you need interactive jobs, then use them.**