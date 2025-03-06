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

# Step 3: Clean the Flutter project
echo "Cleaning previous builds..."
flutter clean

# Step 4: Get dependencies
echo "Getting dependencies..."
flutter pub get

# Step 5: Build the Flutter iOS framework in release mode
echo "Building Flutter iOS framework in release mode..."
flutter build ios-framework --no-debug --no-profile --release --output="$OUTPUT_DIR"

# Step 6: Ensure frameworks were built successfully
RELEASE_DIR="$OUTPUT_DIR/Release"
if [[ -d "$RELEASE_DIR" ]]; then
    echo "Moving frameworks from $RELEASE_DIR to $OUTPUT_DIR..."
    mv "$RELEASE_DIR/"* "$OUTPUT_DIR/"
    rm -r "$RELEASE_DIR"
else
    echo "Error: Release directory not found. Build might have failed."
    exit 1
fi

# Step 7: Build for iOS devices
echo "Building for iOS devices..."
xcodebuild archive \
  -project "$IOS_DIR/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 8: Build for iOS Simulator
echo "Building for iOS Simulator..."
xcodebuild archive \
  -project "$IOS_DIR/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 9: Create the XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS-Simulator.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
  -output "$OUTPUT_DIR/amwalsdk.xcframework"

echo "XCFramework created successfully at $OUTPUT_DIR/amwalsdk.xcframework."

# Step 8: Create the XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "$OUTPUT_DIR/AmwalSDK-generic_platform=iOS.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
    -framework "$OUTPUT_DIR/AmwalSDK-generic_platform=iOS_Simulator.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
    -output "$OUTPUT_DIR/amwalsdk.xcframework"

# Step 9: Compress the XCFramework
XCFRAMEWORK_ZIP="AmwalSDK-$VERSION.zip"
echo "Compressing XCFramework into $XCFRAMEWORK_ZIP..."
cd "$OUTPUT_DIR"
zip -r "$XCFRAMEWORK_ZIP" "amwalsdk.xcframework"

# Step 10: Update podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# Step 11: Create a GitHub release and upload the XCFramework
echo "Creating GitHub release..."
RELEASE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
          \"tag_name\": \"v$VERSION\",
          \"target_commitish\": \"main\",
          \"name\": \"Amwal SDK $VERSION\",
          \"body\": \"Release of version $VERSION.\",
          \"draft\": false,
          \"prerelease\": false
        }" \
    "$GITHUB_API_URL/releases")

UPLOAD_URL=$(echo "$RELEASE_RESPONSE" | grep -Eo '"upload_url": "[^"]*"' | sed 's/"upload_url": "//; s/{.*//')

if [[ -z "$UPLOAD_URL" ]]; then
    echo "Error: Failed to create a release. Response: $RELEASE_RESPONSE"
    exit 1
fi

echo "Uploading XCFramework zip to GitHub release..."
curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/zip" \
    --data-binary @"$OUTPUT_DIR/$XCFRAMEWORK_ZIP" \
    "$UPLOAD_URL?name=$XCFRAMEWORK_ZIP"

# Step 12: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."
