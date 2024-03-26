# Inherit common mobile afterlife stuff
$(call inherit-product, vendor/afterlife/config/common.mk)

# Include AOSP audio files
include vendor/afterlife/config/aosp_audio.mk

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true
