pipeline {
    agent any
    
    environment {
        // These credentials will be configured in Jenkins
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        // Your Azure resource names
        RESOURCE_GROUP = 'Assignment-3-CI-CD'
        FUNCTION_APP_NAME = 'assignment3cicd'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo 'Building the Azure Function application...'
                    sh '''
                        cd my-azure-function
                        npm install
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo 'Running test cases...'
                    sh '''
                        cd my-azure-function
                        npm test
                    '''
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying to Azure Functions...'
                    
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
                    sh '''
                        cd my-azure-function
                        zip -r ../function.zip . -x "node_modules/*"
                        cd ..
                    '''
                    
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
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
    }
} 