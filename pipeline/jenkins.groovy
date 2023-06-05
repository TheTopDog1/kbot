pipeline {
    agent any
    environment{
        REPO = 'https://github.com/TheTopDog1/kbot'
        BRANCH = 'main'
    }
    parameters {
        choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Operational system')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Architecture of processor')
    }
    stages {
        stage('clone') {
            steps {
                echo 'CLONE REPOSITORY'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        stage('test') {
            steps {
                echo 'TEST EXECUTION STARTED'
                sh 'make test'
            }
        }
        stage('build') {
            steps {
                echo 'BUILD EXECUTION STARTED'
                sh 'make build'
            }
        }
        stage('image') {
            steps {
                echo 'IMAGE EXECUTION STARTED'
                sh 'make image'
            }
        }
        stage('push') {
            steps {
                script{
                    docker.withRegistry('','dockerhub'){
                        sh 'make push'
                    }
                }
            }
        }
    }
}