pipeline {
    environment {
        webDockerImageName = "gorysow/ligne-rouge-web"
        dbDockerImageName = "gorysow/ligne-rouge-db"
        webDockerImage = ""
        dbDockerImage = ""
        registryCredential = 'docker-secret'
    }
    agent any
    stages {
        stage('Checkout Source') {
            steps {
                git 'https://github.com/Gory20/file-rouge.git'
            }
        }
        stage('Build Web Docker image') {
            steps {
                script {
                    webDockerImage = docker.build webDockerImageName, "-f App.Dockerfile ."
                }
            }
        }
        stage('Build DB Docker image') {
            steps {
                script {
                    dbDockerImage = docker.build dbDockerImageName, "-f Db.Dockerfile ."
                }
            }
        }
        stage('Pushing Images to Docker Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        webDockerImage.push('latest')
                        dbDockerImage.push('latest')
                    }
                }
            }
        }
        stage('Deploying to kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'tsts-secret', variable: 'KUBECONFIG')]) {
                    script {
                        sh 'kubectl apply -f db-deployment.yml --kubeconfig=${KUBECONFIG} --validate=false'
                        sh 'kubectl apply -f app-deployment.yml --kubeconfig=${KUBECONFIG} --validate=false'
                    }
                }
            }
        }
    }
}