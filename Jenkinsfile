pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'node-todo-app'
        ECR_URL = "<account-id>.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME = "${ECR_REPOSITORY}:latest"
    }

    triggers {
        pollSCM('* * * * *') // Check for changes every minute
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
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}'
                    sh 'docker tag ${IMAGE_NAME} ${ECR_URL}/${ECR_REPOSITORY}:${BUILD_NUMBER}'
                    sh 'docker push ${ECR_URL}/${ECR_REPOSITORY}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withAWS(region: "${AWS_REGION}", credentials: 'awscred') {
                        sh '''
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        '''
                    }
                }
            }
        }
    }
}
