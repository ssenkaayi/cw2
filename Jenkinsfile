pipeline {

  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    IMAGE_NAME = 'ssenkaaayi/cw2-server:1.0'
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          sh 'docker build -t $IMAGE_NAME .'
        }
      }
    }

    stage('Test Container') {
      steps {
        script {
          sh '''
            echo "Launching container from built image..."
            docker run -d --name test-container $IMAGE_NAME

            sleep 2

            echo "Running test command inside container..."
            docker exec test-container ps aux

            docker stop test-container
            docker rm test-container
          '''
        }
      }
    }

  }
}
