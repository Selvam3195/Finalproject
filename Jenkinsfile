pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials-id'   // matches Jenkins credentials ID
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
                        // Support both Multibranch Pipeline (BRANCH_NAME) and classic Pipeline (GIT_BRANCH)
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
    }
}
stage('Health Check') {
    steps {
        script {
            try {
                sh './check_health.sh'
            } catch (Exception e) {
                // Send Gmail notification if app is down
                emailext (
                    subject: "ALERT: Application is DOWN on EC2",
                    body: "The React app deployed on EC2 at <EC2_PUBLIC_IP>:3000 is not reachable.",
                    to: "selva3195@gmail.com"
                )
                error "Application health check failed!"
            }
        }
    }
}
