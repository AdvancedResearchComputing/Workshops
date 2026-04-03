# Using GNU Parallel

## `:::` to define input parameter set(s)

```bash
parallel -j 4 echo "values:  {1} {2} {3}" ';' sleep 2 \
    ::: cat dog  \
    ::: dancing singing moonwalking  \
    ::: "hot tin roof" driveway "ball at the beach" ceiling
```

## send parameter list in through a pipe
` param-gen-command | parallel -j 4 process-command {}`

Examples parameter generating commands could include:
`ls` - process the files in the current directory
`find . -type d -maxdepth=1 -mindepth=1` - enumerate the immediate subdirectories of the current directory


## Outline
0. [Welcome](./0-intro.md)
1. [Slurm job options overview](./1-slurm.md)
2. [Common parallelization for launching](./2-patterns.md)
3. [MPI launching with `srun` or `mpirun`](./3-mpi.md)
4. [GNU `parallel` overview](./4-parallel.md)
5. [`srun` + `parallel` ](./5-srun_parallel.md)