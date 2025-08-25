pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_DEV_REPO = "cherry3104/react-app-dev"
        DOCKER_PROD_REPO = "cherry3104/react-app-prod"
    }

    triggers {
        githubPush()   // auto-build on GitHub commits
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
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        def branch = env.BRANCH_NAME ?: env.GIT_BRANCH

                        if (branch == "dev" || branch == "origin/dev") {
                            sh "docker tag my-react-app:latest ${DOCKER_DEV_REPO}:latest"
                            sh "docker push ${DOCKER_DEV_REPO}:latest"
                        } else if (branch == "master" || branch == "origin/master" || branch == "main" || branch == "origin/main") {
                            sh "docker tag my-react-app:latest ${DOCKER_PROD_REPO}:latest"
                            sh "docker push ${DOCKER_PROD_REPO}:latest"
                        } else {
                            echo "Branch ${branch} is not configured for Docker push."
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

        stage('Check Application Health') {
            steps {
                script {
                    def result = sh(script: './check_health.sh', returnStatus: true)
                    if (result != 0) {
                        // Mark the build as failed
                        currentBuild.result = 'FAILURE'
                        error("Application is DOWN")
                    } else {
                        echo "Application is UP"
                    }
                }
            }
        }
    }

    post {
        failure {
            // Only send notification if build failed (i.e., app is down)
            mail to: 'selva3195@gmail.com',
                 subject: "Application DOWN on ${env.JOB_NAME}",
                 body: "The application is down. Please check immediately."
        }
    }
}
