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
GITHUB_REPO="https://${GITHUB_TOKEN}@github.com/amwal-pay/AnwalPaySDKNativeiOSExample.git"


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
  -output "$OUTPUT_DIR/AmwalSDK.xcframework"

echo "XCFramework created successfully at $OUTPUT_DIR/AmwalSDK.xcframework."

# Step 10: Compress the XCFramework
echo "Compressing XCFramework..."
cd "$OUTPUT_DIR"
XCFRAMEWORK_ZIP="AmwalSDK-$VERSION.zip"
zip -r "$XCFRAMEWORK_ZIP" "AmwalSDK.xcframework"
echo "XCFramework compressed successfully into $XCFRAMEWORK_ZIP."

# Step 11: Update the podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION in $PODSPEC_PATH..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
    echo "Podspec version updated successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# Step 12: Set up CocoaPods trunk session for CI/CD
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc

# Step 13: Navigate back to the iOS project root
cd "$IOS_DIR"

# Step 14: Set up git repository for podspec validation
BRANCH_NAME="release-$VERSION"
echo "Setting up Git branch $BRANCH_NAME..."
git init
git checkout -b "$BRANCH_NAME"
git add .
git commit -m "Local commit for podspec validation"
git tag "$VERSION"

echo "Git tag version $VERSION"

# Step 15: Push compressed XCFramework to GitHub
echo "Pushing XCFramework to GitHub repository..."
cd "$OUTPUT_DIR"

git init
git remote add origin "$GITHUB_REPO"
git checkout -b "$BRANCH_NAME"
git add "$XCFRAMEWORK_ZIP"
git commit -m "Add compressed XCFramework version $VERSION"
git tag "$VERSION"
git push --tags origin "$BRANCH_NAME" --force
echo "Compressed XCFramework pushed to GitHub repository successfully."

# Step 16: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."
