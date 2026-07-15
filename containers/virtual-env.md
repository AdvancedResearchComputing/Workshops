# Virtual Environment Within A Container

##### Navigate

[Back to Main Page](./main-containers.md)

## Summary of this Lesson

1. Demonstrate how to add packages to a default virtual environment (VE)
   and thereby customize it, using a definition file.
   - The resulting VE is inside a container.
2. Illustrating how to run codes outside of the container that use the VE.
   1. Use the `exec` and `bind` commands.
3. Demonstrate how to extend a container with a VE:
   1. By adding applications.
   2. Demonstrate how the application can be overridden with `exec`.

## Preconditions

See the preconditions for this work [here](./preliminaries.md).



### Case 1:  A Container Housing only a Python Virtual Environment


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
    conda install -c conda-forge statsmodels
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

### Run a Code to Generate a Linear Model for Data and Plot


The execution is:

```
apptainer exec python.ve.container.02.sif python linear-fit.py  in_data.inp  results.png
```

After the code runs, the contents of the output file _results.png_ is:




### Very Simple Python Code

This one-line python code is used to demonstrate the execution
of python code using the virtual environment in the container.

File _main.py_.

```
print("  From inside a VE inside a container:  hi")
```


### Running Python Codes With the Container That Use the Virtual Environment

A key consideration in these examples is that _main.py_ is NOT in the container.

If the _main.py_ code resides in the same directory as the container, this works:

```
apptainer exec python.ve.container.02.sif python ./main.py
```

And it works, too, if _main.py_ is in your $HOME directory.
The final case where the above command will work is if _main.py_ is in the `tmp`
directory.

But these examples are limiting.

Consider a more general case in that the container is made on _/projects_.
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

> [!NOTE]
> If you need multiple bind directories, simply separate them with commas.
> Example  `--bind  ${first_dir},${second_dir}`.

### Case 2:  A Container Housing a Python Virtual Environment and a Python Code


#### Build the Apptainer Definition File

The goal is to build a container that houses a virtual environment
containing python 3.14 and packages matplotlib, pandas, and numpy.
It now also contains the file main.py.

This is file _ver03.def_.

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

%runscript
    python  ./main.py

```

#### Build the Container and Check for Correct Packages in the VE

Build the container:

```
apptainer build --fakeroot python.ve.container.03.sif  ver03.def
```

Check resulting container/VE to ensure that the desired packages exist:


```
apptainer exec python.ve.container.03.sif conda list
```

Check more directly that the version of python is correct:

```
apptainer exec python.ve.container.03.sif python --version
```

You can compare that result with the default python version:

```
python --version
```


### Running Python Codes With the Container That Use the Virtual Environment

A key consideration in these examples is that _main.py_ is in the container.

This means that we can use the apptainer `run` command to run the enclosed code.

```
apptainer run python.ve.container.03.sif
```

We can still run other python codes that use the VE in the container by
once again using the `exec` command.
 
Consider a more general case in that the container is made on _/projects_.
But the _main.02.py_ code resides on _/scratch/ckuhlman_.


We need something more:  the `bind` command, which tells the container
to work with files in the directory specified with `bind`.
Two cases are below:  the first does not work, the second does.
We see that the second case executes a code outside of the container 
instead of the code inside the container.

```
echo " " 
echo "  this will NOT work:"
apptainer exec python.ve.container.03.sif python /scratch/ckuhlman/main.02.py


echo " " 
echo "  this will work:"
apptainer exec --bind /scratch/ckuhlman  python.ve.container.03.sif python /scratch/ckuhlman/main.02.py

```


#### Codes

This is the same _main.py_ code as used above.

File _main.py_.

```
print("  From inside a VE inside a container:  hi")
```

We have a second python script, _main.02.py_, which was also used before:

```
a=2
b=3
c=a+b
print("  c : ",c)
```



Code _linear-fit.py_:

```python
# Purpose:  demonstrate simple plotting of x-y data and linear fit.

# Modules:
# module load

import time
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
import statsmodels.api as sma

begin_time=time.time()

# CLAs (command line arguments).
input_filename=sys.argv[1]
output_filename=sys.argv[2]
x_lower_fit=(int)(sys.argv[3])
x_upper_fit=(int)(sys.argv[4])

# Load the data into a df.
df = pd.read_csv(input_filename, sep=' ')

# Print the data to confirm.
print("  Contents of dataframe (df):")
print(df)

# Fit the ordinary least squares (OLS) model
# The formula 'y_values ~ x_values' automatically includes an intercept (b)
model = smf.ols(formula='response ~ predictor', data=df)
results = model.fit()

# Print out only the calculated coefficients (Intercept and Slope)
print("Intercept (b):", results.params['Intercept'])
print("Slope (m):", results.params['predictor'])
print("  model summary: ")
print(results.summary())

# Generate the line from the least squares fit.
x_fit=list()
y_fit=list()

x_fit.append(x_lower_fit)
x_fit.append(x_upper_fit)

y_val = results.params['predictor'] * x_lower_fit + results.params['Intercept']
y_fit.append(y_val)
y_val = results.params['predictor'] * x_upper_fit + results.params['Intercept']
y_fit.append(y_val)


# Plot the results.

# Plot the original data points and the fit line
plt.scatter(df.predictor, df.response, color='blue', alpha=0.6, label='Data Points')
plt.plot(x_fit, y_fit, color='red', linewidth=2, label='Statsmodels Fit')
plt.xlabel('predictor')
plt.ylabel('response')
plt.legend()
plt.savefig(output_filename)

end_time=time.time()
duration = end_time - begin_time

print("  execution duration (s) : ",duration)
```


File _in_data.inp_:

```bash
predictor response
40 62
45 64
58 70
63 72
69 79
72 85
75 82
80 87
85 92
93 99
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


##### Navigate

[Back to Main Page](./main-containers.md)

[previous lesson:  container with multiple Python apps](./multiple-python-apps.md)

[next lesson:  container and Slurm batch jobs](./slurm-jobs.md)



