# Running Code That is Outside A Container

##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. In some cases, you might want to produce a container
   that houses only some environment (no apps/executable code).
2. Or, you may have a container that has codes in it, but
   you only want to make use of the environment of that 
   container.
3. In these cases, you may want to run a code that you
   possess in the container's environment.
4. Illustrating how to run codes outside of the container.
   1. Use the `exec` and `bind` commands.

## Preconditions

Do the preconditions in the [Preliminaries](./preliminaries.md) page.


#### Using a Container built from a Sandbox

We use the container that we built in the [previous lesson](./sandbox-and-sif.md).


#### Run a Python Code

We have the file _main.02.py_ in _/scratch/ckuhlman_ from a previous lesson.
This code just adds _c = 2 + 3 = 5_ and prints the result to screen.
It is handy because it resides in a location that is not on
the path of this container.
The code itself is below.

```
apptainer exec --bind /scratch/ckuhlman my_py310_container.sif python3 /scratch/ckuhlman/main.02.py
```

Note that if we leave off the `bind` command and instead use

```
apptainer exec my_py310_container.sif python3 /scratch/ckuhlman/main.02.py
```

then an error will result because the container cannot see the _/scratch/ckuhlman_ directory.



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


#### Python Codes Used in this Lesson

The lesson is more revealing if 
you put these codes in your
`/scratch/<user_name>` directory, or other appropriate directory.

##### `main.02.py` Python Code


```
a=2
b=3
c=a+b
print("  c : ",c)
```

##### `main.03.py` Python Code

```
val_a = (int)(sys.argv[1])
val_b = (int)(sys.argv[2])
output_file = (str)(sys.argv[3])

c=val_a+val_b
fh_out = open(output_file,"w")
fh_out.write("  c = " + str(c) + "\n")
fh_out.close()
```