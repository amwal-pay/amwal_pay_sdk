#!/bin/bash

# Variables
API_URL="https://central.sonatype.com/api/v1/publisher/upload" # Replace with your API URL
API_KEY="eXhpN3dKYzg6Sy9ibWZRS3hCbW9GT083ZkN6Zk11RDI0SDNPRHovRlJIMFJBdEUzMi8rQys=" # Replace with your Base64-encoded API key
FILE_PATH="amwal_sdk.zip" # Replace with the file path

# Check if the file exists
if [[ ! -f "$FILE_PATH" ]]; then
    echo "Error: File $FILE_PATH does not exist."
    exit 1
fi

# Upload the file using curl
echo "Uploading $FILE_PATH to $API_URL..."
response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$API_URL" \
    -H "Authorization: Basic $API_KEY" \
    -H "Accept: text/plain" \
    -F "bundle=@$FILE_PATH")

# Check the response
if [[ "$response" -eq 201 ]]; then
    echo "File uploaded successfully!"
    exist 0
else
    echo "Upload failed with HTTP status code $response."
    exit 1
fi