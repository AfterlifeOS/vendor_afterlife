#
# Copyright (C) 2023 AfterLife
#
# SPDX-License-Identifier: Apache-2.0
#

OFFICIAL_MAINTAINER = $(shell cat vendor/afterlife/signed/signed.mk | awk '{ print $$1 }')

ifndef AFTERLIFE_BUILD_TYPE
    AFTERLIFE_BUILD_TYPE := COMMUNITY
endif

ifdef AFTERLIFE_MAINTAINER
    ifeq ($(filter $(AFTERLIFE_MAINTAINER), $(OFFICIAL_MAINTAINER)), $(AFTERLIFE_MAINTAINER))
        $(warning "afterlife: $(AFTERLIFE_MAINTAINER) is verified as official maintainer, build as official build.")
        AFTERLIFE_BUILD_TYPE = OFFICIAL

        PRODUCT_PACKAGES += \
            Updater

        PRODUCT_COPY_FILES += \
            vendor/afterlife/prebuilt/common/etc/init/init.afterlife-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.afterlife-updater.rc
    else
        $(warning "afterlife: Unofficial maintainer detected, building as unofficial build.")
    endif
    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
        ro.afterlife.maintainer=$(AFTERLIFE_MAINTAINER)
else
    $(warning "afterlife: No maintainer name detected, building as unofficial build.")
endif
