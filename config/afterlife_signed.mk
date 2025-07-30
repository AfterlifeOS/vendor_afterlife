#
# Copyright (C) 2023-2025 AfterLifeOS
#
# SPDX-License-Identifier: Apache-2.0
#

OFFICIAL_MAINTAINER = $(shell cat vendor/afterlife/signed/signed.mk | awk '{ print $$1 }')

ifndef AFTERLIFE_BUILD_TYPE
    AFTERLIFE_BUILD_TYPE := COMMUNITY
endif

ifdef AFTERLIFE_MAINTAINER
    ifeq ($(filter $(AFTERLIFE_MAINTAINER), $(OFFICIAL_MAINTAINER)), $(AFTERLIFE_MAINTAINER))
        $(warning "Lify: $(AFTERLIFE_MAINTAINER) is verified as official maintainer, build as official build.")
        AFTERLIFE_BUILD_TYPE = OFFICIAL
    else
        $(warning "Lify: Unofficial maintainer detected, building as community build.")
    endif
    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
        ro.afterlife.maintainer=$(AFTERLIFE_MAINTAINER)
else
    $(warning "Lify: No maintainer name detected, building as community build.")
endif