PRODUCT_VERSION_MAJOR = 8
PRODUCT_VERSION_MINOR = 5

# versioning
AFTERLIFE_CODENAME := Piece
AFTERLIFE_VERSION_EXTRA := Baklava

ifeq ($(AFTERLIFE_VERSION_APPEND_TIME_OF_DAY),true)
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

ifndef AFTERLIFE_GAPPS
    AFTERLIFE_GAPPS := false
endif

ifeq ($(AFTERLIFE_GAPPS),true)
    AFTERLIFE_ZIP_TYPE := GApps
    WITH_GMS := true
else
    AFTERLIFE_ZIP_TYPE := Vanilla
endif

ifeq ($(WITH_GMS),true)
    $(call inherit-product-if-exists, vendor/gms/products/gms.mk)
endif

AFTERLIFE_VERSION_SUFFIX := $(AFTERLIFE_BUILD_TYPE)_$(AFTERLIFE_BUILD_DATE)

# Internal version
AFTERLIFE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(AFTERLIFE_CODENAME)-$(AFTERLIFE_VERSION_SUFFIX)-$(AFTERLIFE_ZIP_TYPE)

# Display version
AFTERLIFE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AFTERLIFE_VERSION_SUFFIX)

# Codename version
AFTERLIFE_DISPLAY_VERSION_CODENAME := 16.2 | $(AFTERLIFE_CODENAME)

# AfterLife System Version
PRODUCT_PRODUCT_PROPERTIES += \
    ro.afterlife.version=$(AFTERLIFE_VERSION) \
    ro.afterlife.releasetype=$(AFTERLIFE_BUILD_TYPE) \
    ro.afterlife.releasevarient=$(AFTERLIFE_ZIP_TYPE) \
    ro.afterlife.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.afterlife.version.codename=$(AFTERLIFE_CODENAME) \
    ro.afterlife.version.extra=$(AFTERLIFE_VERSION_EXTRA)

# Features
PERF_ANIM_OVERRIDE ?= false

# Features Properties
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.activity_anim_perf_override=$(PERF_ANIM_OVERRIDE)
