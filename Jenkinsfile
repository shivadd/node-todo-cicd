pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY_URI = '058264319429.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
        DOCKER_IMAGE_NAME = 'node-todo-app'
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
                    docker.build(DOCKER_IMAGE_NAME, '.')
                }
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'awscred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        def ecrLogin = sh(script: 'aws ecr get-login-password --region $AWS_REGION', returnStdout: true).trim()
                        sh "echo $ecrLogin | docker login --username AWS --password-stdin $ECR_REPOSITORY_URI"
                        docker.tag("${DOCKER_IMAGE_NAME}:latest", "${ECR_REPOSITORY_URI}:latest")
                        docker.push("${ECR_REPOSITORY_URI}:latest")
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([file(credentialsId: 'aws-eks-kubeconfig', variable: 'KUBECONFIG')]) {
                    script {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }
    }
}
