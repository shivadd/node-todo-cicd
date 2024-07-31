pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPO_NAME = 'node-todo-app'
        IMAGE_TAG = "latest"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'gitcred', url: 'https://github.com/Simulanis-Dev-Jagadeesha/node-todo-cicd.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def customImage = docker.build("${ECR_REPO_NAME}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REGISTRY}", 'awscred') {
                        docker.image("${ECR_REPO_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                script {
                    sh """
                    aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name $EKS_CLUSTER_NAME
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    """
                }
            }
        }
    }
    triggers {
        pollSCM('H/5 * * * *') // Polls the SCM every 5 minutes
    }
}
