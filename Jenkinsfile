pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '<account-id>.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'node-todo-app'
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
                    // Build Docker image
                    sh 'docker build -t ${IMAGE_NAME}:latest .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    // Get ECR login password
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'awscred']]) {
                        sh '''
                        $(aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY})
                        '''
                    }
                    
                    // Tag and push Docker image to ECR
                    sh '''
                    docker tag ${IMAGE_NAME}:latest ${ECR_REGISTRY}/${IMAGE_NAME}:latest
                    docker push ${ECR_REGISTRY}/${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // EKS deployment logic
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'awscred']]) {
                        sh '''
                        aws eks --region ${AWS_REGION} update-kubeconfig --name <eks-cluster-name>
                        kubectl apply -f deployment.yaml
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            // Cleanup actions, notifications, etc.
        }
    }
}
