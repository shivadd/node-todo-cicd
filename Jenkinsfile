pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub'  // Use your Docker Hub credentials ID here
    }

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

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        // Tag the Docker image
                        sh 'docker tag your-image SimulanisDevJagadeesha/your-repo:latest'
                        
                        // Push the Docker image to Docker Hub
                        sh 'docker push SimulanisDevJagadeesha/your-repo:latest'
                    }
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
