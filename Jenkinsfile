pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-react-app'
        DOCKER_REGISTRY = 'docker.io/rvishrutha'
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
                bat 'docker --version'
                bat 'docker info'
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    bat 'echo %PASSWORD% | docker login -u %USERNAME% --password-stdin'
                    bat "docker tag %DOCKER_IMAGE% %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest"
                    bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    // Use docker-desktop context or change to your desired context
                    bat 'kubectl config use-context docker-desktop --kubeconfig=%KUBECONFIG_FILE%'
                    
                    // Apply deployment and service YAML files
                    bat 'kubectl apply --kubeconfig=%KUBECONFIG_FILE% -f flash-deployment.yaml --validate=false'
                    bat 'kubectl apply --kubeconfig=%KUBECONFIG_FILE% -f flash-service.yaml --validate=false'

                    // Optional: check rollout status
                    bat 'kubectl rollout status deployment/flash-deployment --kubeconfig=%KUBECONFIG_FILE%'
                    
                    // Optional: get pods & services info for logs
                    bat 'kubectl get pods --kubeconfig=%KUBECONFIG_FILE%'
                    bat 'kubectl get svc --kubeconfig=%KUBECONFIG_FILE%'
                }
            }
        }
    }
}
