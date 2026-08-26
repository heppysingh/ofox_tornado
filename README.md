# OrangeFox Recovery Project for Redmi 15C 5G (tornado)

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
| **SoC** | MediaTek MT6835 (Dimensity 6100+) |
| **Architecture** | ARM64 (64-bit) |
| **Display** | 720 x 1640 (20.5:9), 90Hz/120Hz IPS LCD |
| **Storage & RAM** | UFS / eMMC, 4GB / 6GB / 8GB |
| **Partition Scheme** | Virtual A/B (Dynamic Partitions, Boot Header v4) |
| **Recovery Location** | `vendor_boot` partition (`vendor_boot-as-recovery`) |
| **Shipped Android** | Android 13 / 14 |

---

## How to Build OrangeFox

### 1. Sync OrangeFox Source (Using official sync tool)
```bash
mkdir -p ~/OrangeFox_sync
cd ~/OrangeFox_sync
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./orangefox_sync.sh --branch 12.1 --path ~/fox_12.1
```

*Or via direct `repo init`:*
```bash
mkdir -p ~/fox_12.1
cd ~/fox_12.1
repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b 12.1
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
```

### 2. Clone Device Tree
```bash
git clone https://github.com/your-username/ofox_tornado ~/fox_12.1/device/xiaomi/tornado
```

### 3. Build Recovery
```bash
cd ~/fox_12.1
source build/envsetup.sh
lunch fox_tornado-eng
mka vendorbootimage
```

The output zip and `vendor_boot.img` will be in `out/target/product/tornado/`.

---

## Flashing Instructions

Since this device is a **Virtual A/B device with vendor_boot-as-recovery (Header v4)**:

### Flash via Fastboot:
```bash
fastboot flash vendor_boot vendor_boot.img
fastboot reboot recovery
```

### Or flash ramdisk in fastbootd:
```bash
fastboot reboot fastboot
fastboot flash vendor_boot:recovery vendor_ramdisk_recovery.cpio
fastboot reboot recovery
```

---

## Maintainer
- **Maintainer**: @heppysingh
