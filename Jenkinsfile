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
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }




        stage('Build Docker Compose') {
            steps {
                // Build your Docker Compose setup
                sh 'docker-compose build'
            }
        }

        stage('Up Docker Compose') {
            steps {
                // Start your Docker Compose setup
                sh 'docker-compose up -d'
            }
        }

        stage('Check Volume Persistence') {
            steps {
                // Run a command that checks volume persistence
                // Replace this with the actual command you want to run
                sh 'docker inspect mongodb_data_container'
            }
        }
    }

    post {
        always {
            // Stop your Docker Compose setup
            sh 'docker-compose down'
        }
    }

    }

