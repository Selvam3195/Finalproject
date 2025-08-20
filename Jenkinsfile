pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DEV_IMAGE = "cherry3104/react-app-dev"
        PROD_IMAGE = "cherry3104/react-app-prod"
        SSH_KEY = credentials('ec2-ssh-key') 
        EC2_USER = "ubuntu"
        EC2_HOST = "13.126.184.15"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${env.Devops_Build}", url: 'https://github.com/Selvam3195/Devops_Build.git
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://index.docker.io/v1/", DOCKERHUB_CREDENTIALS) {
                        if (env.Devops_Build== 'dev') {
                            sh """
                                docker tag my-react-app:latest ${DEV_IMAGE}:${latest}
                                docker push ${DEV_IMAGE}:${latest}
                                docker push ${DEV_IMAGE}:latest
                            """
                        } else if (env.Devops_Build== 'master') {
                            sh """
                                docker tag my-react-app:latest ${PROD_IMAGE}:${latest}
                                docker push ${PROD_IMAGE}:${latest}
                                docker push ${PROD_IMAGE}:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh """
                    scp -o StrictHostKeyChecking=no -i ${SSH_KEY} deploy.sh ${EC2_USER}@${EC2_HOST}: .deploy.sh
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_HOST} '
                         sh 'chmod +x deploy.sh'
                    sh './deploy.sh'
                }
            }
        }
    }
}
