pipeline {
    agent any

    environment {
        dockerhubcredentials = credentials('dockerhub-credentials-id')
        DOCKER_DEV_REPO = "cherry3104/react-app-dev"
        DOCKER_PROD_REPO = "cherry3104/react-app-prod"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', dockerhubcredentials) {
                        if (env.BRANCH_NAME == "dev") {
                            sh "docker tag my-react-app:latest ${DOCKER_DEV_REPO}:latest"
                            sh "docker push ${DOCKER_DEV_REPO}:latest"
                        } else if (env.BRANCH_NAME == "master") {
                            sh "docker tag my-react-app:latest ${DOCKER_PROD_REPO}:latest"
                            sh "docker push ${DOCKER_PROD_REPO}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
    }
}
