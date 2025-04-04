pipeline {
    agent any
    
    environment {
        PYTHON_VERSION = '3.9'
        RESOURCE_GROUP = 'Assignment-3-CI-CD'
        FUNCTION_APP_NAME = 'assignment3cicd'
        PATH = "/opt/homebrew/bin:$PATH"
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
                        # Run the deployment script
                        ./deploy.sh
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