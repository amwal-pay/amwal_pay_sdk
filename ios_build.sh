Based on our previous discussion, I'll help you revert to the latest working version of the script with the key changes we made. Here's the updated version:

```bash:/Users/amrsaied/Documents/Flutter/Amwal/mobile/amwal_pay_sdk_amwal/ios_build.sh
#!/bin/bash

# Paths
FLUTTER_PROJECT_PATH="amwal_sdk_flutter_module"
DEST_DIR="AnwalPaySDKNativeiOSExample/amwalsdk"
ZIP_OUTPUT_DIR="zipped_frameworks"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PUBSPEC_PATH="pubspec.yaml"
PODSPEC_PATH="$SCRIPT_DIR/AnwalPaySDKNativeiOSExample/amwalsdk.podspec"

# Step 1: Build Flutter Framework
echo "Building Flutter framework..."
cd "$FLUTTER_PROJECT_PATH"
flutter clean
flutter pub get
flutter build ios-framework --no-profile --release \
    --output="../$DEST_DIR/Flutter" --cocoapods
cd ..

# Create zip output directory
mkdir -p "$ZIP_OUTPUT_DIR"

# Zipping Framework
if [ -d "$DEST_DIR" ]; then
  echo "Zipping all contents of $DEST_DIR..."
  cd "$DEST_DIR" || exit 1
  zip -r "../../$ZIP_OUTPUT_DIR/amwalsdk.zip" * || { echo "Error: Failed to create ZIP file."; exit 1; }
  cd - > /dev/null
  echo "Build zipped successfully!"
else
  echo "Error: Directory $DEST_DIR not found!"
fi

# Get version from pubspec
if [[ -f "$PUBSPEC_PATH" ]]; then
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

# Update podspec version
if [[ -f "$PODSPEC_PATH" ]]; then
    echo "Updating podspec version to $VERSION..."
    sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '$VERSION'/" "$PODSPEC_PATH"
else
    echo "Error: $PODSPEC_PATH not found."
    exit 1
fi

# GitHub release and upload
GITHUB_API_URL="https://api.github.com/repos/amwal-pay/AnwalPaySDKNativeiOSExample"
ZIP_PATH="zipped_frameworks/amwalsdk.zip"

if [[ ! -f "$ZIP_PATH" ]]; then
  echo "Error: Zipped framework file is missing."
  exit 1
fi

# Create GitHub Release
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

UPLOAD_URL=$(echo "$CREATE_RELEASE_RESPONSE" | jq -r '.upload_url' | sed -e "s/{?name,label}//")

if [[ "$UPLOAD_URL" == "null" ]]; then
  echo "Error: Failed to create release. Response: $CREATE_RELEASE_RESPONSE"
  exit 1
fi

# Upload ZIP
echo "Uploading ZIP..."
UPLOAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/zip" \
  --data-binary @"$ZIP_PATH" \
  "$UPLOAD_URL?name=$(basename $ZIP_PATH)")

UPLOAD_STATE=$(echo "$UPLOAD_RESPONSE" | jq -r '.state')

if [[ "$UPLOAD_STATE" != "uploaded" ]]; then
  echo "Error: Failed to upload ZIP. Response: $UPLOAD_RESPONSE"
  exit 1
fi

echo "ZIP uploaded successfully."

# CocoaPods trunk setup and push
echo "Setting up CocoaPods trunk authentication..."
echo "machine trunk.cocoapods.org
  login $COCOAPODS_USERNAME
  password $COCOAPODS_PASSWORD" > ~/.netrc
chmod 0600 ~/.netrc

# Push podspec to CocoaPods trunk
echo "Pushing podspec to CocoaPods trunk..."
pod trunk push "$PODSPEC_PATH" --allow-warnings --skip-import-validation
echo "Podspec pushed successfully."
