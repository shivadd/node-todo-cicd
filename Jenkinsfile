pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
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
                    docker.build("${env.ECR_REPO_URI}:latest")
                }
            }
        }
        stage('Login to AWS ECR') {
            steps {
                withAWS(credentials: 'awscred', region: "${env.AWS_REGION}") {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 058264319429.dkr.ecr.us-east-1.amazonaws.com'
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    docker.image("${env.ECR_REPO_URI}:latest").push()
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                withAWS(credentials: 'awscred', region: "${env.AWS_REGION}") {
                    sh '''
                    aws eks --region us-east-1 update-kubeconfig --name <cluster_name>
                    kubectl apply -f k8s/deployment.yml
                    kubectl apply -f k8s/service.yml
                    '''
                }
            }
        }
    }
}
