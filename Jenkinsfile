pipeline {
    agent any

    environment {
        ECR_REPOSITORY_URI = "058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app"
        AWS_REGION = "us-east-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'gitcred', url: 'https://github.com/Simulanis-Dev-Jagadeesha/node-todo-cicd.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("node-todo-app")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'awscred']]) {
                    script {
                        sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}
                        docker tag node-todo-app:latest ${ECR_REPOSITORY_URI}:latest
                        docker push ${ECR_REPOSITORY_URI}:latest
                        """
                    }
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                // Add your deployment steps here
            }
        }
    }
}
