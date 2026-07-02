
---

⬅️ [Previous: Data recovery and long-term storage](./06_data_recovery_long_term_storage.md)

## Best Practices for Specifying Resources

### If there is some way to break them down by category or class, I find that helpful.


![NOTE]  I started writing these down, but they follow so closely the items on the main page right now.

1. Familiarize yourself with characteristics of compute node
   on ARC clusters.
   - TC: [tc resources](https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html)
   - Owl:  [owl resources](https://docs.arc.vt.edu/resources/compute/01owl.html)
   - Falcon:  [falcon resources](https://docs.arc.vt.edu/resources/compute/02falcon.html)  
2. Compare characteristics across node types.
   - Example:  Standard CPU-based compute nodes on Owl have 
    up to 3x the memory as those on TC.
3. Familiarize yourself with QoS (quality of service) options for running jobs.
   - 
4. Know what types of GPU nodes are best suited for different types of operations.
   - Example:
5. Be careful about specifying all resources on one compute node.
   - This can take time for slurm to achieve and provide to you.
     - Example:  






---

⬅️ [Previous: Data recovery and long-term storage](./06_data_recovery_long_term_storage.md)
