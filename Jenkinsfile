pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = '<account-id>.dkr.ecr.us-east-1.amazonaws.com/node-todo-app'
        EKS_CLUSTER = '<your-cluster-name>'
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
                    docker.build('node-todo-app:latest')
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'awscred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
                            docker tag node-todo-app:latest ${ECR_REPOSITORY}:latest
                            docker push ${ECR_REPOSITORY}:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'awscred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                            aws eks --region ${AWS_REGION} update-kubeconfig --name ${EKS_CLUSTER}
                            kubectl apply -f kubernetes/deployment.yaml
                            kubectl apply -f kubernetes/service.yaml
                        '''
                    }
                }
            }
        }
    }
}
