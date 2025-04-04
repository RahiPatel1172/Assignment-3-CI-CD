#!/bin/bash

# Set up PATH to include Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Display paths for debugging
echo "Current PATH: $PATH"
echo "AZ location: $(which az)"

# Login to Azure
az login --service-principal -u "$AZURE_CLIENT_ID" -p "$AZURE_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID"
az account set --subscription "$AZURE_SUBSCRIPTION_ID"

# Navigate to function app directory
cd src/FunctionApp

# Create deployment package
zip -r ../functionapp.zip . -x "*.git*" "*.pyc" "__pycache__" "*.pyo" "*.pyd" "*.so" "*.dylib" "*.dll" "*.exe" "*.egg" "*.egg-info" "*.dist-info" "venv/*"

# Deploy to Azure
az functionapp deployment source config-zip -g "$RESOURCE_GROUP" -n "$FUNCTION_APP_NAME" --src ../functionapp.zip

# Clean up
rm ../functionapp.zip 