$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit full common AfterLife stuff
$(call inherit-product, vendor/afterlife/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include AfterLife LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/afterlife/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/afterlife/overlay/dictionaries

# Settings
PRODUCT_PRODUCT_PROPERTIES += \
    persist.settings.large_screen_opt.enabled=true
