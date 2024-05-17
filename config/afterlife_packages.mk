#
# Copyright (C) 2023 AfterLife
#
# SPDX-License-Identifier: Apache-2.0
#

# Apps
PRODUCT_PACKAGES += \
    AfterHome \
    Aperture \
    Etar \
    ExactCalculator \
    Glimpse \
    LatinIME \
    OmniJaws \
    Recorder

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Extra tools in AfterLife
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# rsync
PRODUCT_PACKAGES += \
    rsync

# SetupWizard
PRODUCT_PACKAGES += \
    NetworkStackOverlay

# Themepicker
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub
