# Style reference

## Block quotes and admonitions
`command`

Use language specifiers where they're useful:

"bash"
```bash
# start loop
for ii in `seq 5`
do
    # inside loop
    echo $ii out of 5
    sleep 1
done
```

"python"
```python
# Simple even/odd checker
n = int(input("Enter an integer: "))
print(f"{n} is {'even' if n % 2 == 0 else 'odd'}")
```

No copy button:
<pre><code>
# Demonstrate what it looks like running code, but you don't really want someone to copy-paste because it won't run:
[brownm12@tinkercliffs2 ~]$ module spider Miniforge

----------------------------------------------------------------------------------------
  Miniforge3:
----------------------------------------------------------------------------------------
    Description:
      Miniforge is a free minimal installer for conda and Mamba specific to
      conda-forge.

     Versions:
        Miniforge3/24.11.3-0
        Miniforge3/25.11.0-1

----------------------------------------------------------------------------------------
  For detailed information about a specific "Miniforge3" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider Miniforge3/25.11.0-1
----------------------------------------------------------------------------------------

</code></pre>


Tip:
> [!TIP]
> **Tip:** This is how to do a tip in GitHub markdown

> [!WARNING]
> **Warning:** Watch out for snakes!

> [!INFO]
> **Fact:** Three (also written as "3") is considered by most experts to be a number.

> [!NOTE]
> **Note:** You need to do some cleanup in your `/home`.
