PRODUCT_VERSION_MAJOR = 2
PRODUCT_VERSION_MINOR = 0

ifeq ($(AFTERLIFE_VERSION_APPEND_TIME_OF_DAY),true)
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# versioning
AFTERLIFE_CODENAME := Sinners
AFTERLIFE_BUILD_TYPE ?= UNOFFICIAL

# Check Official
ifndef AFTERLIFE_BUILD_TYPE
    AFTERLIFE_BUILD_TYPE := UNOFFICIAL
endif

AFTERLIFE_VERSION_SUFFIX := $(AFTERLIFE_BUILD_TYPE)-$(AFTERLIFE_BUILD)-$(AFTERLIFE_BUILD_DATE)

# Internal version
AFTERLIFE_VERSION := $(AFTERLIFE_CODENAME)-$(AFTERLIFE_VERSION_SUFFIX)

# Display version
AFTERLIFE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AFTERLIFE_VERSION_SUFFIX)

# Codename version
AFTERLIFE_DISPLAY_VERSION_CODENAME := 13.1

# Props
PRODUCT_GENERIC_PROPERTIES += \
  ro.afterlife.version=$(AFTERLIFE_DISPLAY_VERSION_CODENAME) \
  ro.afterlife.releasevarient=$(AFTERLIFE_ZIP_TYPE) \
  ro.afterlife.releasetype=$(AFTERLIFE_BUILD_TYPE) \
  ro.afterlife.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
