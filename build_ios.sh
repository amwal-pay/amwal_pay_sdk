#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define directories and paths
PROJECT_ROOT="$SCRIPT_DIR"
MODULE_DIR="$PROJECT_ROOT/amwal_sdk_flutter_module"
OUTPUT_DIR="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk/Flutter"
PODSPEC_PATH="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk/amwalsdk.podspec"
PUBSPEC_PATH="$PROJECT_ROOT/pubspec.yaml"
IOS_DIR="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample"
GITHUB_API_URL="https://api.github.com/repos/amwal-pay/AnwalPaySDKNativeiOSExample"

# Ensure necessary environment variables are set
if [[ -z "$GITHUB_TOKEN" || -z "$COCOAPODS_USERNAME" || -z "$COCOAPODS_PASSWORD" ]]; then
    echo "Error: Required environment variables (GITHUB_TOKEN, COCOAPODS_USERNAME, COCOAPODS_PASSWORD) are not set."
    exit 1
fi

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
    if [[ -z "$VERSION" ]]; then
        echo "Error: Could not extract version from pubspec.yaml."
        exit 1
    fi
    echo "Version found: $VERSION"
else
    echo "Error: $PUBSPEC_PATH not found."
    exit 1
fi

# Step 6: Download and extract Flutter.xcframework.zip
echo "Downloading Flutter.xcframework.zip..."
FLUTTER_ZIP_URL="https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/v1.0.75/Flutter.xcframework.zip"
TEMP_ZIP="$OUTPUT_DIR/Flutter.xcframework.zip"

# Create output directories if they don't exist
mkdir -p "$OUTPUT_DIR/Debug"
mkdir -p "$OUTPUT_DIR/Release"

# Download the zip file with error handling
if ! curl -L -f "$FLUTTER_ZIP_URL" -o "$TEMP_ZIP"; then
    echo "Warning: Failed to download Flutter.xcframework.zip from GitHub. Continuing with Flutter build..."
else
    # Extract to Debug and Release directories with error handling
    echo "Extracting Flutter.xcframework.zip to Debug and Release directories..."
    if unzip -o -q "$TEMP_ZIP" -d "$OUTPUT_DIR/Debug" && unzip -o -q "$TEMP_ZIP" -d "$OUTPUT_DIR/Release"; then
        echo "Successfully extracted Flutter.xcframework.zip"
    else
        echo "Warning: Failed to extract Flutter.xcframework.zip. Continuing with Flutter build..."
    fi

    # Clean up
    rm -f "$TEMP_ZIP"
    rm -rf "$OUTPUT_DIR/Debug/__MACOSX" 2>/dev/null || true
    rm -rf "$OUTPUT_DIR/Release/__MACOSX" 2>/dev/null || true
fi

echo "Proceeding with Flutter build..."

# Step 3: Clean the Flutter project
echo "Cleaning previous builds..."
flutter clean
# Step 4: Get dependencies
echo "Getting dependencies..."
flutter pub get

# Step 5: Build the Flutter iOS framework in release mode
echo "Building Flutter iOS framework in release mode..."
flutter build ios-framework --xcframework --no-profile --release --output="$OUTPUT_DIR"

# Step 7: Compress the entire amwalsdk folder and the podspec file together
echo "Compressing amwalsdk folder and podspec file..."
cd "$IOS_DIR"
XCFRAMEWORK_ZIP="amwalsdk-$VERSION.zip"
zip -X -r -q -9 "$XCFRAMEWORK_ZIP" "amwalsdk" "amwalsdk.podspec"
echo "amwalsdk folder and podspec compressed successfully into $XCFRAMEWORK_ZIP."

# Step 8: Update podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# Step 9: Create a GitHub release and upload the amwalsdk ZIP
echo "Creating GitHub release..."
RELEASE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
          \"tag_name\": \"v$VERSION\",
          \"target_commitish\": \"main\",
          \"name\": \"amwalsdk $VERSION\",
          \"body\": \"Release of version $VERSION.\",
          \"draft\": false,
          \"prerelease\": false
        }" \
    "$GITHUB_API_URL/releases")

UPLOAD_URL=$(echo "$RELEASE_RESPONSE" | grep -Eo '"upload_url": "[^"]*"' | sed 's/"upload_url": "//; s/{.*//')

if [[ -z "$UPLOAD_URL" ]]; then
    echo "Error: Failed to create a release. Response: $RELEASE_RESPONSE"
fi

echo "Uploading amwalsdk ZIP to GitHub release..."
curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/zip" \
    --data-binary @"$XCFRAMEWORK_ZIP" \
    "$UPLOAD_URL?name=$XCFRAMEWORK_ZIP"

# Step 10: Set up CocoaPods trunk session for CI/CD
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc

# Step 11: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."