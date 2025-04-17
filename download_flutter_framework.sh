#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define output directory
OUTPUT_DIR="$SCRIPT_DIR/AnwalPaySDKNativeiOSExample/amwalsdk/Flutter"
FLUTTER_ZIP_URL="https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/v1.0.75/Flutter.xcframework.zip"

flutter precache --force --ios --verbose.

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Download and extract directly to OUTPUT_DIR
cd "$OUTPUT_DIR"
if curl -L -f "$FLUTTER_ZIP_URL" -o "Flutter.xcframework.zip"; then
    echo "Successfully downloaded Flutter.xcframework.zip"
    if unzip -o -q "Flutter.xcframework.zip"; then
        echo "Successfully extracted Flutter.xcframework.zip"
        rm -f "Flutter.xcframework.zip"
        rm -rf "__MACOSX" 2>/dev/null || true
    else
        echo "Warning: Failed to extract Flutter.xcframework.zip"
        rm -f "Flutter.xcframework.zip"
    fi
else
    echo "Warning: Failed to download Flutter.xcframework.zip"
fi

cd "$SCRIPT_DIR" 