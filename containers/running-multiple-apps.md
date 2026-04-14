# Containers on ARC Clusters

# ---- IN PROGRESS ----

##### Navigate

[Back to Main Page](./main-containers.md)



## More on Exec


If one has multiple applications, and therefore multiple entry points
(one for each app),
you want to use `%apprun` rather than `%runscript` in the definition file.

For example, defining `%apprun foo` and `%apprun bar` allows you to run
them specifically using `apptainer run --app foo <container>` 
or `apptainer run --app bar <container>`.


```
https://www.google.com/search?q=can+there+be+multiple+entries+under+%25runscript+in+an+apptainer+definition+file%3F&rlz=1C5GCEM_enUS1148US1149&oq=can+there+be+multiple+entries+under+%25runscript+in+an+apptainer+definition+file%3F&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRiPAjIHCAIQIRiPAtIBCTE3MzcxajBqN6gCCLACAfEFK3-ZZ7yR63k&sourceid=chrome&ie=UTF-8
```


#### Request An Interactive Session on the Cluster

See *******


#### Construct the Definition File

Create file _multi_app.def_ file immediate below.

Note it contains two apps:  foo and bar (see the `%apprun` sections).

```
Bootstrap: docker
From: ubuntu:22.04

# Global installation
%post
    apt-get update && apt-get install -y fortune-mod cowsay

# Application 1: 'foo'
%apprun foo
    echo "Running App Foo"
    /usr/games/fortune | /usr/games/cowsay

%applabels foo
    Name AppFoo
    Version 1.0

# Application 2: 'bar'
%apprun bar
    echo "Running App Bar"
    # ls /usr/bin | wc -l
    ls /$HOME | wc -l

%appinstall bar
    # (Optional) Specific install steps for app 'bar'
    touch /bar_installed.txt
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

You should see output:

```
```


For the _bar_ application, the file run.app.bar contains

```
apptainer run --app bar my_apps.sif
```

You should see output:

```
```

Note that you can use `exec` as we did in an earlier lesson
to override the operation for the application bar

```
apptainer exec --app bar my_apps.sif ls -l /
```
You should see output:

```
```

Also show, on a separate page, multiple `%runscript` blocks.
You can have as many blocks as you want.
But they are all put in a sequence and they are ALL run with the 
`apptainer run` command.








##### Navigate

[Back to Main Page](./main-containers.md)


