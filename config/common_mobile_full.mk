# Inherit common Afterlife stuff
$(call inherit-product, vendor/afterlife/config/common_mobile.mk)

PRODUCT_SIZE := full

ifneq ($(PRODUCT_NO_CAMERA),true)
PRODUCT_PACKAGES += \
    Aperture
endif

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd

# Include Afterlife LatinIME dictionaries
 PRODUCT_PACKAGE_OVERLAYS += vendor/afterlife/overlay/dictionaries
 PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/afterlife/overlay/dictionaries
