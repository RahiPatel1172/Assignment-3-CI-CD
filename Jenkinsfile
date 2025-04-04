pipeline {
    agent any

    environment {
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        RESOURCE_GROUP = 'Assignment-3-CI-CD'
        FUNCTION_APP_NAME = 'assignment3cicd'
    }

    stages {
        stage('Build') {
            steps {
                sh '''
                    cd src/FunctionApp
                    npm install
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    cd src/tests
                    npm install
                    npm test
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    # Install Azure CLI (if not present)
                    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

                    # Login to Azure
                    az login --service-principal \
                        -u $AZURE_CLIENT_ID \
                        -p $AZURE_CLIENT_SECRET \
                        --tenant $AZURE_TENANT_ID
                    az account set --subscription $AZURE_SUBSCRIPTION_ID

                    # Package and deploy
                    cd src/FunctionApp
                    zip -r function.zip .
                    az functionapp deployment source config-zip \
                        --resource-group $RESOURCE_GROUP \
                        --name $FUNCTION_APP_NAME \
                        --src function.zip
                    rm function.zip
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo ' Pipeline succeeded! Deployed to: https://' + env.FUNCTION_APP_NAME + '.azurewebsites.net'
        }
        failure {
            echo ' Pipeline failed. Check logs.'
        }
    }
}