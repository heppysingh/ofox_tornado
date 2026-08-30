#
# Copyright (C) 2024-2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Device Info
export TARGET_DEVICE="tornado"
export FOX_TARGET_DEVICES="tornado"
export TARGET_DEVICE_ALT="tornado"
export OF_MAINTAINER="heppysingh"

# Target Architecture
export TARGET_ARCH="arm64"

# Virtual A/B & vendor_boot as recovery
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VENDOR_BOOT_RECOVERY=1
export FOX_INSTALLER_VENDOR_BOOT_RAMDISK_INSTALL=1
export OF_DYNAMIC_FULL_SIZE=9126805504
export OF_NO_REFLASH_CURRENT_ORANGEFOX=1
export OF_NO_SPLASH_CHANGE=1

# Size Optimization & Ramdisk Compression (LZ4 is required for MT6835 Little Kernel)
export OF_USE_LZ4_COMPRESSION=1
export FOX_REMOVE_AAPT=1
export FOX_EXCLUDE_NANO_EDITOR=1
export FOX_COMPRESS_EXECUTABLES=1

# Display, Notch & UI Customization (720x1640 / 720x1600 notch)
export OF_SCREEN_H=2400
export OF_STATUS_H=100
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=1
export OF_CLOCK_POS=0
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_USE_LOCKSCREEN_BUTTON=1

# Hardware & System Features
export OF_USE_GREEN_LED=0
export OF_FLASHLIGHT_ENABLE=1
export OF_FL_PATH1="/sys/class/leds/led_torch_2"
export OF_USE_LEGACY_BATTERY_SERVICES=1
export OF_FORCE_CASEFOLDING=1
export OF_FORCE_PREBUILT_KERNEL=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_PATCH_AVB20=1
export OF_VAB_ORS_WIPE_DATA_IS_FORMAT=1
export OF_DEFAULT_TIMEZONE="TAIST-5:30;IST"
export OF_FBE_METADATA_MOUNT_IGNORE=0

# Partition Tools & Backups
export OF_ENABLE_LPTOOLS=1
export OF_ENABLE_ALL_PARTITION_TOOLS=1
export OF_QUICK_BACKUP_LIST="/boot;/data;/super;"
