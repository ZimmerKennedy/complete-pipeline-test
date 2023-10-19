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
