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
                    // Build Docker image using Docker Compose
                    sh 'docker-compose build'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove any existing containers
                    sh '''
                        docker-compose down
                        docker-compose up -d
                    '''
                }
            }
        }
    }
}
