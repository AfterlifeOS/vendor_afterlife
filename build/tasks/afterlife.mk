#
# Copyright (C) 2023 AfterLife
#
# SPDX-License-Identifier: Apache-2.0
#

AFTERLIFE_TARGET_PACKAGE := $(PRODUCT_OUT)/$(AFTERLIFE_VERSION).zip

.PHONY: afterlife
afterlife: $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(AFTERLIFE_TARGET_PACKAGE)
	@echo "Done"
	@echo -e "\t ===============================-Package complete-========================================="
	@echo -e "\t Zip: $(AFTERLIFE_TARGET_PACKAGE)"
	@echo -e "\t Size: `du -sh $(AFTERLIFE_TARGET_PACKAGE) | awk '{print $$1}' `"
	@echo -e "\t afterlife | #NeverDie"
	@echo -e "\t =========================================================================================="
