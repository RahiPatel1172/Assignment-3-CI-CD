# Azure Function CI/CD Pipeline

This project demonstrates a CI/CD pipeline for deploying an Azure Function using Jenkins. The pipeline includes build, test, and deploy stages.

## Project Structure

- `index.js` - Main Azure Function code
- `function.json` - Azure Function configuration
- `package.json` - Node.js dependencies and scripts
- `__tests__/function.test.js` - Test cases
- `Jenkinsfile` - Jenkins pipeline configuration

## Prerequisites

1. Azure Account with access to Azure Functions
2. GitHub Account
3. Jenkins Server with the following plugins installed:
   - GitHub Plugin
   - Azure CLI Plugin
   - Pipeline Plugin
4. Azure CLI installed on Jenkins server
5. Node.js installed on Jenkins server

## Setup Instructions

1. **Azure Setup**
   - Create an Azure Function App in Azure Portal
   - Create a Service Principal and note down:
     - Subscription ID
     - Tenant ID
     - Client ID
     - Client Secret

2. **GitHub Setup**
   - Create a new repository
   - Push this code to your repository

3. **Jenkins Setup**
   - Install required plugins
   - Configure GitHub integration
   - Add Azure credentials in Jenkins:
     - Go to Jenkins > Manage Jenkins > Manage Credentials
     - Add credentials for:
       - AZURE_SUBSCRIPTION_ID
       - AZURE_TENANT_ID
       - AZURE_CLIENT_ID
       - AZURE_CLIENT_SECRET

4. **Pipeline Configuration**
   - Create a new Pipeline job in Jenkins
   - Configure it to use the Jenkinsfile from your GitHub repository
   - Update the following variables in the Jenkinsfile:
     - RESOURCE_GROUP
     - FUNCTION_APP_NAME

## Running the Pipeline

1. Push changes to your GitHub repository
2. The pipeline will automatically trigger and:
   - Build the application
   - Run tests
   - Deploy to Azure Functions

## Testing

The project includes three test cases:
1. Verifies 200 status code
2. Checks Hello World message
3. Tests name parameter handling

## Function URL

After deployment, your function will be available at:
```
https://<function-app-name>.azurewebsites.net/api/HttpTrigger
```

## Notes

- Make sure to keep your Azure credentials secure
- The function requires authentication by default
- Update the test URL in `__tests__/function.test.js` with your deployed function URL 