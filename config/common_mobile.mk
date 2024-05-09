# Inherit common mobile AfterLife stuff
$(call inherit-product, vendor/afterlife/config/common.mk)

# Include AOSP audio files
include vendor/afterlife/config/aosp_audio.mk

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_LINEAGE_CHARGER),false)
PRODUCT_PACKAGES += \
    lineage_charger_animation \
    lineage_charger_animation_vendor
endif

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true
