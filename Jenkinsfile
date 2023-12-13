pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akramdocker123/mongo-demo'
        OPENSHIFT_PROJECT = 'my-project'
        MONGODB_USER = 'my-user'
        MONGODB_PASSWORD = 'my-password'
        MONGODB_DATABASE = 'my-database'
        SPRING_DATA_MONGODB_URI = "mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@mongodb:27017/${MONGODB_DATABASE}"
    }
    stages {
      gra  stage('Clone repository') {
            steps {
                git 'https://github.com/BarriBarri20/mongo-demo'
            }
        }
        stage('Build') {
            steps {
                sh "./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
            }
        }
        stage('Test') {
            steps {
                sh './mvnw test'
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
        stage('Deploy MongoDB to OpenShift') {
            steps {
                script {
                    openshift.withCluster('my-cluster') {
                        openshift.withProject(OPENSHIFT_PROJECT) {
                            openshift.newApp('mongodb-persistent', '-p', "MONGODB_USER=${MONGODB_USER},MONGODB_PASSWORD=${MONGODB_PASSWORD},MONGODB_DATABASE=${MONGODB_DATABASE}")
                        }
                    }
                }
            }
        }
        stage('Deploy to OpenShift') {
            steps {
                script {
                    openshift.withCluster('my-cluster') {
                        openshift.withProject(OPENSHIFT_PROJECT) {
                            def app = openshift.newApp("${DOCKER_IMAGE}:${env.BUILD_NUMBER}", '-e', "SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}")
                            app.rollout().status()
                        }
                    }
                }
            }
        }
        stage('Check Volume Persistence') {
            steps {
                script {
                    openshift.withCluster('my-cluster') {
                        openshift.withProject(OPENSHIFT_PROJECT) {
                            def pvc = openshift.selector('pvc', 'my-pvc')
                            if (pvc.exists() && pvc.object().status.phase == 'Bound') {
                                echo 'Volume is persistent'
                            } else {
                                error 'Volume is not persistent'
                            }
                        }
                    }
                }
            }
        }
    }
}
