#!/bin/bash




#!/bin/bash

# Exit on error
set -e

# Get the current user's home directory
USER_HOME=$(eval echo ~"$USER")

# Define the destination directory
PUB_CREDENTIALS_DIR="$USER_HOME/Library/Application Support/dart"

# Ensure the directory exists
mkdir -p "$PUB_CREDENTIALS_DIR"

# Copy pub-credentials.json to the correct location
cp pub-credentials.json "$PUB_CREDENTIALS_DIR/pub-credentials.json"

# Set correct file permissions
chmod 600 "$PUB_CREDENTIALS_DIR/pub-credentials.json"

echo "✅ Credentials successfully copied to: $PUB_CREDENTIALS_DIR"



# Configuration
PACKAGE_PATH="."  # Path to the package directory
CREDENTIALS_FILE="pub-credentials.json"
PACKAGE_NAME="amwal_pay_sdk"

# Check if credentials file exists
if [ ! -f "$CREDENTIALS_FILE" ]; then
  echo "Error: Credentials file '$CREDENTIALS_FILE' not found"
  exit 1
fi

# Extract tokens from the credentials file
ACCESS_TOKEN=$(jq -r '.accessToken' "$CREDENTIALS_FILE")
REFRESH_TOKEN=$(jq -r '.refreshToken' "$CREDENTIALS_FILE")
ID_TOKEN=$(jq -r '.idToken' "$CREDENTIALS_FILE")
EXPIRATION=$(jq -r '.expiration' "$CREDENTIALS_FILE")

# Create pub credentials directory if it doesn't exist
PUB_CACHE_DIR="$HOME/.pub-cache"
PUB_CREDENTIALS_DIR="$PUB_CACHE_DIR/credentials.json"

# Ensure directory exists
mkdir -p "$PUB_CACHE_DIR"

# Create credentials file for pub
cat > "$PUB_CREDENTIALS_DIR" << EOF
{
  "accessToken": "$ACCESS_TOKEN",
  "refreshToken": "$REFRESH_TOKEN",
  "idToken": "$ID_TOKEN",
  "tokenEndpoint": "https://accounts.google.com/o/oauth2/token",
  "scopes": ["openid", "https://www.googleapis.com/auth/userinfo.email"],
  "expiration": $EXPIRATION
}
EOF

echo "Credentials configured successfully"

# Navigate to package directory
cd "$PACKAGE_PATH"

# Publish the package
echo "Publishing package to pub.dev..."
flutter pub publish --force

echo "Successfully published $PACKAGE_NAME to pub.dev"
