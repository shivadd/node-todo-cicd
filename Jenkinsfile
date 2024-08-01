pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY_URI = '058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
        IMAGE_TAG = "latest-${env.BUILD_ID}" // Unique tag for each build
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${ECR_REPOSITORY_URI}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'awscred') {
                    sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh 'docker push ${ECR_REPOSITORY_URI}:${IMAGE_TAG}'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'awscred') {
                    sh 'aws eks update-kubeconfig --name my-cluster'
                    sh "kubectl set image deployment/node-todo-app node-todo-app=${ECR_REPOSITORY_URI}:${IMAGE_TAG} --record"
                    sh 'kubectl apply -f service.yml'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after build
        }
    }
}
