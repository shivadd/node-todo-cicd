pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub')
        GITHUB_CREDENTIALS = credentials('dokerCreds')
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
                    docker.build("simulanisdevjagadeesha/node-todo-cicd:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
                        docker.image("simulanisdevjagadeesha/node-todo-cicd:latest").push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def deployServer = 'ubuntu@ip-172-31-39-207'
                    def dockerImage = 'simulanisdevjagadeesha/node-todo-cicd:latest'
                    
                    sh """
                    ssh -o StrictHostKeyChecking=no ${deployServer} '
                        docker pull ${dockerImage} && \
                        docker stop my-node-todo-app || true && \
                        docker rm my-node-todo-app || true && \
                        docker run -d --name my-node-todo-app -p 8000:8000 ${dockerImage}
                    '
                    """
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
