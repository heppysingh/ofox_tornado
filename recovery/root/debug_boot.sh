#!/system/bin/sh
set -x
# TWRP Debug Boot Script - @vbs_1 & @dream_7x & @heppysingh - Decryption Fix
LOGFILE="/tmp/debug_boot.log"

log_msg() {
    echo "$1"
    echo "$1" > /dev/kmsg
}

exec > $LOGFILE 2>&1

log_msg "--- TWRP DEBUG BOOT START ---"
date
id

# 0. Force SELinux Permissive immediately
log_msg "Forcing SELinux Permissive..."
setenforce 0 2>/dev/null
getenforce

# 1. TEE Node Permissions
log_msg "Waiting for TEE device nodes..."
TIMER=0
while [ ! -c /dev/teepriv0 ] && [ $TIMER -lt 5 ]; do
    sleep 1
    TIMER=$((TIMER + 1))
done

if [ -c /dev/teepriv0 ]; then
    log_msg "Found TEE nodes — setting permissions"
    chmod 0666 /dev/teepriv0 /dev/tee0 /dev/teelog0 /dev/kmsg 2>/dev/null
    chown system:system /dev/teepriv0 /dev/tee0 2>/dev/null
    ls -lZ /dev/teepriv0 /dev/tee0 2>/dev/null
fi

# 2. Dynamic OS Version Probing from super partition (to eliminate Error -33)
log_msg "Probing unencrypted ROM properties from super partition..."
mkdir -p /tmp/mnt_probe 2>/dev/null
PROBE_SUCCESS=0

# Try mounting system partition to read ROM build.prop
for dev in \
    /dev/block/mapper/system_a \
    /dev/block/mapper/system \
    /dev/block/by-name/system_a \
    /dev/block/by-name/system \
    /dev/block/dm-4; do
    if [ -e "$dev" ]; then
        if mount -o ro -t erofs "$dev" /tmp/mnt_probe 2>/dev/null || \
           mount -o ro -t ext4 "$dev" /tmp/mnt_probe 2>/dev/null; then
            
            PROP=""
            [ -f /tmp/mnt_probe/system/build.prop ] && PROP="/tmp/mnt_probe/system/build.prop"
            [ -f /tmp/mnt_probe/build.prop ] && PROP="/tmp/mnt_probe/build.prop"
            [ -f /tmp/mnt_probe/system/etc/build.prop ] && PROP="/tmp/mnt_probe/system/etc/build.prop"

            if [ -n "$PROP" ]; then
                OS_VER=$(grep "ro.build.version.release=" "$PROP" | head -n 1 | cut -d'=' -f2)
                PATCH=$(grep "ro.build.version.security_patch=" "$PROP" | head -n 1 | cut -d'=' -f2)
                SDK=$(grep "ro.build.version.sdk=" "$PROP" | head -n 1 | cut -d'=' -f2)
                FP=$(grep "ro.build.fingerprint=" "$PROP" | head -n 1 | cut -d'=' -f2)

                log_msg "Probed ROM properties from $PROP: OS=$OS_VER, Patch=$PATCH, SDK=$SDK"
                
                [ -n "$OS_VER" ] && resetprop -n ro.build.version.release "$OS_VER"
                [ -n "$OS_VER" ] && resetprop -n ro.build.version.release_or_codename "$OS_VER"
                [ -n "$OS_VER" ] && resetprop -n ro.vendor.build.version.release "$OS_VER"
                [ -n "$OS_VER" ] && resetprop -n ro.system.build.version.release "$OS_VER"
                [ -n "$PATCH" ] && resetprop -n ro.build.version.security_patch "$PATCH"
                [ -n "$PATCH" ] && resetprop -n ro.vendor.build.security_patch "$PATCH"
                [ -n "$SDK" ] && resetprop -n ro.build.version.sdk "$SDK"
                [ -n "$SDK" ] && resetprop -n ro.vendor.build.version.sdk "$SDK"
                [ -n "$SDK" ] && resetprop -n ro.system.build.version.sdk "$SDK"
                [ -n "$FP" ] && resetprop -n ro.build.fingerprint "$FP"
                
                PROBE_SUCCESS=1
            fi
            umount /tmp/mnt_probe 2>/dev/null
            [ $PROBE_SUCCESS -eq 1 ] && break
        fi
    fi
done
rm -rf /tmp/mnt_probe 2>/dev/null

# Fallback defaults if probing from raw image was not immediately ready
if [ $PROBE_SUCCESS -eq 0 ]; then
    log_msg "Direct super probe not ready at early init, using safe fallback defaults"
    [ -z "$(getprop ro.build.version.release)" ] && resetprop -n ro.build.version.release "13"
    [ -z "$(getprop ro.build.version.release_or_codename)" ] && resetprop -n ro.build.version.release_or_codename "13"
    [ -z "$(getprop ro.build.version.security_patch)" ] && resetprop -n ro.build.version.security_patch "2025-10-01"
    [ -z "$(getprop ro.vendor.build.security_patch)" ] && resetprop -n ro.vendor.build.security_patch "2025-10-01"
    [ -z "$(getprop ro.build.version.sdk)" ] && resetprop -n ro.build.version.sdk "33"
fi

# 3. Device Identity (using resetprop -n to prevent read-only 0xb error)
resetprop -n ro.product.name "tornado"
resetprop -n ro.product.device "tornado"
resetprop -n ro.product.board "tornado"
resetprop -n ro.product.model "REDMI 15C 5G"
resetprop -n ro.product.brand "Redmi"
resetprop -n ro.product.manufacturer "Xiaomi"
resetprop -n ro.vendor.mtk_mitee_support 1
resetprop -n ro.vendor.mtk_microtrust_tee_support 1
resetprop -n ro.vendor.mtk_tee_gp_support 1
resetprop -n ro.hardware.kmsetkey "mitee"
resetprop -n ro.hardware.gatekeeper "mitee"

# 4. Keystore staging directories with system permissions
mkdir -p /tmp/misc/keystore /tmp/keystore
chown -R system:system /tmp/misc /tmp/keystore 2>/dev/null
chmod -R 0775 /tmp/misc /tmp/keystore 2>/dev/null

# 5. Fix Block Device Paths
log_msg "Fixing block device paths..."
mkdir -p /dev/block/platform/bootdevice/by-name/ 2>/dev/null
chcon u:object_r:block_device:s0 /dev/block/platform/bootdevice/by-name/ 2>/dev/null

for part in preloader_raw_a preloader_raw_b; do
    if [ ! -L /dev/block/platform/bootdevice/by-name/$part ] && [ -e /dev/block/by-name/$part ]; then
        ln -s /dev/block/by-name/$part /dev/block/platform/bootdevice/by-name/$part 2>/dev/null
    fi
done

# 6. VINTF patching (Version 4.0 compatibility)
log_msg "Applying VINTF overrides..."
if [ -d /vendor/etc/vintf ]; then
    mkdir -p /tmp/vintf
    cp -rf /vendor/etc/vintf/* /tmp/vintf/ 2>/dev/null
    find /tmp/vintf -type f -name "*.xml" -exec sed -i 's/version="5.0"/version="4.0"/g' {} + 2>/dev/null
    chmod -R 755 /tmp/vintf 2>/dev/null
    chown -R system:system /tmp/vintf 2>/dev/null
    mount -o bind /tmp/vintf /vendor/etc/vintf 2>/dev/null
fi

# 7. Service Handshake: Start TEE services, then KeyMint and Gatekeeper
log_msg "Starting TEE & Security HAL services..."
stop keystore2 2>/dev/null
setprop twrp.vintf.ready 1
start tee-supplicant
start keymint-mitee
start gatekeeper-1-0

# 8. Wait for keymint AIDL to register before starting keystore2
log_msg "Waiting for keymint AIDL registration..."
WAIT=0
while [ $WAIT -lt 20 ]; do
    if service list 2>/dev/null | grep -q "IKeyMintDevice"; then
        log_msg "keymint AIDL registered after ${WAIT}s"
        break
    fi
    sleep 1
    WAIT=$((WAIT + 1))
done

# Ensure keystore directory ownership before starting keystore2
mkdir -p /tmp/misc/keystore
chown -R system:system /tmp/misc 2>/dev/null
chmod -R 0775 /tmp/misc 2>/dev/null

log_msg "Starting keystore2..."
start keystore2

# 9. Diagnostics
log_msg "--- DIAGNOSTICS ---"
getprop | grep -E 'init.svc.(tee|keystore|keymint|gatekeeper)|twrp|vintf|vold'

log_msg "--- TWRP DEBUG BOOT SYNC END (Loop continuing in background) ---"

# 10. Persistence and monitoring loop
while true; do
    # Check if system was mounted by recovery and update props if needed
    for propfile in \
        /system_root/system/build.prop \
        /system_root/system/etc/build.prop \
        /system/build.prop \
        /system/etc/build.prop; do
        if [ -f "$propfile" ] && [ $PROBE_SUCCESS -eq 0 ]; then
            OS_VER=$(grep "ro.build.version.release=" "$propfile" | head -n 1 | cut -d'=' -f2)
            PATCH=$(grep "ro.build.version.security_patch=" "$propfile" | head -n 1 | cut -d'=' -f2)
            SDK=$(grep "ro.build.version.sdk=" "$propfile" | head -n 1 | cut -d'=' -f2)
            FP=$(grep "ro.build.fingerprint=" "$propfile" | head -n 1 | cut -d'=' -f2)
            
            [ -n "$OS_VER" ] && resetprop -n ro.build.version.release "$OS_VER"
            [ -n "$OS_VER" ] && resetprop -n ro.build.version.release_or_codename "$OS_VER"
            [ -n "$OS_VER" ] && resetprop -n ro.vendor.build.version.release "$OS_VER"
            [ -n "$OS_VER" ] && resetprop -n ro.system.build.version.release "$OS_VER"
            [ -n "$PATCH" ] && resetprop -n ro.build.version.security_patch "$PATCH"
            [ -n "$PATCH" ] && resetprop -n ro.vendor.build.security_patch "$PATCH"
            [ -n "$SDK" ] && resetprop -n ro.build.version.sdk "$SDK"
            [ -n "$FP" ] && resetprop -n ro.build.fingerprint "$FP"
            PROBE_SUCCESS=1
        fi
    done

    # Keep services running
    STATUS=$(getprop init.svc.keymint-mitee)
    [ "$STATUS" != "running" ] && start keymint-mitee
    
    STATUS=$(getprop init.svc.gatekeeper-1-0)
    [ "$STATUS" != "running" ] && start gatekeeper-1-0

    K_STATUS=$(getprop init.svc.keystore2)
    if [ "$K_STATUS" != "running" ] && service list 2>/dev/null | grep -q "IKeyMintDevice"; then
        start keystore2
    fi

    setenforce 0 2>/dev/null
    sleep 15
done
