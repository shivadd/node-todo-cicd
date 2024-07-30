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
                    // Run Docker container
                    sh 'docker run -d -p 8000:8000 my-node-app:latest'
                }
            }
        }
    }
}
