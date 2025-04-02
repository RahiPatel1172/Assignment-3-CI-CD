pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        RESOURCE_GROUP = 'your-resource-group'
        FUNCTION_APP_NAME = 'your-function-app-name'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo 'Building the application...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    sh 'npm test'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying to Azure...'
                    // Login to Azure
                    sh '''
                        az login --service-principal \
                            -u $AZURE_CLIENT_ID \
                            -p $AZURE_CLIENT_SECRET \
                            --tenant $AZURE_TENANT_ID
                    '''
                    
                    // Set subscription
                    sh 'az account set --subscription $AZURE_SUBSCRIPTION_ID'
                    
                    // Create deployment package
                    sh 'zip -r function.zip . -x "node_modules/*"'
                    
                    // Deploy to Azure Functions
                    sh '''
                        az functionapp deployment source config-zip \
                            --resource-group $RESOURCE_GROUP \
                            --name $FUNCTION_APP_NAME \
                            --src function.zip
                    '''
                    
                    // Clean up
                    sh 'rm function.zip'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
} 