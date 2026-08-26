# Copyright (C) 2017-2023 The Android Open Source Project
# Copyright (C) 2014-2023 The Team Win LLC
# SPDX-License-Identifier: Apache-2.0

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Configure virtual_ab compression.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Configure launch_with_vendor_ramdisk.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B
ENABLE_VIRTUAL_AB := true

AB_OTA_UPDATER := true

# A/B updater updatable partitions list. Keep in sync with the partition list.
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# API
PRODUCT_SHIPPING_API_LEVEL := 32

# Bootctrl
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# Fastbootd
TW_INCLUDE_FASTBOOTD := true

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock

# Health Hal
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# MTK PlPath Utils
PRODUCT_PACKAGES += \
    mtk_plpath_utils.recovery

# Additional binaries & libraries needed for recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    libion 

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.vibrator-V1-ndk_platform.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so

# Keymint / Gatekeeper / TEE blobs - pulled from stock tornado device
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/debug_boot.sh:$(TARGET_COPY_OUT_RECOVERY)/root/debug_boot.sh \
    $(DEVICE_PATH)/recovery/root/vendor/bin/tee-supplicant:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/tee-supplicant \
    $(DEVICE_PATH)/recovery/root/vendor/bin/hw/android.hardware.security.keymint@2.0-service.mitee:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/hw/android.hardware.security.keymint@2.0-service.mitee \
    $(DEVICE_PATH)/recovery/root/vendor/bin/hw/android.hardware.gatekeeper@1.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/hw/android.hardware.gatekeeper@1.0-service \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libTEECommon.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libTEECommon.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libteecli.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libteecli.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint_support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint_support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libmiriskmanager_mitee.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libmiriskmanager_mitee.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/lib_android_keymaster_keymint_utils.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/lib_android_keymaster_keymint_utils.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_messages.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_messages.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_portable.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_portable.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libpuresoftkeymasterdevice.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libpuresoftkeymasterdevice.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libsoft_attestation_cert.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libsoft_attestation_cert.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster4support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster4support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/android.system.keystore2-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.system.keystore2-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcppbor_external.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcppbor_external.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcppcose_rkp.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcppcose_rkp.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/android.hardware.gatekeeper@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.gatekeeper@1.0.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/hw/gatekeeper.mitee.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/gatekeeper.mitee.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/hw/libSoftGatekeeper.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/libSoftGatekeeper.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V3-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.security.keymint-V3-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V3-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.keymint-V3-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V2-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.security.keymint-V2-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V2-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.keymint-V2-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.sharedsecret-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.sharedsecret-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.secureclock-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.secureclock-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.secureclock-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.secureclock-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest_fixed.xml:$(TARGET_COPY_OUT_RECOVERY)/root/manifest_fixed.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest_mt6835.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest_mt6835.xml \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/14b0aad8-c011-4a3f-b66aca8d0e66f273.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/14b0aad8-c011-4a3f-b66aca8d0e66f273.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/377ee4e8-af0e-474f-a9d636a9268fe85c.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/377ee4e8-af0e-474f-a9d636a9268fe85c.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/3d08821c-33a6-11e6-a1fa089e01c83aa2.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/3d08821c-33a6-11e6-a1fa089e01c83aa2.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/4d573443-6a56-4272-ac6f2425af9ef9bb.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/4d573443-6a56-4272-ac6f2425af9ef9bb.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/511ead0a-0000-0000-0000000000000000.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/511ead0a-0000-0000-0000000000000000.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/59a4867c-9fe5-f7c2-b409a46bae6ff73e.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/59a4867c-9fe5-f7c2-b409a46bae6ff73e.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/655a4b46-cd77-11ea-aafbf382a6988e7b.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/655a4b46-cd77-11ea-aafbf382a6988e7b.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/68bcd09d-4101-4c0a-9552ed0af9ae16b2.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/68bcd09d-4101-4c0a-9552ed0af9ae16b2.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/86f623f6-a299-4dfd-b560ffd3e5a62c29.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/86f623f6-a299-4dfd-b560ffd3e5a62c29.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/88ce8e6b-8646-4092-bb78faf5b55ff4df.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/88ce8e6b-8646-4092-bb78faf5b55ff4df.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/8aaaf201-2460-0000-7143fe4f7c823c80.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/8aaaf201-2460-0000-7143fe4f7c823c80.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/9811c1f6-47e3-5cea-ae6ef62ba433c4fd.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/9811c1f6-47e3-5cea-ae6ef62ba433c4fd.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/dba51a17-0563-11e7-93b16fa7b0071a51.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/dba51a17-0563-11e7-93b16fa7b0071a51.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/e5140b33-76fa-4c63-ab18062caab2fb5c.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/e5140b33-76fa-4c63-ab18062caab2fb5c.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/e97c270e-a5c4-4c58-bcd3384a2fa2539e.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/e97c270e-a5c4-4c58-bcd3384a2fa2539e.ta \
    $(DEVICE_PATH)/recovery/root/vendor/mitee/ta/f13010e0-2ae1-11e5-896a0002a5d5c51d.ta:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/mitee/ta/f13010e0-2ae1-11e5-896a0002a5d5c51d.ta

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Overrides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.device=$(PRODUCT_RELEASE_NAME)

# Use /product/etc/fstab.postinstall to mount system_other.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.postinstall.fstab.prefix=/system
