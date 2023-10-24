pipeline {
    agent any
    // important to declare tools i.e maven
    tools {
        maven 'maven'
    }
    stages {
        stage('Checkout, Build and Package') {
            steps {
                checkout scm
                    sh 'mvn clean package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                    script {
                        def scannerHome = tool 'SonarQube-Scanner'
                        withSonarQubeEnv() {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=complete-pipeline-test -Dsonar.sources=. -Dsonar.java.binaries=target/classes"
                    }
                }
            }
        }
        stage('Quality Gate Status'){
        // credentialsId must match your SonarQube Token Webhook    
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-webhook'
                }
            }
        }
        stage('Upload Artifact to Nexus'){
        // This Script is Generated Automatically from Jenkins Nexus Artifact Generator
            steps {
                script {
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'complete-pipeline', 
                            classifier: '', 
                            file: 'target/spring-boot-web.jar', 
                            type: 'jar'
                        ]
                    ], 
                    credentialsId: 'nexus-auth', 
                    groupId: 'com.complete-pipeline', 
                    nexusUrl: '20.62.5.145:8081', 
                    nexusVersion: 'nexus3',
                    protocol: 'http', 
                    repository: 'complete-pipeline-nexus', 
                    version: '0.0.1-SNAPSHOT'
                }
            }
        }
        stage('Docker Image Build'){
            steps {
                script {
                    withDockerRegistry(credentialsId: 'jenkins-auth', toolName: 'docker-jenkins') {
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID zimmerkennedy/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID zimmerkennedy/$JOB_NAME:v1.latest'
                    sh 'docker push zimmerkennedy/$JOB_NAME:v1.$BUILD_ID'
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Build successful!'
            archiveArtifacts 'target/*.jar'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
