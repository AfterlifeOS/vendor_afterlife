$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit full common afterlife stuff
$(call inherit-product, vendor/afterlife/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include afterlife LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/afterlife/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/afterlife/overlay/dictionaries

$(call inherit-product, vendor/afterlife/config/telephony.mk)
