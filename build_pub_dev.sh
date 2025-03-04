#!/bin/bash

# Script to publish a Dart/Flutter package to pub.dev using credentials from a JSON file

# Exit on error
set -e

# Configuration
PACKAGE_PATH="."  # Path to the package directory (current directory by default)
CREDENTIALS_FILE="pub-credentials.json"
PACKAGE_NAME="amwal_pay_sdk"

# Check if credentials file exists
if [ ! -f "$CREDENTIALS_FILE" ]; then
  echo "Error: Credentials file '$CREDENTIALS_FILE' not found"
  exit 1
fi

# Extract tokens from the credentials file
ACCESS_TOKEN=$(grep -o '"accessToken":"[^"]*"' "$CREDENTIALS_FILE" | cut -d':' -f2 | tr -d '"')
REFRESH_TOKEN=$(grep -o '"refreshToken":"[^"]*"' "$CREDENTIALS_FILE" | cut -d':' -f2 | tr -d '"')
ID_TOKEN=$(grep -o '"idToken":"[^"]*"' "$CREDENTIALS_FILE" | cut -d':' -f2 | tr -d '"')

# Create pub credentials directory if it doesn't exist
PUB_CACHE_DIR="$HOME/.pub-cache"
PUB_CREDENTIALS_DIR="$PUB_CACHE_DIR/credentials.json"

# Ensure directory exists
mkdir -p "$PUB_CACHE_DIR"

# Create credentials file for pub
cat > "$PUB_CREDENTIALS_DIR" << EOF
{
  "accessToken": ${ACCESS_TOKEN},
  "refreshToken": ${REFRESH_TOKEN},
  "idToken": ${ID_TOKEN},
  "tokenEndpoint": "https://accounts.google.com/o/oauth2/token",
  "scopes": ["openid", "https://www.googleapis.com/auth/userinfo.email"],
  "expiration": $(date +%s)000
}
EOF

echo "Credentials configured successfully"

# Navigate to package directory
cd "$PACKAGE_PATH"

# Verify package is ready for publishing
echo "Verifying package..."
flutter pub publish --dry-run

# Prompt for confirmation
read -p "Ready to publish $PACKAGE_NAME to pub.dev. Continue? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo "Publication aborted"
  exit 0
fi

# Publish the package
echo "Publishing package to pub.dev..."
dart pub publish --force

echo "Successfully published $PACKAGE_NAME to pub.dev"