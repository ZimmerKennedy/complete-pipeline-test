pipeline {
    agent any
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
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-webhook'
                }
            }
        }
        stage('Upload Artifact to Nexus'){
            steps {
                script {
                    nexusArtifactUploader artifacts: [[artifactId: 'complete-pipeline', classifier: '', file: 'target/spring-boot-web.jar', type: 'jar']], credentialsId: 'nexus-auth', groupId: 'com.complete-pipeline', nexusUrl: '20.62.5.145:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'complete-pipeline-nexus', version: '0.0.1-SNAPSHOT'
                }
            }
        }
    }
    post {
        success {
            echo 'Build successful!'
            archiveArtifacts 'target/*.jar' // Adjust path for artifacts
        }
        failure {
            echo 'Build failed!'
        }
    }
}
