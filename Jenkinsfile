pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akramdocker123/mongo-demo'
    }
    stages {
        stage('Clone repository') {
            steps {
                git 'https://github.com/BarriBarri20/mongo-demo'
            }
        }
        stage('Build') {
            steps {
                sh './mvnw clean install'
            }
        }
        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }
        stage('Docker build') {
            steps {
                script {
                    dir('.') {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
                    }
            }
        }
    }
}
