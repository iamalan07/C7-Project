@Library('github.com/releaseworks/jenkinslib') _
pipeline {
    agent any
    environment {
        registry = "653477810149.dkr.ecr.us-east-1.amazonaws.com/c7"
    }
   
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/iamalan07/C7-Project.git']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{
     withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
   
         script {
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 653477810149.dkr.ecr.us-east-1.amazonaws.com/c7 '   
                sh 'docker push 653477810149.dkr.ecr.us-east-1.amazonaws.com/c7'
             }
            }
          }
      }
        
        
    stage('Docker Run') {
     steps{
         script {          
                sh 'ssh -i /finalproject.pem ubuntu@10.0.2.24'
                sh 'docker run -d -p 8080:8080 653477810149.dkr.ecr.us-east-1.amazonaws.com/c7'
                 } 
            }
      }
    }
    }
