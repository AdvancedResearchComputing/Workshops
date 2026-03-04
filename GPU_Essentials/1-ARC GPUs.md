# ARC GPU Offerings and Device Comparisons

## Summary of GPUs
|Model|Cluster|Quantity|Configuration|Interconnect|
|:-----|:-----|-------:|:------------|:-----------|
|T4|Falcon |18| PCIe, 1 GPU per node | none|
|V100| Falcon| 80| PCIe, 2 GPUs per node| none|
|[A30]()| Falcon| 128| PCIe, 4 GPUs per node| NVLink Bridge 2-way|
|L40S| Falcon | 80| PCIe, 4 GPUs per node | none|
|A100| Tinkercliffs, Biomed, CUI | 136| SXM, 8 GPUs per node| NVSwitch, HDR IB |
|H200| Tinkercliffs | 48 | SXM, 8 GPUs per node | NVSwitch |
|_B200_| _Owl (summer 2026)_| _32_ | _SXM, 8 GPUs per node_ | _NVSwitch_ |

T4: https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/tesla-t4/t4-tensor-core-datasheet.pdf
A30: https://www.nvidia.com/content/dam/en-zz/Solutions/data-center/products/a30-gpu/pdf/a30-datasheet.pdf?ncid=no-ncid
L40S: https://www.nvidia.com/en-us/data-center/l40s/
A100: https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/a100/pdf/nvidia-a100-datasheet-nvidia-us-2188504-web.pdf
H200: https://resources.nvidia.com/en-us-data-center-overview/hpc-datasheet-sc23-h200

## Specifications
|GPU|Memory|TDP | FP64|TF64| TF32| INT8|GF/W|
|:-|:--|--|--|--|--|--|-|
|T4|   16G|   70W|
|V100| 16G|  250W|
|A30|  24G|  165W|
|L40S| 48G|  350W|
|A100| 80G|  400W|
|H200|141G|  700W|
|B200|184G| 1000W|

