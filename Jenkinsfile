pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO_URI = '058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
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
                    dockerImage = docker.build("${ECR_REPO_URI}:latest")
                }
            }
        }
        stage('Login to AWS ECR') {
            steps {
                script {
                    withAWS(region: "${AWS_REGION}", credentials: 'awscred') {
                        sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}'
                    }
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    dockerImage.push('latest')
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                script {
                    withAWS(region: "${AWS_REGION}", credentials: 'awscred') {
                        sh 'aws eks update-kubeconfig --name my-cluster'
                        sh 'kubectl apply -f k8s/deployment.yaml'
                    }
                }
            }
        }
    }
}

