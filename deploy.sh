#!/bin/bash

# Set up PATH to include Homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Define Azure CLI path explicitly
AZ_PATH="/opt/homebrew/bin/az"

# Display paths for debugging
echo "Current PATH: $PATH"
echo "AZ location from PATH: $(which az 2>/dev/null || echo 'not found in PATH')"
echo "AZ_PATH: $AZ_PATH"
echo "AZ exists: $([ -f $AZ_PATH ] && echo 'YES' || echo 'NO')"
echo "Current user: $(whoami)"

# Login to Azure
"$AZ_PATH" login --service-principal -u "$AZURE_CLIENT_ID" -p "$AZURE_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID"
"$AZ_PATH" account set --subscription "$AZURE_SUBSCRIPTION_ID"

# Navigate to function app directory
cd src/FunctionApp

# Create deployment package
zip -r ../functionapp.zip . -x "*.git*" "*.pyc" "__pycache__" "*.pyo" "*.pyd" "*.so" "*.dylib" "*.dll" "*.exe" "*.egg" "*.egg-info" "*.dist-info" "venv/*"

# Deploy to Azure
"$AZ_PATH" functionapp deployment source config-zip -g "$RESOURCE_GROUP" -n "$FUNCTION_APP_NAME" --src ../functionapp.zip

# Clean up
rm ../functionapp.zip 