# Azure Function CI/CD Pipeline Assignment

This project demonstrates a CI/CD pipeline for deploying an Azure Function using Jenkins. The pipeline includes build, test, and deploy stages.

## Project Structure

```
my-azure-function/
├── src/
│   └── functions/
│       └── HttpTrigger.js    # Main function code
├── __tests__/
│   └── HttpTrigger.test.js   # Test cases
└── package.json              # Dependencies and scripts
```

## Features

- HTTP-triggered Azure Function
- Three test cases:
  1. Verifies 200 status code
  2. Tests default greeting message
  3. Tests personalized greeting with name parameter
- Automated deployment using Jenkins pipeline

## CI/CD Pipeline Stages

1. **Build Stage**
   - Installs Node.js dependencies
   - Prepares the application for deployment

2. **Test Stage**
   - Runs automated test cases
   - Verifies function behavior

3. **Deploy Stage**
   - Authenticates with Azure
   - Creates deployment package
   - Deploys to Azure Functions

## Local Development

1. Install dependencies:
   ```bash
   cd my-azure-function
   npm install
   ```

2. Run tests:
   ```bash
   npm test
   ```

3. Start function locally:
   ```bash
   npm start
   ```

## Jenkins Setup

1. Required plugins:
   - Git plugin
   - Azure CLI plugin
   - Pipeline plugin

2. Credentials needed:
   - AZURE_SUBSCRIPTION_ID
   - AZURE_TENANT_ID
   - AZURE_CLIENT_ID
   - AZURE_CLIENT_SECRET

3. Pipeline configuration:
   - Create new pipeline job
   - Use Pipeline script from SCM
   - Point to your repository

## Azure Function URL

After deployment, the function will be available at:
```
https://assignment3cicd.azurewebsites.net/api/HttpTrigger
```

Add a name parameter for a personalized greeting:
```
https://assignment3cicd.azurewebsites.net/api/HttpTrigger?name=YourName
``` 