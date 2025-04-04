#!/bin/bash

echo "Starting deployment process for Azure Function App..."

# Navigate to function app directory
cd src/FunctionApp

# Create deployment package
echo "Creating deployment package..."
zip -r ../functionapp.zip . -x "*.git*" "*.pyc" "__pycache__" "*.pyo" "*.pyd" "*.so" "*.dylib" "*.dll" "*.exe" "*.egg" "*.egg-info" "*.dist-info" "venv/*"
cd ..

# Get access token using service principal credentials
echo "Authenticating with Azure..."
TOKEN_RESPONSE=$(curl -s -X POST -d "grant_type=client_credentials&client_id=$AZURE_CLIENT_ID&client_secret=$AZURE_CLIENT_SECRET&resource=https://management.azure.com/" https://login.microsoftonline.com/$AZURE_TENANT_ID/oauth2/token)
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to authenticate with Azure"
    exit 1
fi

# Upload the package using REST API
echo "Deploying to Azure Function App: $FUNCTION_APP_NAME..."
DEPLOY_URL="https://management.azure.com/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Web/sites/$FUNCTION_APP_NAME/packageSlot?api-version=2022-03-01"

UPLOAD_RESPONSE=$(curl -s -X POST $DEPLOY_URL \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: multipart/form-data" \
  -F "package=@functionapp.zip")

# Check for errors in the response
if [[ $UPLOAD_RESPONSE == *"error"* ]]; then
    echo "Deployment failed: $UPLOAD_RESPONSE"
    exit 1
fi

# Clean up
rm functionapp.zip

echo "✅ Deployment complete!" 