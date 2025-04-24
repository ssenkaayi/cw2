pipeline {

  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    IMAGE_NAME = 'ssenkaaayi/cw2-server:1.0'
  }

  stages {

    stage('Checking Git') {
      steps {
        echo 'hello git'
      }
    }

  }
}
