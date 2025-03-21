pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akramdocker123/mongo-demo'
        DOCKER_REGISTRY = 'your-docker-registry'
        OPENSHIFT_CLUSTER = 'your-openshift-cluster'
        STAGING_PROJECT = 'your-staging-project'
        PRODUCTION_PROJECT = 'your-production-project'
    }
    stages {
        stage('Clone repository') {
            steps {
                git 'https://github.com/BarriBarri20/mongo-demo'
            }
        }
        stage('SonarQube analysis') {
            steps {
               withSonarQubeEnv(installationName: 'sonarqube jenkins', credentialsId: 'sonar') {
                    sh './mvnw clean package sonar:sonar'
                }
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
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubernetes']) {
                    sh """
                          minikube cache add ${DOCKER_IMAGE}:${env.BUILD_NUMBER}
                          minikube cache reload
                          minikube kubectl -- apply -f ./k8s/spring-deployment.yaml
                          minikube kubectl -- apply -f ./k8s/mongo-deployment.yaml
                    """
                    }
                }
            }
        }
    
        // stage('Deploy MongoDB') {
        //     steps {
        //         script {
        //             withCredentials([usernamePassword(credentialsId: 'mongodb-credentials', usernameVariable: 'MONGODB_USER', passwordVariable: 'MONGODB_PASSWORD')]) {
        //                 openshift.withCluster(OPENSHIFT_CLUSTER) {
        //                     openshift.withProject(STAGING_PROJECT) {
        //                         sh "oc new-app --template=mongodb-persistent --param=MONGODB_USER=${MONGODB_USER} --param=MONGODB_PASSWORD=${MONGODB_PASSWORD} --param=MONGODB_DATABASE=mydatabase --param=MONGODB_ADMIN_PASSWORD=adminpassword"
        //                         def mongodbUrl = sh(script: "oc get svc mongodb -o jsonpath='{.spec.clusterIP}'", returnStdout: true).trim()
        //                         sh "oc set env dc/my-app SPRING_DATA_MONGODB_URI=mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@${mongodbUrl}:27017/mydatabase"
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
        // stage('Deploy to Staging') {
        //     when {
        //         branch 'staging'
        //     }
        //     steps {
        //         script {
        //             openshift.withCluster(OPENSHIFT_CLUSTER) {
        //                 openshift.withProject(STAGING_PROJECT) {
        //                     def app = openshift.newApp("--name=my-app", "${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
        //                     app.rollout().status()
        //                 }
        //             }
        //         }
        //     }
        //     post {
        //         failure {
        //             script {
        //                 openshift.withCluster(OPENSHIFT_CLUSTER) {
        //                     openshift.withProject(STAGING_PROJECT) {
        //                         def app = openshift.selector('dc', 'my-app')
        //                         if (app.exists()) {
        //                             app.rollback().status()
        //                         }
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
        // stage('Deploy to Production') {
        //     when {
        //         branch 'main'
        //     }
        //     steps {
        //         script {
        //             openshift.withCluster(OPENSHIFT_CLUSTER) {
        //                 openshift.withProject(PRODUCTION_PROJECT) {
        //                     def app = openshift.newApp("--name=my-app", "${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
        //                     app.rollout().status()
        //                 }
        //             }
        //         }
        //     }
        // }
        // stage('Post-deployment Tests') {
        //     steps {
        //         script {
        //             sh 'curl -f http://my-app-url.com'
        //         }
        //     }
        // }
        // stage('Cleanup') {
        //     steps {
        //         script {
        //             openshift.withCluster(OPENSHIFT_CLUSTER) {
        //                 openshift.withProject(STAGING_PROJECT) {
        //                     def app = openshift.selector('dc', 'my-app')
        //                     if (app.exists()) {
        //                         app.delete()
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
