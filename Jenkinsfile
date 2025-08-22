pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerconnection') 
        DEV_IMAGE = "cherry3104/react-app-dev"
        PROD_IMAGE = "cherry3104/react-app-prod"
        EC2_HOST = "13.126.184.15"
        EC2_USER = "ubuntu"
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
                    docker.withRegistry("https://index.docker.io/v1/", "dockerconnection") {
                        if (env.BRANCH_NAME == 'dev') {
                            sh """
                                docker tag my-react-app:latest ${DEV_IMAGE}:${BUILD_NUMBER}
                                docker push ${DEV_IMAGE}:${BUILD_NUMBER}
                                docker push ${DEV_IMAGE}:latest
                            """
                        } else if (env.BRANCH_NAME == 'master') {
                            sh """
                                docker tag my-react-app:latest ${PROD_IMAGE}:${BUILD_NUMBER}
                                docker push ${PROD_IMAGE}:${BUILD_NUMBER}
                                docker push ${PROD_IMAGE}:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        if (env.BRANCH_NAME == 'dev') {
                            sh """
                                scp -o StrictHostKeyChecking=no -i $SSH_KEY deploy.sh ${EC2_USER}@${EC2_HOST}:~/deploy.sh
                                ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${EC2_USER}@${EC2_HOST} "bash ~/deploy.sh ${DEV_IMAGE}:latest"
                            """
                        } else if (env.BRANCH_NAME == 'master') {
                            sh """
                                scp -o StrictHostKeyChecking=no -i $SSH_KEY deploy.sh ${EC2_USER}@${EC2_HOST}:~/deploy.sh
                                ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${EC2_USER}@${EC2_HOST} "bash ~/deploy.sh ${PROD_IMAGE}:latest"
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Branch: ${env.BRANCH_NAME}, Build: ${env.BUILD_NUMBER}"
        }
    }
}
