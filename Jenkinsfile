pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPO_URI = '058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
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
                    dockerImage = docker.build("${env.ECR_REPO_URI}:latest")
                }
            }
        }
        
        stage('Login to AWS ECR') {
            steps {
                script {
                    withAWS(region: "${env.AWS_DEFAULT_REGION}", credentials: 'awscred') {
                        sh 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}'
                    }
                }
            }
        }
        
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh """
                    docker tag ${ECR_REPO_URI}:latest ${ECR_REPO_URI}:latest
                    docker push ${ECR_REPO_URI}:latest
                    """
                }
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                script {
                    withAWS(region: "${env.AWS_DEFAULT_REGION}", credentials: 'awscred') {
                        sh """
                        aws eks update-kubeconfig --name my-cluster
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        """
                    }
                }
            }
        }
    }
}
