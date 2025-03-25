#!/bin/bash

# Directory setup
PROJECT_DIR="$(pwd)"
FRAMEWORK_NAME="amwalsdk"
OUTPUT_DIR="${PROJECT_DIR}/output"
OUTPUT_FRAMEWORK="${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"
OUTPUT_XCFRAMEWORK="${PROJECT_DIR}/${FRAMEWORK_NAME}.xcframework"

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Clean previous builds
rm -rf "${OUTPUT_DIR}"/*
rm -rf "${OUTPUT_XCFRAMEWORK}"


# cd amwalsdk
# # Set directories to 777 (rwxrwxrwx)
# find . -type d -exec chmod 777 {} \;

# # Set files to 666 (rw-rw-rw-)
# find . -type f -exec chmod 777 {} \;

# cd ..

echo "=== Building ${FRAMEWORK_NAME} framework ==="

# Try building for iOS device directly first
echo "Building for iOS..."
xcodebuild build \
  -project "${PROJECT_DIR}/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration Release \
  -sdk iphoneos \
  CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}/iphoneos" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build for simulator
echo "Building for iOS Simulator..."
xcodebuild build \
  -project "${PROJECT_DIR}/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration Release \
  -sdk iphonesimulator \
  CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}/iphonesimulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "${OUTPUT_DIR}/iphoneos/${FRAMEWORK_NAME}.framework" \
  -framework "${OUTPUT_DIR}/iphonesimulator/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT_XCFRAMEWORK}"

if [ -d "${OUTPUT_XCFRAMEWORK}" ]; then
  echo "✅ XCFramework created successfully at: ${OUTPUT_XCFRAMEWORK}"
else
  echo "❌ Failed to create XCFramework"
  exit 1
fi