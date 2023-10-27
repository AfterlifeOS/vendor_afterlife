# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= AfterLife

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Gapps
AFTERLIFE_ZIP_TYPE := Vanilla
ifeq ($(AFTERLIFE_GAPPS), true)
    $(call inherit-product, vendor/gms/products/gms.mk)
ifeq ($(AFTERLIFE_CORE), true)
    AFTERLIFE_ZIP_TYPE := CoreGApps
else
    AFTERLIFE_ZIP_TYPE := Gapps
endif
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=false

# Audio
$(call inherit-product, vendor/afterlife/audio/audio.mk)

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/afterlife/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/afterlife/prebuilt/common/bin/50-afterlife.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-afterlife.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-afterlife.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/afterlife/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/afterlife/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# AfterLife-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/etc/init/init.afterlife-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.afterlife-system_ext.rc

# Blurs
ifeq ($(TARGET_SUPPORTS_BLUR),true)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

# Disable blur on app-launch
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0

# App lock permission
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(AFTERLIFE_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# GMS Permissions
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-gms.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-gms.xml

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/afterlife/overlay/common

PRODUCT_PACKAGES += \
    NetworkStackOverlay \
    TrebuchetOverlay

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/afterlife/build/target/product/security/afterlife

# Themepicker
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub

# Themes
$(call inherit-product, vendor/afterlife/config/themes.mk)

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Sounds (default)
PRODUCT_PROPERTY_OVERRIDES := \
    ro.config.ringtone=NewSongette.ogg \
    ro.config.notification_sound=no-pro.ogg \
    ro.config.alarm_alert=frenzy.ogg

# Bootanimation
include vendor/afterlife/config/bootanimation.mk

# Telephony
include vendor/afterlife/config/telephony.mk

# Signing
include vendor/afterlife/config/signed.mk

# Versioning
include vendor/afterlife/config/version.mk

# Charging animation
include vendor/afterlife/config/charger.mk

# ParallelSpace
PRODUCT_PACKAGES += \
    ParallelSpace

# Aperture
PRODUCT_PACKAGES += \
    Aperture \
    OmniJaws

# TouchGestures
TARGET_SUPPORTS_TOUCHGESTURES ?= false
ifeq ($(TARGET_SUPPORTS_TOUCHGESTURES),true)
PRODUCT_PACKAGES += \
    TouchGestures \
    TouchGesturesSettingsOverlay
endif

# Immersive Navigation
PRODUCT_PACKAGES += \
    ImmersiveNavigationOverlay

# Vanilla
ifneq ($(AFTERLIFE_GAPPS), true)
PRODUCT_PACKAGES += \
    ExactCalculator
endif
