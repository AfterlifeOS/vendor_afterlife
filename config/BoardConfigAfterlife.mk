include vendor/afterlife/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/afterlife/config/BoardConfigQcom.mk
endif

include vendor/afterlife/config/BoardConfigSoong.mk
