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
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Debug Docker Hub Connectivity') {
    steps {
        bat 'curl -v https://registry-1.docker.io/v2/'
          }
        }


        stage('Push Docker Image to Docker Hub') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            bat """
                echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin
                docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
            """
        }
    }
}

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    bat 'kubectl config use-context minikube --kubeconfig=%KUBECONFIG_FILE%'
                    bat 'kubectl apply --kubeconfig=%KUBECONFIG_FILE% -f flash-deployment.yaml'
                    bat 'kubectl apply --kubeconfig=%KUBECONFIG_FILE% -f flash-service.yaml'
                }
            }
        }
    }
}
