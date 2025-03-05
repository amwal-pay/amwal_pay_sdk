#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define directories and paths
PROJECT_ROOT="$SCRIPT_DIR"
MODULE_DIR="$PROJECT_ROOT/amwal_sdk_flutter_module"
OUTPUT_DIR="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk/Flutter"
PODSPEC_PATH="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk.podspec"

# Step 1: Navigate to the Flutter module directory
if [[ -d "$MODULE_DIR" ]]; then
    echo "Navigating to $MODULE_DIR..."
    cd "$MODULE_DIR"
else
    echo "Error: Directory $MODULE_DIR does not exist."
    exit 1
fi

# Step 2: Clean the Flutter project
echo "Cleaning previous builds..."
flutter clean

# Step 3: Get dependencies
echo "Getting dependencies..."
flutter pub get

# Step 4: Build the iOS framework in release mode
echo "Building Flutter iOS framework in release mode..."
flutter build ios-framework --no-debug --no-profile --release --output="$OUTPUT_DIR"

# Step 5: Move frameworks out of the Release folder (if it exists)
RELEASE_DIR="$OUTPUT_DIR/Release"
if [[ -d "$RELEASE_DIR" ]]; then
    echo "Moving frameworks from $RELEASE_DIR to $OUTPUT_DIR..."
    mv "$RELEASE_DIR/"* "$OUTPUT_DIR/"
    rm -r "$RELEASE_DIR"
    echo "Frameworks moved successfully."
else
    echo "Frameworks are already in the desired directory."
fi

# Step 6: Navigate back to the project root
cd "$PROJECT_ROOT"

# Step 7: Validate the podspec file
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Running pod lib lint on $PODSPEC_PATH..."
    pod lib lint "$PODSPEC_PATH"
    echo "Podspec validation completed successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi
