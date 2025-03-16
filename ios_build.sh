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
PUBSPEC_PATH="$PROJECT_ROOT/pubspec.yaml"
# Step 1: Build Flutter Framework
# echo "Building Flutter framework..."
# cd "$FLUTTER_PROJECT_PATH"
# flutter build ios-framework --no-profile \
#     --output="../$OUTPUT_DIR"
# cd ..


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
           -sdk iphoneos \
           BUILD_DIR="$BUILD_DIR" \
           clean build | xcpretty

# Step 3: Copy Debug `amwalsdk.framework` to the build folder
echo "Copying Debug amwalsdk.framework to $BUILD_DIR..."
cp -R "$BUILD_DIR/Debug-iphoneos/$AMWALSDK_SCHEME.framework" "$BUILD_DIR/Debug"


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
           -sdk iphoneos \
           BUILD_DIR="$BUILD_DIR" \
         clean build | xcpretty

# Step 6: Copy Release `amwalsdk.framework` to the build folder
echo "Copying Release amwalsdk.framework to $BUILD_DIR..."
cp -R "$BUILD_DIR/Release-iphoneos/$AMWALSDK_SCHEME.framework" "$BUILD_DIR/Release"

# Step 7: Clean up temporary Frameworks folder in example project
echo "Cleaning up temporary Frameworks folder..."
# rm -rf "$DEST_DIR"

cd "$BUILD_DIR/Debug" && zip -r "../../$ZIP_OUTPUT_DIR/amwalsdk-debug.zip" amwalsdk.framework
cd "$BUILD_DIR/Release" && zip -r "../../$ZIP_OUTPUT_DIR/amwalsdk-release.zip" amwalsdk.framework
echo "Debug and Release builds of amwalsdk.framework are now in $BUILD_DIR!"

# Step 10: Update podspec with the extracted version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# echo "Creating GitHub release..."
# RELEASE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
#     -H "Content-Type: application/json" \
#     -d "{
#           \"tag_name\": \"v$VERSION\",
#           \"target_commitish\": \"main\",
#           \"name\": \"amwalsdk $VERSION\",
#           \"body\": \"Release of version $VERSION.\",
#           \"draft\": false,
#           \"prerelease\": false
#         }" \
#     "$GITHUB_API_URL/releases")

# UPLOAD_URL=$(echo "$RELEASE_RESPONSE" | grep -Eo '"upload_url": "[^"]*"' | sed 's/"upload_url": "//; s/{.*//')

# if [[ -z "$UPLOAD_URL" ]]; then
#     echo "Error: Failed to create a release. Response: $RELEASE_RESPONSE"
#     exit 1
# fi