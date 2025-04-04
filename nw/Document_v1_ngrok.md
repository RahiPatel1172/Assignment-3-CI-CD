# Azure Functions Deployment with ngrok and GitHub Webhooks

## Overview
This project demonstrates how to create and deploy an Azure Function using Jenkins with ngrok for public URL access, enabling GitHub webhooks for automated deployments. This approach allows for real-time pipeline triggers without requiring a public server.

> **Note**: Throughout this document, "myfunction" is used as a placeholder name. You can replace it with your own name or any other identifier you prefer (e.g., "yourname-function", "yourname-rg", etc.).

## Project Structure

### 1. `function_app.py`
**Purpose**: Main Azure Function code that handles HTTP requests.
- Contains HTTP trigger function
- Handles CORS requests
- Includes error handling and logging
- Returns timestamp with response

### 2. `host.json`
**Purpose**: Configuration file for Azure Functions runtime.
- Contains logging configuration
- Python worker settings
- CORS configuration
- Extension bundle settings

### 3. `local.settings.json`
**Purpose**: Local development settings for Azure Functions.
- Specifies Python runtime
- Development storage settings

### 4. `requirements.txt`
**Purpose**: Python dependencies for the Azure Function.
- Lists all required Python packages
- Specifies exact versions for compatibility

### 5. `test_function.py`
**Purpose**: Test cases for the Azure Function.
- Tests response content
- Tests status codes
- Tests response types

### 6. `Jenkinsfile`
**Purpose**: Jenkins pipeline configuration for CI/CD.
- Defines deployment stages
- Handles Azure authentication
- Manages deployment process

## Step-by-Step Implementation Process

### 1. Initial Setup

#### Azure Resources Creation
1. **Create Resource Group**:
   - Go to Azure Portal
   - Search for "Resource groups"
   - Click "Create"
   - Name: "myfunction-rg"
   - Select region
   - Click "Review + create"

2. **Create Function App**:
   - Go to Azure Portal
   - Search for "Function App"
   - Click "Create"
   - Select resource group: "myfunction-rg"
   - Name: "myfunction-function"
   - Select "Python" as runtime
   - Select Python version 3.8
   - Select "Consumption" plan
   - Click "Review + create"

3. **Create Service Principal**:
   ```bash
   # First, ensure Azure CLI is installed
   # For macOS
   brew install azure-cli

   # For Windows
   # Download MSI installer from Microsoft website

   # Verify Azure CLI installation
   az --version

   # Login to Azure
   az login

   # Create service principal
   az ad sp create-for-rbac --name "myfunction-sp" --role contributor \
                           --scopes /subscriptions/{subscription-id}/resourceGroups/myfunction-rg \
                           --sdk-auth
   ```
   - Save the output JSON for Jenkins credentials

#### Local Development Environment Setup

1. **Install Python 3.8**:
   ```bash
   # For macOS
   brew install python@3.8

   # For Windows
   # Download Python 3.8 installer from python.org

   # Verify installation
   python3.8 --version
   ```

2. **Install Azure CLI**:
   ```bash
   # For macOS
   brew install azure-cli

   # For Windows
   # Download MSI installer from Microsoft website

   # Verify installation
   az --version
   ```

3. **Install Azure Functions Core Tools**:
   ```bash
   # For macOS
   brew tap azure/functions
   brew install azure-functions-core-tools@4

   # For Windows
   # Download installer from Microsoft website

   # Verify installation
   func --version
   ```

### 2. CI/CD Pipeline Setup with ngrok

#### Jenkins Configuration
1. **Install Required Plugins**:
   - Azure CLI Plugin
   - GitHub Integration Plugin
   - Credentials Plugin
   - GitHub webhook plugin

2. **Configure Azure Credentials**:
   - Go to Jenkins Dashboard
   - Click "Manage Jenkins" > "Manage Credentials"
   - Add new credentials with ID "azure-credentials"
   - Add these credentials:
     - AZURE_SUBSCRIPTION_ID
     - AZURE_TENANT_ID
     - AZURE_CLIENT_ID
     - AZURE_CLIENT_SECRET

3. **Local Azure CLI Installation**:
   ```bash
   # For macOS
   brew install azure-cli

   # For Windows
   # Download MSI installer from Microsoft website

   # Verify installation
   az --version
   ```

#### ngrok Setup
1. **Install ngrok**:
   ```bash
   # For macOS
   brew install ngrok

   # For Windows
   # Download from https://ngrok.com/download
   ```

2. **Configure ngrok**:
   ```bash
   # Sign up at ngrok.com and get your authtoken
   ngrok config add-authtoken YOUR_AUTH_TOKEN
   ```

3. **Start ngrok for Jenkins**:
   ```bash
   # Assuming Jenkins runs on port 8080
   ngrok http 8080
   ```
   - Save the generated public URL (e.g., `https://abc123.ngrok.io`)

#### GitHub Integration with Webhooks
1. **Create GitHub Token**:
   - Go to GitHub Settings
   - Developer settings > Personal access tokens
   - Generate new token with repo access
   - Copy token for Jenkins

2. **Configure Jenkins GitHub Credentials**:
   - Add GitHub token in Jenkins credentials
   - ID: "github-credentials"

3. **Configure GitHub Webhook**:
   - Go to your GitHub repository
   - Settings > Webhooks > Add webhook
   - Payload URL: `https://your-ngrok-url/github-webhook/`
   - Content type: `application/json`
   - Secret: Generate a secure secret
   - Select events: "Just the push event"
   - Save webhook

4. **Configure Jenkins Job**:
   - Go to job configuration
   - Under "Build Triggers"
   - Check "GitHub hook trigger for GITScm polling"
   - Save configuration

### 3. Deployment Process
1. **Initial Deployment**:
   - Push code to GitHub
   - GitHub webhook automatically triggers Jenkins
   - Function deploys to Azure

2. **Troubleshooting and Improvements**:
   - Fixed CORS issues
   - Updated configuration
   - Improved error handling

### 4. Testing and Verification

#### Local Testing
1. **Test Function Locally**:
   ```bash
   # Start function locally
   func start

   # Test with curl
   curl http://localhost:7071/api/hello
   ```

2. **Test with Postman**:
   - Create new GET request
   - URL: `http://localhost:7071/api/hello`
   - Send request
   - Check response

#### Azure Function Testing

#### CORS Configuration
1. **Azure Portal CORS Settings**:
   - Go to Function App
   - Click "CORS"
   - Add allowed origins:
     ```
     https://portal.azure.com
     https://myfunction-function.azurewebsites.net
     http://localhost:7071
     ```
   - Enable "Access-Control-Allow-Credentials"
   - Click "Save"

#### Function URL Components
```
https://myfunction-function.azurewebsites.net/api/hello?code=PLACEHOLDER
```
- Base URL: `https://myfunction-function.azurewebsites.net`
- Function path: `/api/hello`
- Function key: Replace `PLACEHOLDER` with your actual function key

#### Testing Methods

1. **Browser Testing**:
   - Open function URL in browser
   - Expected response: "Hello, World! Current time: [timestamp]"

2. **Postman Testing**:
   - Create new GET request
   - Enter function URL
   - Send request
   - Check response and status code

3. **Azure Portal Testing**:
   - Go to Function App
   - Click "Functions" > "HttpTrigger"
   - Click "Code + Test"
   - Configure test parameters:
     - HTTP method: GET
     - Query parameters: Replace `PLACEHOLDER` with your actual function key
   - Click "Run"

4. **curl Testing**:
   ```bash
   # Replace PLACEHOLDER with your actual function key
   curl "https://myfunction-function.azurewebsites.net/api/hello?code=PLACEHOLDER"
   ```

## Key Learnings
1. **Local Development with ngrok**:
   - ngrok provides secure public URL for local Jenkins
   - Webhooks enable real-time pipeline triggers
   - Temporary URLs require regular updates

2. **CI/CD with Jenkins**:
   - Webhooks provide immediate deployment triggers
   - Environment variables and credentials need proper configuration
   - Tool checks ensure pipeline has required dependencies

3. **Azure Deployment**:
   - Azure Functions Core Tools simplify deployment
   - Function keys provide secure access
   - Remote building on Azure ensures compatibility

## Important Notes
1. **ngrok Limitations**:
   - Free tier provides temporary URLs
   - URLs change each time ngrok is restarted
   - Need to update webhook URL when ngrok URL changes

2. **Security Considerations**:
   - Use secure webhook secrets
   - Keep ngrok authtoken secure
   - Regularly rotate credentials

3. **Maintenance**:
   - Keep ngrok running while expecting deployments
   - Update webhook URL when ngrok URL changes
   - Monitor ngrok connection status

## Conclusion
This project demonstrates the creation and deployment of an Azure Function using CI/CD with Jenkins and ngrok for public URL access. Using GitHub webhooks with ngrok enables real-time pipeline triggers without requiring a permanent public server. The function returns a "Hello, World!" message with the current timestamp, and the entire process is automated through a Jenkins pipeline triggered by GitHub webhooks. 