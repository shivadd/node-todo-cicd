pipeline {
    agent any

    environment {
        ECR_URI = '058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
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
                    sh 'docker build -t node-todo-app:latest .'
                }
            }
        }
        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'awscred']]) {
                    script {
                        sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 058264319429.dkr.ecr.us-east-1.amazonaws.com'
                        sh 'docker tag node-todo-app:latest 058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app:latest'
                        sh 'docker push 058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app:latest'
                    }
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                script {
                    // Add your deployment script or steps here
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
