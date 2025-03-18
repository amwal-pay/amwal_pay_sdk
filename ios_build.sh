#!/bin/bash



# Paths
XCODE_PROJECT="AnwalPaySDKNativeiOSExample/AnwalPaySDKNativeiOSExample.xcodeproj"
AMWALSDK_SCHEME="amwalsdk"
FLUTTER_PROJECT_PATH="amwal_sdk_flutter_module"  # Flutter module folder
OUTPUT_DIR="Frameworks"                          # Output of Flutter build
DEST_DIR="AnwalPaySDKNativeiOSExample/amwalsdk/Frameworks"   # Destination Frameworks folder in the iOS example app
BUILD_DIR="build"  # Final output directory for frameworks
ZIP_OUTPUT_DIR="zipped_frameworks" 
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)              # Directory for zipped frameworks
PUBSPEC_PATH="pubspec.yaml"
TARGET_DEBUG="AnwalPaySDKNativeiOSExample/build/Debug-iphoneos/amwalsdk.framework/Frameworks"
PODSPEC_PATH="$SCRIPT_DIR/AnwalPaySDKNativeiOSExample/amwalsdk.podspec"

 Step 1: Build Flutter Framework
 echo "Building Flutter framework..."
 cd "$FLUTTER_PROJECT_PATH"
 flutter build ios-framework --no-profile \
     --output="../$OUTPUT_DIR"
 cd ..


# Ensure the build directory exists
mkdir -p "$BUILD_DIR"

# Step 1: Copy Debug Frameworks
echo "Copying Debug frameworks..."
mkdir -p "$DEST_DIR"
cp -R "$OUTPUT_DIR/Debug/"* "$DEST_DIR"

# Step 2: Build the iOS app with Debug Frameworks
echo "Building iOS app with Debug frameworks..."
xcodebuild -project "$XCODE_PROJECT" \
           -scheme "$AMWALSDK_SCHEME" \
           -configuration Debug \
           -sdk iphonesimulator \
           BUILD_DIR="$BUILD_DIR" \
           clean build | xcpretty


#!/bin/bash

# Define Source and Target directories
SOURCE_DIR_DEBUG="AnwalPaySDKNativeiOSExample/$BUILD_DIR/Debug-iphonesimulator"
SOURCE_DIR_RELEASE="AnwalPaySDKNativeiOSExample/$BUILD_DIR/Release-iphonesimulator"
TARGET_DIR_DEBUG="$SOURCE_DIR_DEBUG/amwalsdk.framework/Frameworks"
TARGET_DIR_RELEASE="$SOURCE_DIR_RELEASE/amwalsdk.framework/Frameworks"

# Ensure the target directory existsß

echo "Copying all frameworks from $SOURCE_DIR_DEBUG to $TARGET_DIR_DEBUG (excluding amwalsdk.framework)..."

# Iterate through all .framework files in the source directory
for framework in "$SOURCE_DIR_DEBUG"/*.framework; do
  # Skip if it's amwalsdk.framework
  if [[ "$(basename "$framework")" == "amwalsdk.framework" ]]; then
    echo "Skipping amwalsdk.framework"
    continue
  fi
  
  # Copy the framework to the target directory
  echo "Copying $(basename "$framework") to $TARGET_DIR_DEBUG"
  cp -R "$framework" "$TARGET_DIR_DEBUG"
done

echo "Framework copy completed."



echo "Removing Flutter.framework.dSYM..."
rm -rf "Frameworks/Release/App.xcframework/ios-arm64/dSYMs/Flutter.framework.dSYM"
# Step 4: Replace Debug Frameworks with Release Frameworks


echo "Replacing Debug frameworks with Release frameworks..."
rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"
cp -R "$OUTPUT_DIR/Release/"* "$DEST_DIR"

# Step 5: Build the iOS app with Release Frameworks
echo "Building iOS app with Release frameworks..."
xcodebuild -project "$XCODE_PROJECT" \
           -scheme "$AMWALSDK_SCHEME" \
           -configuration Release \
           -sdk iphonesimulator \
           BUILD_DIR="$BUILD_DIR" \
         clean build | xcpretty


# Iterate through all .framework files in the source directory
for framework in "$SOURCE_DIR_RELEASE"/*.framework; do
  # Skip if it's amwalsdk.framework
  if [[ "$(basename "$framework")" == "amwalsdk.framework" ]]; then
    echo "Skipping amwalsdk.framework"
    continue
  fi
  
  # Copy the framework to the target directory
  echo "Copying $(basename "$framework") to $TARGET_DIR_RELEASE"
  cp -R "$framework" "$TARGET_DIR_RELEASE"
done

echo "Framework copy completed."
mkdir -p "$BUILD_DIR/Debug"
mkdir -p "$BUILD_DIR/Release"
# Step 6: Copy Release `amwalsdk.framework` to the build folder
echo "Copying Release amwalsdk.framework to $BUILD_DIR..."
cp -R "AnwalPaySDKNativeiOSExample/$BUILD_DIR/Release-iphonesimulator/$AMWALSDK_SCHEME.framework" "$BUILD_DIR/Release"
echo "Copying Debug amwalsdk.framework to $BUILD_DIR..."
cp -R "AnwalPaySDKNativeiOSExample/$BUILD_DIR/Debug-iphonesimulator/$AMWALSDK_SCHEME.framework" "$BUILD_DIR/Debug"
# Step 7: Clean up temporary Frameworks folder in example project
echo "Cleaning up temporary Frameworks folder..."
# rm -rf "$DEST_DIR"


mkdir -p "$ZIP_OUTPUT_DIR"


# Zipping Release Framework
if [ -d "$BUILD_DIR/Release/amwalsdk.framework" ]; then
  echo "Zipping Release framework..."
  cd "$BUILD_DIR/Release" || exit 1
  zip -r "../../$ZIP_OUTPUT_DIR/amwalsdk-release.zip" amwalsdk.framework || { echo "Error: Failed to create Release ZIP file."; exit 1; }
  cd - > /dev/null # Return to the previous working directory
  echo "Release build zipped successfully!"
else
  echo "Error: Release framework not found in $BUILD_DIR/Release!"
fi

# Zipping Debug Framework
if [ -d "$BUILD_DIR/Debug/amwalsdk.framework" ]; then
  echo "Zipping Debug framework..."
  cd "$BUILD_DIR/Debug" || exit 1
  zip -r "../../$ZIP_OUTPUT_DIR/amwalsdk-debug.zip" amwalsdk.framework || { echo "Error: Failed to create Debug ZIP file."; exit 1; }
  cd - > /dev/null # Return to the previous working directory
  echo "Debug build zipped successfully!"
else
  echo "Error: Debug framework not found in $BUILD_DIR/Debug!"
fi

cd "$(dirname "$0")" || exit 1


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

echo "Debug and Release zipping completed!"
# Step 10: Update podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi
GITHUB_API_URL="https://api.github.com/repos/amwal-pay/AnwalPaySDKNativeiOSExample"

# Zipped files to upload
DEBUG_ZIP_PATH="zipped_frameworks/amwalsdk-debug.zip"
RELEASE_ZIP_PATH="zipped_frameworks/amwalsdk-release.zip"

# Check if files exist
if [[ ! -f "$DEBUG_ZIP_PATH" || ! -f "$RELEASE_ZIP_PATH" ]]; then
  echo "Error: One or both zipped framework files are missing."
  exit 1
fi

# Step 1: Create GitHub Release
echo "Creating GitHub release..."
CREATE_RELEASE_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "tag_name": "'"v$VERSION"'",
        "name": "'"amwalsdk $VERSION"'",
        "body": "'"Release of version $VERSION."'",
        "draft": false,
        "prerelease": false
      }' \
  "$GITHUB_API_URL/releases")

# Extract upload URL from the response
UPLOAD_URL=$(echo "$CREATE_RELEASE_RESPONSE" | jq -r '.upload_url' | sed -e "s/{?name,label}//")

if [[ "$UPLOAD_URL" == "null" ]]; then
  echo "Error: Failed to create release. Response: $CREATE_RELEASE_RESPONSE"
  exit 1
fi

echo "GitHub release created successfully."

# Step 2: Upload Debug ZIP
echo "Uploading Debug ZIP..."
DEBUG_UPLOAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/zip" \
  --data-binary @"$DEBUG_ZIP_PATH" \
  "$UPLOAD_URL?name=$(basename $DEBUG_ZIP_PATH)")

DEBUG_UPLOAD_STATE=$(echo "$DEBUG_UPLOAD_RESPONSE" | jq -r '.state')

if [[ "$DEBUG_UPLOAD_STATE" != "uploaded" ]]; then
  echo "Error: Failed to upload Debug ZIP. Response: $DEBUG_UPLOAD_RESPONSE"
  exit 1
fi

echo "Debug ZIP uploaded successfully."

# Step 3: Upload Release ZIP
echo "Uploading Release ZIP..."
RELEASE_UPLOAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/zip" \
  --data-binary @"$RELEASE_ZIP_PATH" \
  "$UPLOAD_URL?name=$(basename $RELEASE_ZIP_PATH)")

RELEASE_UPLOAD_STATE=$(echo "$RELEASE_UPLOAD_RESPONSE" | jq -r '.state')

if [[ "$RELEASE_UPLOAD_STATE" != "uploaded" ]]; then
  echo "Error: Failed to upload Release ZIP. Response: $RELEASE_UPLOAD_RESPONSE"
  exit 1
fi

echo "Release ZIP uploaded successfully."

# Success message
echo "Both Debug and Release ZIPs have been uploaded to GitHub release $RELEASE_NAME."

# Step 12: Set up CocoaPods trunk session for CI/CD
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc



# Step 13: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."