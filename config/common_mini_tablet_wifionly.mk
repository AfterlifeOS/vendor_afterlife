# Inherit mini common afterlife stuff
$(call inherit-product, vendor/afterlife/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
