# Containers on ARC Clusters



## ARC Resources and Mechanisms for Assistance

A <a href="https://docs.arc.vt.edu/all-help.html" target="_blank">listing</a> of all ways to get help from VT ARC and access to information, and links to those resources, are provided.  Examples:
- determine and attend office hours
- submit help tickets (for errors, problems, or request a consultation)
- obtain listings of workshops (and video recordings and notes files)
- view video tutorials
- run example codes
- understand overall cluster status and performance, as well as those of your jobs, via dashboards
- more

## Container 

(Loosely): A _**container**_ is a file that houses a computing environment and, most often,
scripts and/or applications that run in this environment.

Containers have the following, and other, features:
portability,
customizability,
sameness,
and pseudo-permanence.

## Our Approach

We have two main goals:

1. Convey some of the dominant ideas about containers.
2. Provide simple examples that illustrate these ideas via:
   1. building containers
   2. using/executing containers.

So, for example, what is NOT covered here are more sophisticated
container examples.
These are covered in the links in Section "VT-Generated Resources" below.

## Outline/Examples

- [Concepts](./concepts.md)
- [Preliminaries](./preliminaries.md)
- [Build Container From a Definition File Using a Docker Image](./def-file-container.md)
- [Build Container With Multiple `%runscript`s](./multiple-runscripts.md)
- [Build a Sandbox and Convert to a Container](./sandbox-and-sif.md)
- [Build a Container With Multiple Apps](./multiple-apps.md)
- [Build a Container With Multiple Python Apps](./multiple-python-apps.md)
- [Use of Virtual Environments Inside a Container](./virtual-env.md)
- [Run Apptainer Using Sbatch Slurm Script](./slurm-jobs.md)
- [Useful Commands](./useful-commands.md)

## Other Topics Coming

- How to build a VE within a sandbox.
- How to build from Apptainer library (started).
- How to construct a container where each app requires a
  different environment.
- How to construct a container for MPI use across compute nodes.

## Warning About Web Pages on Containers

Like a lot of different software categories, different institutions set up
their cluster environment differently for the use of containers.
So it is pretty easy, for example, to lock on to another university's web
pages for how to build and use containers, and find that none of their
approaches to containers works
on VT ARC clusters.
So the advice is that if you are working away and not making much progress,
you might consider reading different pages.

That said, there was a lot of useful information on the web that informed these pages.
But then, there were a lot of "rabbit holes" ...

## Acknowledgments

Alberto Cano and Saikat Dey for
constructing the [ARC Docs page on Containers](https://docs.arc.vt.edu/software/apptainer.html#singularity).

Sofia Lima for
providing another example at
[VT ARC git container example](https://github.com/AdvancedResearchComputing/examples/tree/master/apptainer/1.4.0).

Adeyemi Aina for
providing more examples of contain construction and use
in [VT ARC github](https://github.com/AdvancedResearchComputing/examples/tree/master/apptainer).
These pages also have notes, similar to this set of notes.
One perspective is that Yemi's pages are more complex, with realworld examples.
In contrast, this workshop is designed to introduce major issues (features, commands, approaches)
and working examples that can be extended.

Nicole Braunscheidel for composing an [MPI containerized example](https://github.com/AdvancedResearchComputing/examples/tree/master/cp2k).

Thanks to Ben Sandbrook for reviewing this workshop and making improvements
to it.

So all of these resources should be viewed as complementary.


## References


----------------------------------------------
VT-Generated Resources
----------------------------------------------


- [VT ARC Docs page](https://docs.arc.vt.edu/software/apptainer.html#singularity)
- [VT ARC Github Container Example Codes](https://github.com/AdvancedResearchComputing/examples/tree/master/apptainer).
- [VT ARC Github MPI-Based CP2K Container Example](https://github.com/AdvancedResearchComputing/examples/tree/master/cp2k).
  

----------------------------------------------
Apptainer Resources
----------------------------------------------


- [Apptainer Root Page](https://apptainer.org/docs/user/main/introduction.html) 
- [Apptainer:  Build an Apptainer from Docker Image](https://apptainer.org/docs/user/main/build_a_container.html#:~:text=sif%20lolcow.def-,Building%20containers%20from%20Dockerfile%20with%20BuildKit,PATH%20CMD%20date%20%7C%20cowsay%20%7C%20lolcat)
- [Apptainer and Singularity](https://apptainer.org/docs/user/main/singularity_compatibility.html)
- [Apptainer and Apps](https://apptainer.org/docs/user/main/definition_files.html#scif-apps)

----------------------------------------------
Other Resources
----------------------------------------------

Recall comment about how a cluster is set up can make a (big)
difference in the steps required to build a container.
So some/a lot of this material for constructing containers
is not like googling "Python How to convert a list to a string".


- [Apptainer and Additional Applications](https://collab.dvb.bayern/spaces/UniARZHPCKB/pages/1014857861/Container+with+Apptainer)
- [Apptainer and Virtual Environments](https://res-wiki.appstate.edu/books/environments-on-hpc/page/building-conda-environments-in-apptainer)
- [Apptainer and virtual Environments, 2](https://info.gwdg.de/news/using-apptainer-containers-to-manage-your-python-environments/)
- [Bootstrap Agents](https://apptainer.org/docs/user/main/definition_files.html#preferred-bootstrap-agents)
- [Gentle Intro](https://medium.com/@alex-ignatov/gentle-introduction-to-apptainer-90ec65ce01b3)
- [Good overview](https://virgo-docs.hpc.gsi.de/blog/posts/2023-11-29-apptainer-containers/index.html)




