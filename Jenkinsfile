pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'dokerCreds', url: 'https://github.com/Simulanis-Dev-Jagadeesha/node-todo-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image locally
                    sh 'docker build -t my-node-app:latest .'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh '''
                        if [ $(docker ps -q -f name=my-node-app) ]; then
                            docker stop my-node-app
                            docker rm my-node-app
                        fi
                        docker run -d --name my-node-app -p 8000:8000 my-node-app:latest
                    '''
                }
            }
        }
    }
}
