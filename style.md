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

Tip:
> [!TIP]
> **Tip:** This is how to do a tip in GitHub markdown

> [!WARNING]
> **Warning:** Watch out for snakes!

> [!INFO]
> **Fact:** Three (also written as "3") is considered by most experts to be a number.

> [!NOTE]
> **Note:** You need to do some cleanup in your `/home`.

## Media
Include images:
![A100 GPU Architecture](Best_Practices_Overview/images/Filesystems_locality.png)