pipeline {
    agent any
    
    environment {
        ECR_REPO_URI = "058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app"
        AWS_REGION = "us-east-1"
        DOCKER_IMAGE = "${ECR_REPO_URI}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git credentialsId: 'gitcred', url: 'https://github.com/Simulanis-Dev-Jagadeesha/node-todo-cicd.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    withAWS(credentials: 'awscred', region: AWS_REGION) {
                        sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI'
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REPO_URI}", 'awscred') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withAWS(credentials: 'awscred', region: AWS_REGION) {
                        sh """
                        kubectl set image deployment/node-todo-app node-todo-app=${DOCKER_IMAGE} --record
                        kubectl rollout status deployment/node-todo-app
                        """
                    }
                }
            }
        }
    }
}
