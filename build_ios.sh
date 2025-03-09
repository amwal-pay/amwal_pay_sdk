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

# Step 7: Create a temporary directory to properly organize all necessary files
TEMP_DIR="$IOS_DIR/temp_build"
mkdir -p "$TEMP_DIR"
mkdir -p "$TEMP_DIR/Headers"
mkdir -p "$TEMP_DIR/Modules"

# Copy all required source files to the temp directory
echo "Copying essential source files..."
cp "$IOS_DIR/amwalsdk/amwalsdk.h" "$TEMP_DIR/Headers/"
cp "$IOS_DIR/amwalsdk/AmwalSDK.swift" "$TEMP_DIR/"
cp "$IOS_DIR/amwalsdk/Config.swift" "$TEMP_DIR/"
if [ -f "$IOS_DIR/amwalsdk/amwalsdk.md" ]; then
    cp "$IOS_DIR/amwalsdk/amwalsdk.md" "$TEMP_DIR/"
fi

# Create module map to ensure headers are properly exposed
echo "Creating module map..."
cat > "$TEMP_DIR/Modules/module.modulemap" << EOL
framework module amwalsdk {
  umbrella header "amwalsdk.h"
  
  export *
  module * { export * }
}
EOL

# Make sure to copy all Flutter dependencies to be embedded
echo "Copying Flutter dependencies..."
mkdir -p "$TEMP_DIR/Frameworks"
cp -R "$OUTPUT_DIR"/*.xcframework "$TEMP_DIR/Frameworks/"

# Step 8: Build for iOS devices with embedded dependencies
echo "Building for iOS devices..."
xcodebuild archive \
  -project "$IOS_DIR/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_LDFLAGS="-ObjC" \
  EMBEDDED_CONTENT_CONTAINS_SWIFT=YES \
  CLANG_ENABLE_MODULES=YES \
  DEFINES_MODULE=YES

# Step 9: Build for iOS Simulator with embedded dependencies
echo "Building for iOS Simulator..."
xcodebuild archive \
  -project "$IOS_DIR/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "amwalsdk" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$OUTPUT_DIR/AmwalSDK-iOS-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_LDFLAGS="-ObjC" \
  EMBEDDED_CONTENT_CONTAINS_SWIFT=YES \
  CLANG_ENABLE_MODULES=YES \
  DEFINES_MODULE=YES

# Step 10: Check if necessary files are included in the built framework and manually add if needed
DEVICE_FRAMEWORK="$OUTPUT_DIR/AmwalSDK-iOS.xcarchive/Products/Library/Frameworks/amwalsdk.framework"
SIMULATOR_FRAMEWORK="$OUTPUT_DIR/AmwalSDK-iOS-Simulator.xcarchive/Products/Library/Frameworks/amwalsdk.framework"

echo "Verifying and correcting framework content..."

# Function to ensure files exist in the framework
ensure_files_exist() {
    local framework_path=$1
    
    # Ensure Headers directory exists
    mkdir -p "$framework_path/Headers"
    
    # Copy header file
    if [ ! -f "$framework_path/Headers/amwalsdk.h" ]; then
        echo "Adding amwalsdk.h to $(basename "$framework_path")"
        cp "$TEMP_DIR/Headers/amwalsdk.h" "$framework_path/Headers/"
    fi
    
    # Ensure Modules directory exists
    mkdir -p "$framework_path/Modules"
    
    # Add module map if missing
    if [ ! -f "$framework_path/Modules/module.modulemap" ]; then
        echo "Adding module.modulemap to $(basename "$framework_path")"
        cp "$TEMP_DIR/Modules/module.modulemap" "$framework_path/Modules/"
    fi
    
    # Ensure Swift files are included
    local swift_files=("AmwalSDK.swift" "Config.swift")
    for swift_file in "${swift_files[@]}"; do
        # Swift files get compiled, so we look for their symbols in the binary
        # Just check file exists in temp directory
        if [ -f "$TEMP_DIR/$swift_file" ]; then
            echo "Verified $swift_file is available for compilation"
        else
            echo "Warning: $swift_file not found in temp directory"
        fi
    done
    
    # Copy all Flutter XCFrameworks into the Frameworks directory
    mkdir -p "$framework_path/Frameworks"
    echo "Adding Flutter dependencies to $(basename "$framework_path")/Frameworks"
    cp -R "$TEMP_DIR/Frameworks/"*.xcframework "$framework_path/Frameworks/"
}

# Fix both device and simulator frameworks
ensure_files_exist "$DEVICE_FRAMEWORK"
ensure_files_exist "$SIMULATOR_FRAMEWORK"

# Step 11: Create the XCFramework with embedded frameworks
echo "Creating XCFramework with embedded dependencies..."
xcodebuild -create-xcframework \
  -framework "$DEVICE_FRAMEWORK" \
  -framework "$SIMULATOR_FRAMEWORK" \
  -output "$OUTPUT_DIR/AmwalSDK.xcframework"

echo "XCFramework created successfully at $OUTPUT_DIR/AmwalSDK.xcframework."

# Step 12: Compress the XCFramework
echo "Compressing XCFramework..."
cd "$OUTPUT_DIR"
XCFRAMEWORK_ZIP="AmwalSDK-$VERSION.zip"
zip -X -r -q -9 "$XCFRAMEWORK_ZIP" "AmwalSDK.xcframework"
echo "XCFramework compressed successfully into $XCFRAMEWORK_ZIP."

# Step 13: Update podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
    
    # Update the podspec to ensure embedded frameworks are included
    echo "Updating podspec to include embedded frameworks..."
    if ! grep -q "preserve_paths" "$PODSPEC_PATH"; then
        sed -i '' "/s.vendored_frameworks/a\\
  s.preserve_paths = 'AmwalSDK.xcframework/**/*'" "$PODSPEC_PATH"
    fi
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# Step 14: Create a GitHub release and upload the XCFramework
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

# Step 15: Set up CocoaPods trunk session for CI/CD
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc

# Step 16: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."

# Clean up temporary directory
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"