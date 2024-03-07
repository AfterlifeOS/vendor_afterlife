# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2023 The AfterLife Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------
# AfterLife OTA update package

AFTERLIFE_TARGET_PACKAGE := $(PRODUCT_OUT)/AfterLife-$(AFTERLIFE_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: afterlife
afterlife: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(AFTERLIFE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(AFTERLIFE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(AFTERLIFE_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/afterlife/build/tools/generate_json.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(AFTERLIFE_TARGET_PACKAGE)
	@echo "Done"
	@echo -e "\t ===============================-Package complete-========================================="
	@echo -e "\t Zip: $(AFTERLIFE_TARGET_PACKAGE)"
	@echo -e "\t Size: `du -sh $(AFTERLIFE_TARGET_PACKAGE) | awk '{print $$1}' `"
	@echo -e "\t AfterLife | #NeverDie"
	@echo -e "\t =========================================================================================="
