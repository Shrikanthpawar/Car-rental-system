pipeline {
  agent any

  environment {
    IMAGE = "shrikantpawars/car-rental:latest"
    DEPLOY_USER = "ubuntu"               // change to your server user
    DEPLOY_HOST = "44.223.39.76" //
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE .'
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE
          '''
        }
      }
    }

    stage('Deploy to Server') {
      steps {
        // Uses SSH credentials stored in Jenkins as 'deploy-ssh-key'
        sshagent (credentials: ['deploy-ssh-key']) {
          sh '''
            # Commands run on Jenkins agent that use ssh to control remote server
            ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST "
              docker pull $IMAGE &&
              docker stop car-rental-container || true &&
              docker rm car-rental-container || true &&
              docker run -d --name car-rental-container -p 80:80 $IMAGE
            "
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline finished successfully'
    }
    failure {
      echo 'Pipeline failed'
    }
  }
}
