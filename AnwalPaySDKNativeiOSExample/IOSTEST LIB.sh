#!/bin/bash

# Directory setup
PROJECT_DIR="$(pwd)"
FRAMEWORK_NAME="amwalsdk"
OUTPUT_DIR="${PROJECT_DIR}/output"
OUTPUT_FRAMEWORK="${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"
OUTPUT_XCFRAMEWORK="${PROJECT_DIR}/${FRAMEWORK_NAME}.xcframework"
TEMP_DIR="${PROJECT_DIR}/temp_build"

# Create output and temp directories
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${TEMP_DIR}"
mkdir -p "${TEMP_DIR}/Headers"
mkdir -p "${TEMP_DIR}/Modules"

# Clean previous builds
rm -rf "${OUTPUT_DIR}"/*
rm -rf "${OUTPUT_XCFRAMEWORK}"
rm -rf "${TEMP_DIR}"/*

# Ensure source files are properly readable
cd amwalsdk
# Set directories to 777 (rwxrwxrwx)
find . -type d -exec chmod 777 {} \;

# Set files to 666 (rw-rw-rw-)
find . -type f -exec chmod 777 {} \;

# Prepare essential files
echo "Preparing essential source files..."
cp "${PROJECT_DIR}/amwalsdk/amwalsdk.h" "${TEMP_DIR}/Headers/"
cp "${PROJECT_DIR}/amwalsdk/AmwalSDK.swift" "${TEMP_DIR}/"
cp "${PROJECT_DIR}/amwalsdk/Config.swift" "${TEMP_DIR}/"

# Create module map to ensure headers are properly exposed
echo "Creating module map..."
cat > "${TEMP_DIR}/Modules/module.modulemap" << EOL
framework module amwalsdk {
  umbrella header "amwalsdk.h"
  
  export *
  module * { export * }
}
EOL

cd ..

echo "=== Building ${FRAMEWORK_NAME} framework ==="

# Build for iOS device
echo "Building for iOS..."
xcodebuild build \
  -project "${PROJECT_DIR}/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration Release \
  -sdk iphoneos \
  CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}/iphoneos" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CLANG_ENABLE_MODULES=YES \
  DEFINES_MODULE=YES \
  OTHER_LDFLAGS="-ObjC"

# Build for simulator
echo "Building for iOS Simulator..."
xcodebuild build \
  -project "${PROJECT_DIR}/AnwalPaySDKNativeiOSExample.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration Release \
  -sdk iphonesimulator \
  CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}/iphonesimulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CLANG_ENABLE_MODULES=YES \
  DEFINES_MODULE=YES \
  OTHER_LDFLAGS="-ObjC"

# Function to ensure all necessary files are included in the framework
ensure_files_in_framework() {
  local framework_path=$1
  
  echo "Ensuring all files are in ${framework_path}..."
  
  # Ensure Headers directory exists
  mkdir -p "${framework_path}/Headers"
  
  # Copy header file if missing
  if [ ! -f "${framework_path}/Headers/amwalsdk.h" ]; then
    echo "Adding amwalsdk.h to framework"
    cp "${TEMP_DIR}/Headers/amwalsdk.h" "${framework_path}/Headers/"
  fi
  
  # Ensure Modules directory exists
  mkdir -p "${framework_path}/Modules"
  
  # Add module map if missing
  if [ ! -f "${framework_path}/Modules/module.modulemap" ]; then
    echo "Adding module.modulemap to framework"
    cp "${TEMP_DIR}/Modules/module.modulemap" "${framework_path}/Modules/"
  fi
  
  # Check Swift files - they should be compiled into the binary
  # But we can verify their existence in source
  for swift_file in "AmwalSDK.swift" "Config.swift"; do
    if [ -f "${TEMP_DIR}/${swift_file}" ]; then
      echo "Verified ${swift_file} was available for compilation"
    else
      echo "Warning: ${swift_file} not found in source directory"
    fi
  done
  
  # Copy Swift files into a SwiftSupport directory
  # This doesn't affect compilation but helps for documentation and inspection
  mkdir -p "${framework_path}/SwiftSupport"
  cp "${TEMP_DIR}/AmwalSDK.swift" "${framework_path}/SwiftSupport/" 2>/dev/null || echo "Warning: Couldn't copy AmwalSDK.swift"
  cp "${TEMP_DIR}/Config.swift" "${framework_path}/SwiftSupport/" 2>/dev/null || echo "Warning: Couldn't copy Config.swift"
  
  # Create Info.plist if missing
  if [ ! -f "${framework_path}/Info.plist" ]; then
    echo "Creating Info.plist"
    cat > "${framework_path}/Info.plist" << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>amwalsdk</string>
  <key>CFBundleIdentifier</key>
  <string>com.amwal.amwalsdk</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>amwalsdk</string>
  <key>CFBundlePackageType</key>
  <string>FMWK</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>NSPrincipalClass</key>
  <string></string>
</dict>
</plist>
EOL
  fi
}

# Apply fixes to both frameworks
ensure_files_in_framework "${OUTPUT_DIR}/iphoneos/${FRAMEWORK_NAME}.framework"
ensure_files_in_framework "${OUTPUT_DIR}/iphonesimulator/${FRAMEWORK_NAME}.framework"

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "${OUTPUT_DIR}/iphoneos/${FRAMEWORK_NAME}.framework" \
  -framework "${OUTPUT_DIR}/iphonesimulator/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT_XCFRAMEWORK}"

if [ -d "${OUTPUT_XCFRAMEWORK}" ]; then
  echo "✅ XCFramework created successfully at: ${OUTPUT_XCFRAMEWORK}"
  
  # Verify Swift files are included in the XCFramework
  echo "Verifying Swift files inclusion..."
  SWIFT_SUPPORT_IOS="${OUTPUT_XCFRAMEWORK}/ios-arm64/amwalsdk.framework/SwiftSupport"
  SWIFT_SUPPORT_SIM="${OUTPUT_XCFRAMEWORK}/ios-arm64_x86_64-simulator/amwalsdk.framework/SwiftSupport"
  
  if [ -f "${SWIFT_SUPPORT_IOS}/AmwalSDK.swift" ] && [ -f "${SWIFT_SUPPORT_IOS}/Config.swift" ]; then
    echo "✅ Swift files are included in the iOS framework"
  else
    echo "⚠️ Swift files may not be properly included in the iOS framework"
  fi
  
  if [ -f "${SWIFT_SUPPORT_SIM}/AmwalSDK.swift" ] && [ -f "${SWIFT_SUPPORT_SIM}/Config.swift" ]; then
    echo "✅ Swift files are included in the Simulator framework"
  else
    echo "⚠️ Swift files may not be properly included in the Simulator framework"
  fi
  
  # Clean up temp files
  rm -rf "${TEMP_DIR}"
else
  echo "❌ Failed to create XCFramework"
  exit 1
fi