pipeline {
  agent any

  environment {
    IMAGE = "shrikantpawars/car-rental:latest"
    DEPLOY_USER = "ubuntu"
    DEPLOY_HOST = "44.223.39.76"     // <-- REPLACE WITH YOUR EC2 PUBLIC IP
    DEPLOY_PORT = "8081"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Image') {
      steps {
        bat """
          docker build -t %IMAGE% .
        """
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                          usernameVariable: 'DOCKER_USER', 
                                          passwordVariable: 'DOCKER_PASS')]) {
          bat """
            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
            docker push %IMAGE%
          """
        }
      }
    }

    stage('Deploy to Server') {
      steps {
        sshagent(['deploy-ssh-key']) {

          bat """
            ssh -o StrictHostKeyChecking=no %DEPLOY_USER%@%DEPLOY_HOST% "docker pull %IMAGE%"
            ssh -o StrictHostKeyChecking=no %DEPLOY_USER%@%DEPLOY_HOST% "docker stop car-rental-container || true"
            ssh -o StrictHostKeyChecking=no %DEPLOY_USER%@%DEPLOY_HOST% "docker rm car-rental-container || true"
            ssh -o StrictHostKeyChecking=no %DEPLOY_USER%@%DEPLOY_HOST% "docker run -d --name car-rental-container -p %DEPLOY_PORT%:80 %IMAGE%"
          """
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline finished successfully"
    }
    failure {
      echo "Pipeline failed"
    }
  }
}
