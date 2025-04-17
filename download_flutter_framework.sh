#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define output directory
OUTPUT_DIR="$SCRIPT_DIR/AnwalPaySDKNativeiOSExample/amwalsdk/Flutter"
FLUTTER_FRAMEWORK_PATH="/Users/builder/programs/flutter/bin/cache/artifacts/engine/ios/Flutter.xcframework"

flutter precache --force --ios --verbose.

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Copy Flutter.xcframework to OUTPUT_DIR
cd "$OUTPUT_DIR"
if cp -R "$FLUTTER_FRAMEWORK_PATH" .; then
    echo "Successfully copied Flutter.xcframework"
else
    echo "Error: Failed to copy Flutter.xcframework"
    exit 1
fi

cd "$SCRIPT_DIR" 