pipeline {
    agent any

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
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
    }
}
