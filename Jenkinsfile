pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-frontend-app'   // your Docker image name
        DOCKER_REGISTRY = 'docker.io/rvishrutha'   // replace with your Docker Hub username
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/r-vishrutha/devops.git', credentialsId: 'github-token'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    bat 'echo %PASSWORD% | docker login -u %USERNAME% --password-stdin'
                    bat "docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                    bat "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy Locally') {
            steps {
                bat 'deploy.bat'
            }
        }
    }
}
