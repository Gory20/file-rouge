pipeline {
    environment {
        webDockerImageName = "martinez42/ligne-rouge-web"
        dbDockerImageName = "martinez42/ligne-rouge-db"
        registryCredential = 'docker-credentiel'
        KUBECONFIG = "/home/rootkit/.kube/config"
        TERRA_DIR  = "/home/rootkit/ligne-rouge/terraform"
        ANSIBLE_DIR = "/home/rootkit/ligne-rouge/ansible"
    }
    agent any
    stages {
        stage('Checkout Source') {
            steps {
                git 'https://github.com/issa2580/ligne-rouge.git'
            }
        }
        stage('Build Web Docker image') {
            steps {
                script {
                    def webDockerImage = docker.build("${webDockerImageName}", "-f App.Dockerfile .")
                    // Store the image in the environment variable
                    env.webDockerImage = webDockerImage.id
                }
            }
        }
        stage('Build DB Docker image') {
            steps {
                script {
                    def dbDockerImage = docker.build("${dbDockerImageName}", "-f Db.Dockerfile .")
                    // Store the image in the environment variable
                    env.dbDockerImage = dbDockerImage.id
                }
            }
        }
        stage('Pushing Images to Docker Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        def webDockerImage = docker.image(env.webDockerImage)
                        webDockerImage.push('latest')
                        def dbDockerImage = docker.image(env.dbDockerImage)
                        dbDockerImage.push('latest')
                    }
                }
            }
        }
        stage("Provision Kubernetes Cluster with Terraform") {
            steps {
                script {
                    sh """
                    cd ${TERRA_DIR}
                    terraform init
                    terraform plan
                    terraform apply --auto-approve
                    """
                }
            }
        }
        stage('Install Python dependencies and Deploy with Ansible') {
            steps {
                script {
                    sh """
                    sudo apt-get install -y python3-venv
                    cd ${ANSIBLE_DIR}
                    sudo python3 -m venv venv
                    . venv/bin/activate
                    pip install kubernetes ansible
                    ansible-playbook ${ANSIBLE_DIR}/playbook.yml
                    """
                }
            }
        }
    }
 HEAD
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
