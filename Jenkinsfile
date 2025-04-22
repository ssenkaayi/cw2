pipeline {

  agent any

  environment {

    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    IMAGE_NAME = 'ssenkaaayi/cw2-server:1.0'

  }

  stages {

    stage('Clone Repo') {

      steps {

        git 'https://github.com/ssenkaayi/cw2.git'
      }
    }

    stage('Build Docker Image') {

      steps {
        script {
          sh 'docker build -t $IMAGE_NAME .'
        }
      }
    }
  }
} 
