#
# Copyright (C) 2024-2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from core products
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit from OrangeFox / vendor configuration
$(call inherit-product-if-exists, vendor/recovery/config/common.mk)
$(call inherit-product-if-exists, vendor/fox/config/common.mk)
$(call inherit-product-if-exists, vendor/omni/config/common.mk)
$(call inherit-product-if-exists, vendor/twrp/config/common.mk)
$(call inherit-product-if-exists, vendor/orangefox/config/common.mk)

# Device identifier
BOARD_VENDOR := xiaomi
PRODUCT_DEVICE := tornado
PRODUCT_NAME := fox_tornado
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi 15C 5G
PRODUCT_MANUFACTURER := Xiaomi

# Device path for OEM device tree
DEVICE_PATH := device/xiaomi/tornado

# Inherit from hardware-specific part of the product configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)
