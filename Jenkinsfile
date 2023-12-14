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
                script {
                    def scannerHome = tool 'SonarQube Scanner';
                    withSonarQubeEnv('My SonarQube Server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                sh "./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_REGISTRY_PASSWORD')]) {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", DOCKER_REGISTRY_PASSWORD) {
                            sh "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                        }
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
