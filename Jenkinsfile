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

            echo "Waiting for container to initialize..."
            sleep 2

            echo "Checking if container is running by executing a command inside..."
            docker exec test-container ps aux

            echo "Stopping and removing test container..."
            docker stop test-container
            docker rm test-container
          '''
        }
      }
    }
  }
}

