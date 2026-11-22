# OrangeFox Recovery Project for Redmi 15C 5G (tornado)

# ⚠️ Warning for those who might use this tree
# the vendor_boot.img got as output is not directly flahshable,either install it using zip with stock vendor_boot flashed or pack stock vendor_ramdisk_.cpio using magiskboot 
Device tree for building OrangeFox Recovery for **Redmi 15C 5G** (and variants).

```
#
# Copyright (C) 2024-2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
```

## Device Specifications

| Feature | Specification |
| :--- | :--- |
| **Device** | Redmi 15C 5G / Redmi 15R 5G / Poco C85 5G |
| **Codename** | `tornado` |
| **SoC** | MediaTek MT6835 (Dimensity 6300) |
| **Architecture** | ARM64 (64-bit) |
| **Display** | 720 x 1640 (20.5:9), 90Hz/120Hz IPS LCD |
| **Storage & RAM** | UFS / eMMC, 4GB / 6GB / 8GB |
| **Partition Scheme** | Virtual A/B (Dynamic Partitions, Boot Header v4) |
| **Recovery Location** | `vendor_boot` partition (`vendor_boot-as-recovery`) |
| **Shipped Android** | Android 15 / 16 |







---
## Maintainer
- **Maintainer**: @heppysingh
