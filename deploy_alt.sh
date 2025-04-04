#!/bin/bash

# Display environment info
echo "Current directory: $(pwd)"
echo "Current user: $(whoami)"
echo "Current PATH: $PATH"

# Navigate to function app directory
cd src/FunctionApp

# Create deployment package
echo "Creating deployment package..."
zip -r ../functionapp.zip . -x "*.git*" "*.pyc" "__pycache__" "*.pyo" "*.pyd" "*.so" "*.dylib" "*.dll" "*.exe" "*.egg" "*.egg-info" "*.dist-info" "venv/*"
cd ..

# Deploy to Azure using REST API
echo "Deploying to Azure..."

# Get access token using service principal credentials
echo "Getting access token..."
TOKEN_RESPONSE=$(curl -s -X POST -d "grant_type=client_credentials&client_id=$AZURE_CLIENT_ID&client_secret=$AZURE_CLIENT_SECRET&resource=https://management.azure.com/" https://login.microsoftonline.com/$AZURE_TENANT_ID/oauth2/token)
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to get access token"
    echo "Token response: $TOKEN_RESPONSE"
    exit 1
fi

echo "Access token obtained successfully"

# Upload the package using REST API
echo "Uploading deployment package..."
DEPLOY_URL="https://management.azure.com/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Web/sites/$FUNCTION_APP_NAME/packageSlot?api-version=2022-03-01"

UPLOAD_RESPONSE=$(curl -s -X POST $DEPLOY_URL \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: multipart/form-data" \
  -F "package=@functionapp.zip")

echo "Deployment response: $UPLOAD_RESPONSE"

# Clean up
echo "Cleaning up..."
rm functionapp.zip

echo "Deployment complete" 