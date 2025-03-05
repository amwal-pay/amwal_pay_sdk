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
PUBSPEC_PATH="$PROJECT_ROOT/pubspec.yaml"
IOS_DIR="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample"

# Step 1: Navigate to the Flutter module directory
if [[ -d "$MODULE_DIR" ]]; then
    echo "Navigating to $MODULE_DIR..."
    cd "$MODULE_DIR"
else
    echo "Error: Directory $MODULE_DIR does not exist."
    exit 1
fi

# Step 2: Extract the version from pubspec.yaml
if [[ -f "$PUBSPEC_PATH" ]]; then
    echo "Extracting version from $PUBSPEC_PATH..."
    VERSION=$(grep '^version:' "$PUBSPEC_PATH" | awk '{print $2}')
    echo "Version found: $VERSION"
else
    echo "Error: $PUBSPEC_PATH not found."
    exit 1
fi

# Step 3: Clean the Flutter project
echo "Cleaning previous builds..."
flutter clean

# Step 4: Get dependencies
echo "Getting dependencies..."
flutter pub get

# Step 5: Build the iOS framework in release mode
echo "Building Flutter iOS framework in release mode..."
flutter build ios-framework --no-debug --no-profile --release --output="$OUTPUT_DIR"

# Step 6: Move frameworks out of the Release folder (if it exists)
RELEASE_DIR="$OUTPUT_DIR/Release"
if [[ -d "$RELEASE_DIR" ]]; then
    echo "Moving frameworks from $RELEASE_DIR to $OUTPUT_DIR..."
    mv "$RELEASE_DIR/"* "$OUTPUT_DIR/"
    rm -r "$RELEASE_DIR"
    echo "Frameworks moved successfully."
else
    echo "Frameworks are already in the desired directory."
fi

# Step 7: Update the podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION in $PODSPEC_PATH..."
    # For macOS compatibility
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
    echo "Podspec version updated successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi
# Step 8: Navigate back to the project root
cd "$IOS_DIR"

# Set up git repository for podspec validation
git init
git add .
git commit -m "Local commit for podspec validation"
git tag $VERSION

echo "git tag version  $VERSION"


# Set up CocoaPods trunk session for CI/CD
# Create .netrc file with authentication token from environment variable
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login amr.elskaan@amwal-pay.com
  password 8a950312db84f3534bf6e01e27c70595" > ~/.netrc
chmod 0600 ~/.netrc

# Push the podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
