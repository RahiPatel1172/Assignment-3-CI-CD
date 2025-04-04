pipeline {
    agent any
    
    environment {
        PYTHON_VERSION = '3.9'
        RESOURCE_GROUP = 'Assignment-3-CI-CD'
        FUNCTION_APP_NAME = 'assignment3cicd'
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Setting up Python environment and installing dependencies'
                sh '''
                    # Create and activate virtual environment
                    python3 -m venv venv
                    source venv/bin/activate
                    
                    # Install dependencies
                    cd src/FunctionApp
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    source venv/bin/activate
                    cd src/FunctionApp
                    python -m pytest test_function.py -v
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'AZURE_CLIENT_ID', variable: 'AZURE_CLIENT_ID'),
                    string(credentialsId: 'AZURE_CLIENT_SECRET', variable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'AZURE_TENANT_ID', variable: 'AZURE_TENANT_ID'),
                    string(credentialsId: 'AZURE_SUBSCRIPTION_ID', variable: 'AZURE_SUBSCRIPTION_ID')
                ]) {
                    sh '''
                        # Login to Azure
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az account set --subscription $AZURE_SUBSCRIPTION_ID
                        
                        # Create deployment package
                        cd src/FunctionApp
                        zip -r ../functionapp.zip . -x "*.git*" "*.pyc" "__pycache__" "*.pyo" "*.pyd" "*.so" "*.dylib" "*.dll" "*.exe" "*.egg" "*.egg-info" "*.dist-info" "venv/*"
                        
                        # Deploy to Azure
                        az functionapp deployment source config-zip -g $RESOURCE_GROUP -n $FUNCTION_APP_NAME --src functionapp.zip
                        
                        # Clean up
                        rm functionapp.zip
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed'
            cleanWs()
        }
        failure {
            echo '❌ Deployment failed. Please check the logs for details.'
        }
    }
} 