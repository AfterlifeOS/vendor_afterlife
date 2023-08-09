# Inherit common mobile afterlife stuff
$(call inherit-product, vendor/afterlife/config/common.mk)

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

