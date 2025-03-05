#!/bin/bash

# Exit script if any command fails
set -e

# Define variables
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT="$SCRIPT_DIR"
OUTPUT_DIR="$PROJECT_ROOT/AmwalSDKBuild"
VERSION=$(grep '^version:' "$PROJECT_ROOT/pubspec.yaml" | awk '{print $2}')
GITHUB_REPO="https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample.git"

# Static GitHub Token (Replace <your-github-token> with the actual token)

# Step 1: Build for iOS devices
echo "Building for iOS devices..."
xcodebuild archive \
  -project "$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 2: Build for iOS Simulator
echo "Building for iOS Simulator..."
xcodebuild archive \
  -project "$PROJECT_ROOT/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 3: Create the XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS-Simulator.xcarchive/Products/Library/Frameworks/amwalsdk.framework" \
  -output "$OUTPUT_DIR/AmwalSDK.xcframework"

echo "XCFramework created successfully at $OUTPUT_DIR/AmwalSDK.xcframework."

# Step 4: Push the XCFramework to GitHub
echo "Pushing XCFramework to GitHub repository..."
cd "$OUTPUT_DIR"

# Configure Git
git init
git remote add origin "https://${GITHUB_TOKEN}@${GITHUB_REPO#https://}"
git add AmwalSDK.xcframework
git commit -m "Add XCFramework version $VERSION"
git tag "$VERSION"

# Push to GitHub
git push --tags origin main --force
echo "XCFramework pushed to GitHub repository successfully."

# Step 5: Update and Publish Podspec
PODSPEC_PATH="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk.podspec"
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION in $PODSPEC_PATH..."
    sed -i '' "s/s\.version[[:space:]]*=.*/s.version          = '$VERSION'/" "$PODSPEC_PATH"
    echo "Podspec version updated successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

echo "Pushing podspec to CocoaPods trunk..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc

pod trunk push "$PODSPEC_PATH"
rm -f ~/.netrc
echo "Podspec pushed successfully to CocoaPods trunk."

echo "Build and publish process completed successfully."
