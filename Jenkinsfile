pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS = credentials('dokerCreds')
        DOCKERHUB_CREDENTIALS = credentials('docker-hub')
        IMAGE_NAME = 'simulanisdevjagadeesha/node-todo-cicd'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository using GitHub credentials
                git credentialsId: 'dokerCreds', url: 'https://github.com/Simulanis-Dev-Jagadeesha/node-todo-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
                        dockerImage.push("${env.BUILD_ID}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
