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
|GPU|Memory|TDP | FP64|TF64| FP32 | TF32| INT8|FLOPS/Watt dp|FLOPS/Watt sp| FLOPS/Watt I8|
|:-|:--|--|--|--|--|--|-|-|-| -|
|T4|   16G|   70W| - | - |8.1TF| - | 130TO| -|115G (FP)| 1857G |
|V100| 16G|  250W| 7TF | - | 14TF | - | 250TO |  28G (FP)|56G (FP)|1000G|
|A30|  24G|  165W| 5.2TF| 10.3TF|10.3TF|82TF|330TO| 62.4G (TF)|328G (TF)|1320G|
|A100| 80G|  400W| 9.7TF | 19.5TF | 19.5TF | 156TF | 624TF| 48.8G  (TF) |390G (TF) |1560G|
|L40S| 48G|  350W|  - | - | 91.6TF | 183TF | 733TO |-| 523G (TF)|2094G|
|H200|141G|  700W| 34TF | 67TF | 67TF | 989TF | 3958TF| 95.7G (TF) |1413G (TF)|5654G|
|_B200_|_184G_| _1000W_|_37T_|_37T_|_75T_|_1100T_|_4500T_|_37G (TF_)| _75G (TF)_|_4500G_|

