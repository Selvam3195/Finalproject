pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-react-app"
        DOCKERHUB_USER = "cherry3104"
        DEV_REPO = "cherry3104/my-react-app-dev"
        PROD_REPO = "cherry3104/my-react-app-prod"
        EC2_HOST = "ubuntu@13.126.184.15"
    }

    triggers {
        githubPush()   // auto-trigger on push
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

        stage('Push to DockerHub') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub-credentials-id', url: 'https://index.docker.io/v1/']) {
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker tag ${DOCKER_IMAGE}:latest ${DEV_REPO}:latest"
                            sh "docker push ${DEV_REPO}:latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker tag ${DOCKER_IMAGE}:latest ${PROD_REPO}:latest"
                            sh "docker push ${PROD_REPO}:latest"
                        } else {
                            echo "Not dev or master branch. Skipping push."
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh """
                            echo "Copying deploy.sh to EC2..."
                            scp -o StrictHostKeyChecking=no -i $SSH_KEY deploy.sh $EC2_HOST:/home/ubuntu/deploy.sh

                            echo "Running deploy.sh on EC2..."
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_HOST '
                                chmod +x /home/ubuntu/deploy.sh && /home/ubuntu/deploy.sh ${BRANCH_NAME}
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully on branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Deployment failed for branch ${env.BRANCH_NAME}"
        }
    }
}
