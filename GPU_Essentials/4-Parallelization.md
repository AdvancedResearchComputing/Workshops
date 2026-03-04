# Parallelization and Optimization with GPUs

## General Recommendations
### Keep the GPUs busy
GPUs are useful to accelerate workloads, but they do not help at all with serial portions of the code or i/o.
```{note}
Amdahl's Law: "the overall performance improvement gained by optimizing a single part of a system is limited by the fraction of time that the improved part is actually used"
```
### One GPU per process
