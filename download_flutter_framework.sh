#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define output directory
OUTPUT_DIR="$SCRIPT_DIR/AnwalPaySDKNativeiOSExample/amwalsdk/Flutter"
FLUTTER_ZIP_URL="https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/v1.0.75/Flutter.xcframework.zip"

# Create output directory and Debug/Release subdirectories if they don't exist
mkdir -p "$OUTPUT_DIR/Debug"
mkdir -p "$OUTPUT_DIR/Release"

# Download and extract directly to OUTPUT_DIR
cd "$OUTPUT_DIR"
if curl -L -f "$FLUTTER_ZIP_URL" -o "Flutter.xcframework.zip"; then
    echo "Successfully downloaded Flutter.xcframework.zip"
    if unzip -o -q "Flutter.xcframework.zip"; then
        echo "Successfully extracted Flutter.xcframework.zip"
        # Move the framework to both Debug and Release directories

        rm -rf "__MACOSX" 2>/dev/null || true
        echo "Successfully moved Flutter.xcframework to Debug and Release directories"
    else
        echo "Warning: Failed to extract Flutter.xcframework.zip"
        rm -f "Flutter.xcframework.zip"
    fi
else
    echo "Warning: Failed to download Flutter.xcframework.zip"
fi

cd "$SCRIPT_DIR" 