#!/bin/bash

# Paths
FLUTTER_PROJECT_PATH="amwal_sdk_flutter_module"
OUTPUT_DIR="Frameworks"
DEST_DIR="../AnwalPaySDKNativeiOSExample/Frameworks"
XCODE_PROJECT="AnwalPaySDKNativeiOSExample.xcodeproj"
AMWALSDK_SCHEME="amwalsdk"

# Step 1: Clean previous builds
echo "Cleaning previous builds..."
rm -rf "$OUTPUT_DIR"

# Step 2: Build Flutter Framework
echo "Building Flutter framework..."
cd "$FLUTTER_PROJECT_PATH"
flutter build ios-framework \
    --output="../$OUTPUT_DIR"
cd ..

# Step 3: Copy Flutter Frameworks
echo "Copying Flutter frameworks to the example project..."
mkdir -p "$DEST_DIR/Debug"
mkdir -p "$DEST_DIR/Release"
cp -R "$OUTPUT_DIR/Debug/Flutter.framework" "$DEST_DIR/Debug"
cp -R "$OUTPUT_DIR/Release/Flutter.framework" "$DEST_DIR/Release"

# Step 4: Link Debug Framework to `amwalsdk`
echo "Linking Debug Flutter framework to amwalsdk..."
cp -R "$OUTPUT_DIR/Debug/Flutter.framework" "$OUTPUT_DIR/amwalsdk/Debug"

# Step 5: Build `amwalsdk` Debug
echo "Building `amwalsdk` Debug configuration..."
xcodebuild -project "$XCODE_PROJECT" \
           -scheme "$AMWALSDK_SCHEME" \
           -configuration Debug \
           -sdk iphoneos \
           BUILD_DIR="./build" \
           BUILD_ROOT="./build" \
           clean build | xcpretty

# Step 6: Copy Debug framework to destination
echo "Copying Debug amwalsdk framework..."
cp -R "./build/Debug-iphoneos/$AMWALSDK_SCHEME.framework" "$DEST_DIR/Debug"

# Step 7: Build `amwalsdk` Release
echo "Building `amwalsdk` Release configuration..."
xcodebuild -project "$XCODE_PROJECT" \
           -scheme "$AMWALSDK_SCHEME" \
           -configuration Release \
           -sdk iphoneos \
           BUILD_DIR="./build" \
           BUILD_ROOT="./build" \
           clean build | xcpretty

# Step 8: Copy Release framework to destination
echo "Copying Release amwalsdk framework..."
cp -R "./build/Release-iphoneos/$AMWALSDK_SCHEME.framework" "$DEST_DIR/Release"

# Step 9: Clean up temporary build files
echo "Cleaning up temporary build files..."
rm -rf "./build"

echo "Build and copy process completed successfully!"

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

#!/bin/bash


GITHUB_API_URL="https://api.github.com/repos/amwal-pay/AnwalPaySDKNativeiOSExample" # Replace with your repository URL

# Paths
DEBUG_FRAMEWORK="AnwalPaySDKNativeiOSExample/Frameworks/Debug/amwalsdk.framework.zip"
RELEASE_FRAMEWORK="AnwalPaySDKNativeiOSExample/Frameworks/Release/amwalsdk.framework.zip"

# Step 1: Zip the Debug and Release frameworks
echo "Zipping Debug and Release frameworks..."
zip -r "$DEBUG_FRAMEWORK" "AnwalPaySDKNativeiOSExample/Frameworks/Debug/amwalsdk.framework"
zip -r "$RELEASE_FRAMEWORK" "AnwalPaySDKNativeiOSExample/Frameworks/Release/amwalsdk.framework"

# Step 2: Create a new GitHub release
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

# Extract the release ID from the response
RELEASE_ID=$(echo "$RELEASE_RESPONSE" | jq -r '.id')

if [ "$RELEASE_ID" == "null" ]; then
  echo "Failed to create GitHub release. Response: $RELEASE_RESPONSE"
  exit 1
fi

echo "Release created successfully. Release ID: $RELEASE_ID"

# Step 3: Upload assets (Debug and Release frameworks)
echo "Uploading Debug framework..."
curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/zip" \
    --data-binary @"$DEBUG_FRAMEWORK" \
    "$GITHUB_API_URL/releases/$RELEASE_ID/assets?name=$(basename $DEBUG_FRAMEWORK)"

echo "Uploading Release framework..."
curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/zip" \
    --data-binary @"$RELEASE_FRAMEWORK" \
    "$GITHUB_API_URL/releases/$RELEASE_ID/assets?name=$(basename $RELEASE_FRAMEWORK)"

echo "Assets uploaded successfully!"

if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc



# Step 13: Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH"
echo "Podspec pushed successfully."