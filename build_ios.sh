#!/bin/bash

# Exit script if any command fails
set -e

# Define variables
CURRENT_DIR=$(pwd)
OUTPUT_DIR="../AnwalPaySDKNativeiOSExample/amwalsdk"
PODSPEC_PATH="../AnwalPaySDKNativeiOSExample/amwalsdk/amwalsdk.podspec"

# Check if the script is run from the correct directory
EXPECTED_DIR_NAME="amwal_sdk_flutter_module"
if [[ "$(basename "$CURRENT_DIR")" != "$EXPECTED_DIR_NAME" ]]; then
    echo "Error: Please run this script from the $EXPECTED_DIR_NAME directory."
    exit 1
fi

# Step 1: Clean the Flutter project
echo "Cleaning previous builds..."
flutter clean

# Step 2: Get dependencies
echo "Getting dependencies..."
flutter pub get

# Step 3: Build the iOS framework in release mode
echo "Building Flutter iOS framework in release mode..."
flutter build ios-framework --no-debug --no-profile --release --output="$OUTPUT_DIR"
echo "Build completed successfully. Frameworks are available in $OUTPUT_DIR"

# Step 4: Validate the podspec file
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Running pod lib lint on $PODSPEC_PATH..."
    pod lib lint "$PODSPEC_PATH"
    echo "Podspec validation completed successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi
