# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

# Audio
$(call inherit-product, vendor/afterlife/audio/Afterlife_audio.mk)

# Bootanimation
$(call inherit-product, vendor/afterlife/config/Afterlife_bootanimation.mk)

# Certification
$(call inherit-product-if-exists, vendor/certification/config.mk)

# Allow vendor prebuilt repos to exclude themselves from bp scanning
-include $(sort $(wildcard vendor/*/*/exclude-bp.mk))

PRODUCT_BRAND ?= AfterlifeOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Additional Packages
include vendor/extras/afterlife.mk

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
ifdef WITH_ADB_INSECURE
# Forcebly disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Set ro.debuggable=0 for userdebug
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := true
endif

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/afterlife/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions

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

# Afterlife-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/etc/init/init.afterlife-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.afterlife-system_ext.rc

# Blur effect
TARGET_ENABLE_BLUR ?= false
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=true
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=false
endif

PRODUCT_SYSTEM_PROPERTIES += ro.surface_flinger.supports_background_blur=1

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# ColumbusService
ifneq ($(TARGET_SUPPORTS_QUICK_TAP),false)
PRODUCT_PACKAGES += \
    ColumbusService
endif

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable userdata image build
PRODUCT_BUILD_USERDATA_IMAGE := false

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true
    
# Extra tools in Afterlife
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_PACKAGES += \
    nano_recovery

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap \
    system/%/libzstd.so


# FaceUnlock
ifneq ($(TARGET_FACE_UNLOCK_SUPPORTED),false)
ifeq ($(TARGET_SUPPORTS_GFU),true)
$(call inherit-product-if-exists, vendor/google/faceunlock/config.mk)
else
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif
endif

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

# FRP
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/wipe-frp.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wipe-frp

# Gamespace
#PRODUCT_PACKAGES += \
#   GameSpace

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Omni
#PRODUCT_PACKAGES += \
#   OmniStyle \
#   OmniJaws

# LMOFreeform
#PRODUCT_PACKAGES += \
#   LMOFreeform \
#   LMOFreeformSidebar

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

# Overlay
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.google.android.systemui.gxoverlay_gms

# Packages
PRODUCT_PACKAGES += \
    Launcher3QuickStep \
    ThemePicker \
    ThemesStub

# Permissions
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml \
    vendor/afterlife/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# Lineage Health
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Lineage-specific file
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# rsync
PRODUCT_PACKAGES += \
    rsync

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Sound default
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Good_day.ogg \
    ro.config.notification_sound=Stalk.ogg \
    ro.config.alarm_alert=frenzy.ogg

# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

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

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    AfterHomeQuickStep

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    debug.sf.enable_transaction_tracing=false
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/afterlife/overlay/no-rro
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/afterlife/overlay/common \
    vendor/afterlife/overlay/no-rro

PRODUCT_PACKAGES += \
    AndroidBlackThemeOverlay \
    CustomFontPixelLauncherOverlay \
    DocumentsUIOverlay \
    NetworkStackOverlay \
    PermissionControllerOverlay \
    SettingsOverlay

# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT

#signed
include vendor/afterlife/config/afterlife_signed.mk

include vendor/afterlife/config/version.mk

# Fonts
include vendor/afterlife/config/fonts.mk

# Signing
ifeq ($(AFTERLIFE_BUILD_TYPE),OFFICIAL)
$(warning "Lify: Enable private keys for sign build.")
include vendor/afterlife-priv/keys/keys.mk
else
$(warning "Lify: Disable private keys for sign build. you need to generate private keys manually.")
-include vendor/afterlife-priv/keys/keys.mk
endif
