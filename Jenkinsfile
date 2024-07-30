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
                    // Build Docker images using Docker Compose
                    sh 'docker-compose build --no-cache'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing containers
                    sh 'docker-compose down'
                    
                    // Start containers with the updated images
                    sh 'docker-compose up -d'
                }
            }
        }
    }
}
