# Inherit full common AfterLife stuff
$(call inherit-product, vendor/afterlife/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include AfterLife LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/afterlife/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/afterlife/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/afterlife/config/telephony.mk)
