#!/bin/bash

# Exit script if any command fails
set -e

# Resolve the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define directories and paths
PROJECT_ROOT="$SCRIPT_DIR"
MODULE_DIR="$PROJECT_ROOT/amwal_sdk_flutter_module"
OUTPUT_DIR="$PROJECT_ROOT/AmwalSDKBuild"
PODSPEC_PATH="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/amwalsdk.podspec"
PUBSPEC_PATH="$PROJECT_ROOT/pubspec.yaml"
IOS_PROJECT="$PROJECT_ROOT/AnwalPaySDKNativeiOSExample/AnwalPaySDKNativeiOSExample.xcodeproj"
SCHEME_NAME="amwalsdk"

# Step 1: Extract the version from pubspec.yaml
if [[ -f "$PUBSPEC_PATH" ]]; then
    echo "Extracting version from $PUBSPEC_PATH..."
    VERSION=$(grep '^version:' "$PUBSPEC_PATH" | awk '{print $2}')
    echo "Version found: $VERSION"
else
    echo "Error: $PUBSPEC_PATH not found."
    exit 1
fi

# Step 2: Create a new directory for building
echo "Creating build directory at $OUTPUT_DIR..."
mkdir -p "$OUTPUT_DIR"

# Step 3: Build for iOS devices
echo "Building for iOS devices..."
xcodebuild archive \
  -project "$IOS_PROJECT" \
  -scheme "$SCHEME_NAME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 4: Build for iOS Simulator
echo "Building for iOS Simulator..."
xcodebuild archive \
  -project "$IOS_PROJECT" \
  -scheme "$SCHEME_NAME" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 5: Create the XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS.xcarchive/Products/Library/Frameworks/$SCHEME_NAME.framework" \
  -framework "$OUTPUT_DIR/AmwalSDK-iOS-Simulator.xcarchive/Products/Library/Frameworks/$SCHEME_NAME.framework" \
  -output "$OUTPUT_DIR/AmwalSDK.xcframework"

echo "XCFramework created successfully at $OUTPUT_DIR/AmwalSDK.xcframework."

# Step 6: Push the XCFramework to GitHub
GITHUB_REPO="https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample.git"  # Replace with your GitHub repository URL
echo "Pushing XCFramework to GitHub repository..."
cd "$OUTPUT_DIR"
if [[ ! -d .git ]]; then
    git init
fi
git remote remove origin || true
git remote add origin "$GITHUB_REPO"
git add AmwalSDK.xcframework
git commit -m "Add XCFramework version $VERSION"
git tag "$VERSION"
git push --tags origin main --force
echo "XCFramework pushed to GitHub repository successfully."

# Step 7: Update the podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION in $PODSPEC_PATH..."
    sed -i '' "s/s\.version[[:space:]]*=.*/s.version          = '$VERSION'/" "$PODSPEC_PATH"
    echo "Podspec version updated successfully."
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# Step 8: Push the podspec to CocoaPods trunk
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login amr.elskaan@amwal-pay.com
  password 8a950312db84f3534bf6e01e27c70595" > ~/.netrc
chmod 0600 ~/.netrc

# Push the podspec
echo "Pushing podspec to CocoaPods trunk..."
if pod trunk push "$PODSPEC_PATH"; then
    echo "Podspec pushed successfully."
else
    echo "Error: Failed to push podspec to CocoaPods trunk."
    rm -f ~/.netrc
    exit 1
fi

# Cleanup
rm -f ~/.netrc
echo "Build and publish process completed successfully."



