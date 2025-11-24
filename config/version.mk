PRODUCT_VERSION_MAJOR = 8
PRODUCT_VERSION_MINOR = 2

# versioning
AFTERLIFE_CODENAME := Serenity
AFTERLIFE_VERSION_EXTRA := Baklava

ifeq ($(AFTERLIFE_VERSION_APPEND_TIME_OF_DAY),true)
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

ifndef AFTERLIFE_GAPPS
    AFTERLIFE_GAPPS := false
endif

ifeq ($(AFTERLIFE_GAPPS),false)
    AFTERLIFE_ZIP_TYPE := Vanilla
else ifeq ($(AFTERLIFE_GAPPS),core)
    AFTERLIFE_ZIP_TYPE := CoreGApps
    GAPPS_CORE := true
    WITH_GMS := true
    $(call inherit-product-if-exists, vendor/gms/gms.mk)
else ifeq ($(AFTERLIFE_GAPPS),basic)
    AFTERLIFE_ZIP_TYPE := BasicGApps
    GAPPS_BASIC := true
    WITH_GMS := true
    $(call inherit-product-if-exists, vendor/gms/gms.mk)
else ifeq ($(AFTERLIFE_GAPPS),true)
    AFTERLIFE_ZIP_TYPE := GApps
    GAPPS_FULL := true
    WITH_GMS := true
    $(call inherit-product-if-exists, vendor/gms/gms.mk)
else
    $(error AFTERLIFE_GAPPS set to invalid value: "$(AFTERLIFE_GAPPS)". Supported values: core, basic, true, false)
endif

AFTERLIFE_VERSION_SUFFIX := $(AFTERLIFE_BUILD_TYPE)_$(AFTERLIFE_BUILD_DATE)

# Internal version
AFTERLIFE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(AFTERLIFE_CODENAME)-$(AFTERLIFE_VERSION_SUFFIX)-$(AFTERLIFE_ZIP_TYPE)

# Display version
AFTERLIFE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AFTERLIFE_VERSION_SUFFIX)

# Codename version
AFTERLIFE_DISPLAY_VERSION_CODENAME := 16.0 | $(AFTERLIFE_CODENAME)

# AfterLife System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.afterlife.version=$(AFTERLIFE_VERSION) \
    ro.afterlife.releasetype=$(AFTERLIFE_BUILD_TYPE) \
    ro.afterlife.releasevarient=$(AFTERLIFE_ZIP_TYPE) \
    ro.afterlife.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.afterlife.version.codename=$(AFTERLIFE_CODENAME) \
    ro.afterlife.version.extra=$(AFTERLIFE_VERSION_EXTRA)
