#!/bin/bash
#
# Copyright (C) 2019-2023 crDroid Android Project
# Copyright (C) 2024 AfterlifeOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# $1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=FILE_NAME
TARGET_DEVICE=$1
PRODUCT_OUT=$2
FILE_NAME=$3

# Input: Existing Master JSON in Source Tree (Optional, for merging)
OTA_JSON_PATH="./device/afterlife/ota/$TARGET_DEVICE/updates.json"
# Output: Result JSON in Product Out (For Jenkins artifact/upload)
OUTPUT_JSON_PATH="$PRODUCT_OUT/$TARGET_DEVICE.json"

PYTHON_GENERATOR="./vendor/afterlife/tools/ota_json_generator.py"

echo "Generating JSON file data for OTA support..."

# Extract Build Info
VERSION=$(echo "$FILE_NAME" | cut -d '-' -f 2 | cut -d 'V' -f 2)
# Parsing variant: Assuming format ...-date-variant.zip
VARIANT=$(echo "$FILE_NAME" | sed 's/.zip//' | awk -F'-' '{print $NF}')

# Fallback if variant detection fails or is empty
if [[ "$FILE_NAME" == *"gapps"* ]]; then
    if [[ "$FILE_NAME" == *"coregapps"* ]]; then
        VARIANT="coregapps"
    elif [[ "$FILE_NAME" == *"basicgapps"* ]]; then
        VARIANT="basicgapps"
    else
        VARIANT="gapps"
    fi
elif [[ "$FILE_NAME" == *"vanilla"* ]]; then
    VARIANT="vanilla"
fi

BUILD_PROP="$PRODUCT_OUT/system/build.prop"

# Get Timestamp (Simplified)
TIMESTAMP=$(grep "^ro.system.build.date.utc=" "$BUILD_PROP" | cut -d'=' -f2)

# Get Maintainer from Build Prop (Priority 1 - Simplified)
MAINTAINER=$(grep "^ro.afterlife.maintainer=" "$BUILD_PROP" | cut -d'=' -f2)

# Get ROM Codename from Build Prop (e.g. serenity)
ROM_CODENAME=$(grep "^ro.afterlife.version.codename=" "$BUILD_PROP" | cut -d'=' -f2)

# Get Build Type
BUILD_TYPE=$(grep "^ro.afterlife.releasetype=" "$BUILD_PROP" | cut -d'=' -f2)

# Calculate Checksums and Size
MD5=$(md5sum "$PRODUCT_OUT/$FILE_NAME" | cut -d' ' -f1)
SHA256=$(sha256sum "$PRODUCT_OUT/$FILE_NAME" | cut -d' ' -f1)
SIZE=$(stat -c "%s" "$PRODUCT_OUT/$FILE_NAME")

# Meta Info
OEM=""
FORUM=""
TELEGRAM=""

# Priority 2: Grep from existing JSON (if available & maintainer still empty)
if [ -f "$OTA_JSON_PATH" ]; then
    echo "  Input JSON: $OTA_JSON_PATH (Found)" 
    
    if [ -z "$MAINTAINER" ]; then
        MAINTAINER=$(grep -n "\"maintainer\"" $OTA_JSON_PATH | head -n 1 | cut -d ":" -f 3 | sed 's/"//g' | sed 's/,//g' | xargs)
    fi
    
    OEM=$(grep -n "\"oem\"" $OTA_JSON_PATH | head -n 1 | cut -d ":" -f 3 | sed 's/"//g' | sed 's/,//g' | xargs)
    FORUM=$(grep -n "\"forum\"" $OTA_JSON_PATH | head -n 1 | cut -d ":" -f 4- | sed 's/"//g' | sed 's/,//g' | xargs)
    TELEGRAM=$(grep -n "\"telegram\"" $OTA_JSON_PATH | head -n 1 | cut -d ":" -f 4- | sed 's/"//g' | sed 's/,//g' | xargs)
else
    echo "  Input JSON: $OTA_JSON_PATH (Not Found - Will Create New)"
fi

# Priority 3: Default Fallbacks
if [ -z "$MAINTAINER" ]; then MAINTAINER="Unknown Maintainer"; fi
if [ -z "$OEM" ]; then OEM="AfterlifeOS"; fi
if [ -z "$FORUM" ]; then FORUM="https://t.me/AfterLifeOS"; fi
if [ -z "$TELEGRAM" ]; then TELEGRAM="https://t.me/Afterlife_update"; fi
if [ -z "$ROM_CODENAME" ]; then ROM_CODENAME="Unknown"; fi
if [ -z "$BUILD_TYPE" ]; then BUILD_TYPE="Community"; fi

# Fix URL parsing
if [[ $FORUM != http* ]]; then FORUM="https:$FORUM"; fi
if [[ $TELEGRAM != http* ]]; then TELEGRAM="https:$TELEGRAM"; fi

UNIFIED_URL="https://afterlifeos.com/download/?search=$TARGET_DEVICE"

echo "  Device: $TARGET_DEVICE"
echo "  ROM Codename: $ROM_CODENAME"
echo "  Variant: $VARIANT"
echo "  Version: $VERSION"
echo "  Maintainer: $MAINTAINER"
echo "  Build Type: $BUILD_TYPE"
echo "  Output JSON: $OUTPUT_JSON_PATH"

# Call Python Generator
python3 "$PYTHON_GENERATOR" \
    --json_path "$OTA_JSON_PATH" \
    --output_path "$OUTPUT_JSON_PATH" \
    --device "$TARGET_DEVICE" \
    --rom_codename "$ROM_CODENAME" \
    --maintainer "$MAINTAINER" \
    --oem "$OEM" \
    --version "$VERSION" \
    --buildtype "$BUILD_TYPE" \
    --variant "$VARIANT" \
    --filename "$FILE_NAME" \
    --download_url "$UNIFIED_URL" \
    --timestamp "$TIMESTAMP" \
    --md5 "$MD5" \
    --sha256 "$SHA256" \
    --size "$SIZE" \
    --forum "$FORUM" \
    --telegram "$TELEGRAM"

echo "Done."