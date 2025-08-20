pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') 
        DEV_IMAGE = "cherry3104/react-app-dev"
        PROD_IMAGE = "cherry3104/react-app-prod"
        SSH_KEY = credentials('ec2-ssh-key') 
        EC2_USER = "ubuntu"
        EC2_HOST = "13.126.184.15"
        BUILD_TAG = "${env.BUILD_NUMBER}"  // unique tag for each build
    }

    stages {
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
                        if (env.BRANCH_NAME == 'dev') {
                            sh """
                                docker tag my-react-app:latest ${DEV_IMAGE}:${BUILD_TAG}
                                docker push ${DEV_IMAGE}:${BUILD_TAG}
                                docker push ${DEV_IMAGE}:latest
                            """
                        } else if (env.BRANCH_NAME == 'master') {
                            sh """
                                docker tag my-react-app:latest ${PROD_IMAGE}:${BUILD_TAG}
                                docker push ${PROD_IMAGE}:${BUILD_TAG}
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
                        scp -o StrictHostKeyChecking=no -i ${SSH_KEY} deploy.sh ${EC2_USER}@${EC2_HOST}:~/deploy.sh
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_HOST} "chmod +x ~/deploy.sh && ~/deploy.sh"
                    """
                }
            }
        }
    }
}
