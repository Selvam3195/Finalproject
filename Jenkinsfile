pipeline {
    agent any

    environment {
        dockerconnection = credentials('dockerconnection')
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
                    docker.withRegistry("https://index.docker.io/v1/", "dockerconnection") {
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
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'a5feca0c-b7f5-41c9-8641-27dea1e94127',
                    keyFileVariable: 'SSH_KEY'
                )]) {
                    script {
                        sh '''
                            chmod +x deploy.sh
                            scp -o StrictHostKeyChecking=no -i $SSH_KEY deploy.sh ubuntu@13.126.184.15:~/deploy.sh
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@13.126.184.15 "bash ~/deploy.sh"
                        '''
                    }
                }
            }
        }
    }
}
