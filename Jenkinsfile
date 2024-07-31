pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY_URI = '123456789012.dkr.ecr.us-east-1.amazonaws.com/node-todo-app' // Replace with your ECR repository URI
        ECR_REPOSITORY_NAME = 'node-todo-app'
        CLUSTER_NAME = 'your-cluster-name' // Replace with your EKS cluster name
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
                    def image = docker.build("node-todo-app:latest")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([aws(credentialsId: 'awscred', region: "${env.AWS_REGION}")]) {
                    script {
                        // Login to ECR
                        sh "aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_REPOSITORY_URI}"
                        
                        // Tag and push Docker image
                        sh "docker tag node-todo-app:latest ${env.ECR_REPOSITORY_URI}:latest"
                        sh "docker push ${env.ECR_REPOSITORY_URI}:latest"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([aws(credentialsId: 'awscred', region: "${env.AWS_REGION}")]) {
                    script {
                        // Update kubeconfig
                        sh "aws eks update-kubeconfig --name ${env.CLUSTER_NAME} --region ${env.AWS_REGION}"
                        
                        // Apply Kubernetes configuration
                        sh "kubectl apply -f k8s/deployment.yaml"
                        sh "kubectl apply -f k8s/service.yaml"
                    }
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
