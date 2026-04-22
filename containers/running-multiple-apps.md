# Constructing and Running a Container With Multiple Apps


##### Navigate

[Back to Main Page](./main-containers.md)



## `%apprun` versus `%runscript`


If one has multiple applications, and therefore multiple entry points
(one for each app),
you want to use `%apprun` rather than `%runscript` in the definition file.

For example, defining `%apprun foo` and `%apprun bar` allows you to run
them specifically using `apptainer run --app foo <container>` 
or `apptainer run --app bar <container>`.



## Preconditions

See the preconditions for this work [here](./preliminaries.md).



#### Construct the Definition File

Create file _multi_app.def_ file immediate below.

Note it contains two apps:  foo and bar (see the `%apprun` sections).

```
Bootstrap: docker
From: ubuntu:22.04

# Global installation
%post
    # apt-get update && apt-get install -y fortune-mod cowsay
    apt-get update
    apt-get install -y fortune-mod
    apt-get install -y cowsay

# Application 1: 'foo'
%apprun foo
    echo "Running App Foo"
    echo "  "
    /usr/games/fortune

%applabels foo
    Name AppFoo
    Version 1.0

# Application 2: 'bar'
%apprun bar
    echo "Running App Bar"
    echo "  "
    ls $HOME | wc -l

%applabels bar
    Name AppBar
    Version 1.0

```

#### The Build Script for the SIF

Create the bash script _run.build.sif_ as follows.

```
apptainer   build   --fakeroot   my_apps.sif multi_app.def
```

#### Run/Execution Scripts

For the _foo_ application, the file run.app.foo contains

```
apptainer run --app foo my_apps.sif
```

You should see output some clever witticism:

```
Running App Foo
  
Q:	Why is it that the more accuracy you demand from an interpolation
	function, the more expensive it becomes to compute?
A:	That's the Law of Spline Demand.
```


For the _bar_ application, the file run.app.bar contains

```
apptainer run --app bar my_apps.sif
```

You should see output that is something like:

```
Running App Bar
  
78
```

where the 78 is the number of directories, symbolic links, and
files in your home directory.


Note that you can use `exec` as we did in an earlier lesson
to override the operation for the application bar









