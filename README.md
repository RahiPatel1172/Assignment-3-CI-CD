# Azure Function CI/CD Pipeline

This project demonstrates a complete CI/CD pipeline using Jenkins to deploy a Python Azure Function to Azure Function App. The pipeline automates building, testing, and deploying the application.

## Project Structure

```
├── Jenkinsfile             # Jenkins pipeline configuration
├── deploy.sh               # Deployment script
├── src/
│   └── FunctionApp/        # Azure Function App code
│       ├── function_app.py # Main function implementation
│       ├── function.json   # Function configuration
│       ├── host.json       # Host configuration
│       ├── requirements.txt # Python dependencies
│       ├── test_function.py # Test cases
│       └── local.settings.json # Local settings
```

## Prerequisites

* Python 3.9 or higher
* Jenkins server
* Azure account with:
  * Active subscription
  * Resource group: `Assignment-3-CI-CD`
  * Function App: `assignment3cicd`
* Jenkins credentials configured for Azure:
  * `AZURE_CLIENT_ID`
  * `AZURE_CLIENT_SECRET`
  * `AZURE_TENANT_ID`
  * `AZURE_SUBSCRIPTION_ID`

## Local Development

1. Clone this repository:
   ```
   git clone https://github.com/RahiPatel1172/Assignment-3-CI-CD.git
   cd Assignment-3-CI-CD
   ```

2. Create a virtual environment:
   ```
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```
   cd src/FunctionApp
   pip install -r requirements.txt
   ```

4. Run tests:
   ```
   python -m pytest test_function.py -v
   ```

## Jenkins Pipeline Setup

### 1. Configure Jenkins

1. Install Jenkins (if not already installed):
   * On macOS: `brew install jenkins-lts`
   * Access Jenkins at http://localhost:8080

2. Install required Jenkins plugins:
   * Pipeline
   * Git Integration
   * Credentials Binding

### 2. Add Azure Credentials to Jenkins

1. Navigate to "Manage Jenkins" > "Manage Credentials"
2. Add the following credentials (Kind: Secret text):
   * `AZURE_CLIENT_ID`: Your Azure service principal client ID
   * `AZURE_CLIENT_SECRET`: Your Azure service principal client secret
   * `AZURE_TENANT_ID`: Your Azure tenant ID
   * `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID

### 3. Create Jenkins Pipeline

1. Click "New Item" in Jenkins
2. Enter a name (e.g., "Assignment-3-CI-CD") and select "Pipeline"
3. Configure the pipeline:
   * Definition: "Pipeline script from SCM"
   * SCM: Git
   * Repository URL: `https://github.com/RahiPatel1172/Assignment-3-CI-CD.git`
   * Branch Specifier: `*/main`
   * Script Path: `Jenkinsfile`
4. Click "Save" and "Build Now"

## CI/CD Pipeline Details

The pipeline consists of three stages:

1. **Build**: Sets up Python environment and installs dependencies
2. **Test**: Runs automated tests to ensure code quality
3. **Deploy**: Deploys the function to Azure Function App

### Deployment Process

The deployment script (`deploy.sh`) performs the following steps:

1. Creates a deployment package (zip file)
2. Authenticates with Azure using service principal credentials
3. Deploys the package to Azure Function App using REST API

## Troubleshooting

* **Jenkins cannot find Azure CLI**: The pipeline uses a REST API approach instead of Azure CLI to avoid dependencies
* **Authentication failures**: Verify your Azure credentials in Jenkins
* **Deployment failures**: Check the Azure Function App configuration and permissions

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Rahi Patel 