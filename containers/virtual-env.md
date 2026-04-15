# Virtual Environment Within A Container

##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. Demonstrate how to add packages to a default virtual environment (VE),
   to customize it, using a definition file.
2. Illustrating how to run codes outside of the container.
   1. Use the `exec` and `bind` commands.
3. Demonstrate how to extend a container with a VE
   by adding applications.
   1. Demonstrate how the application can be overridden with `exec`.

## Preconditions

1. You are on a compute node.
2. You have loaded the apptainer module:
   1. `module reset`
   2. `module load apptainer`.


#### Build the Apptainer Definition File

The goal is to build a container that houses a virtual environment
containing python 3.14 and packages matplotlib, pandas, and numpy.

This is file _ver02.def_.

```
Bootstrap: docker
From: continuumio/miniconda3

%post
    apt-get update -y
    conda update -y conda
    conda install -y python=3.14
    conda install -y matplotlib
    conda install -y pandas
    conda install -y numpy
```

#### Build the Container and Check for Correct Packages in the VE

Build the container:

```
apptainer build --fakeroot python.ve.container.02.sif  ver02.def
```

Check resulting container/VE to ensure that the desired packages exist:


```
apptainer exec python.ve.container.02.sif conda list
```

Check more directly that the version of python is correct:

```
apptainer exec python.ve.container.02.sif python --version
```

You can compare that result with the default python version:

```
python --version
```

### Very Simple Python Code

This one-line python code is used to demonstrate the execution
of python code using the virtual environment in the container.

File _main.py_.

```
print("  From inside a VE inside a container:  hi")
```


### Running Python Codes With the Container That Use the Virtual Environment

A key consideration in these examples is that _main.py_ is NOT in the container.

If the _main.py_ code resides in the same directory as the container was
built, this works:

```
apptainer exec python.ve.container.02.sif python ./main.py
```

And it works, too, if _main.py_ is in your $HOME directory.

But these examples are limiting.

Consider a more general case in that I made the container on _/projects_.
But the _main.py_ code resides on _/scratch/ckuhlman_.

Then the straight-forward invocation of _main.py_ does not work, i.e.,

```
apptainer exec  python.ve.container.02.sif python /scratch/ckuhlman/main.py
```

does not work.  An error will display saying that the file cannot be found.

We need something more:  the `bind` command, which tells the contain
to work with files in the directory specified with `bind`.
This is what is needed:

```
apptainer exec --bind /scratch/ckuhlman python.ve.container.02.sif python /scratch/ckuhlman/main.py
```




#### Finished

We are finished your container work, so you can:

1. exit (off the compute node).
2. scancel (if you use the `salloc` command; the `interact`
   command will release compute resources automatically).


> [!NOTE]
> Over all ARC systems, not `scancel`ing (i.e., giving back) 
> resources from interactive jobs when you
> are done with them is a HUGE source of wasted resources.

> [!NOTE]
> This is a waste of resources for you and for all users.



