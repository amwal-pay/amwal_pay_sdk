#!/bin/bash

# Function to handle errors
die() {
    echo "$1" >&2
    read -p "Press [Enter] to exit..." key
    exit 1
}

# Set the directories
ROOT_DIR=$(pwd)
FLUTTER_MODULE_DIR="$ROOT_DIR/amwal_sdk_flutter_module"
NATIVE_EXAMPLE_DIR="$ROOT_DIR/AnwalPaySDKNativeExample"
PUBLISH_DIR="$ROOT_DIR/publish_build"

FLUTTER_BUILD_NUMBER="1.0.2"

# Create the publish directory
mkdir -p "$PUBLISH_DIR"

# Step 1: Build and publish Native SDK
cd "$NATIVE_EXAMPLE_DIR" || die "Error: Native example directory not found."
echo "Building and publishing Native SDK..."

./gradlew assembleRelease || die "Error: Gradle build failed."

export SIGNING_KEY="-----BEGIN PGP PRIVATE KEY BLOCK-----

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
QtVx1DfjNsCVo+ewDB7WwHwczQSd6g==
=3+sS
-----END PGP PRIVATE KEY BLOCK-----" || die "Failed to export GPG key. Ensure the key ID is correct."
export SIGNING_PASSWORD="amwal@2025"


# Run `./gradlew publish` and handle failure gracefully
echo "Publishing Native SDK..."
if ! ./gradlew publish; then
    echo "Warning: Gradle publish failed. Skipping publish step."
fi

# Locate the auto-generated path for published files
NATIVE_PUBLISH_DIR=$(find "$NATIVE_EXAMPLE_DIR/build/publish/staging/" -mindepth 2 -maxdepth 2 -type d -name "com" 2>/dev/null)
if [ -z "$NATIVE_PUBLISH_DIR" ]; then
    echo "Error: Native publish directory not found. Skipping file move."
else
    echo "Moving files from Native publish directory to $PUBLISH_DIR..."
    cp -r "$NATIVE_PUBLISH_DIR"/* "$PUBLISH_DIR" || die "Error: Failed to move files from Native publish directory."
fi

# Step 2: Build Flutter AAR
cd "$FLUTTER_MODULE_DIR" || die "Error: Flutter module directory not found."
echo "Building AAR using 'flutter build aar' with build number $FLUTTER_BUILD_NUMBER..."
flutter build aar --no-debug --no-profile --build-number="$FLUTTER_BUILD_NUMBER" || echo "Warning: Flutter build failed. Skipping Flutter file move."

# Move AAR and POM files from Flutter build to publish_build
FLUTTER_REPO_DIR="$FLUTTER_MODULE_DIR/build/host/outputs/repo"
if [ -d "$FLUTTER_REPO_DIR" ]; then
    echo "Moving files from Flutter build to $PUBLISH_DIR..."
    cp -r "$FLUTTER_REPO_DIR"/* "$PUBLISH_DIR" || die "Error: Failed to move files from Flutter build."
else
    echo "Warning: Flutter build output directory not found."
fi

# Completion message
echo "Native and Flutter builds have been processed. Files are in $PUBLISH_DIR."
read -p "Press [Enter] to exit..." key
