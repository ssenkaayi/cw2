pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    IMAGE_VERSION = "v${BUILD_NUMBER}"
    IMAGE_NAME = "ssenkaaayi/cw2-server:${IMAGE_VERSION}"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          echo "Building Docker image: $IMAGE_NAME..."
          sh '''
            docker build -t $IMAGE_NAME . > docker_build.log 2>&1
            echo "Build complete. Log stored in docker_build.log"
          '''
        }
      }
    }

    stage('Test Container') {
      steps {
        script {
          echo "Testing Docker container..."
          sh '''
            if [ "$(docker ps -aq -f name=test-container)" ]; then
              docker rm -f test-container
            fi

            docker run -d --name test-container $IMAGE_NAME
            sleep 3
            docker exec test-container ps aux
            docker logs test-container
            docker stop test-container
            docker rm test-container
            echo "Container tested and removed."
          '''
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          echo "Pushing image $IMAGE_NAME to DockerHub..."
          withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push $IMAGE_NAME
              docker logout
            '''
          }
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        script {
          echo "Deploying application using Ansible with IMAGE: $IMAGE_NAME..."
          ansiblePlaybook(
            inventory: 'dev.inv',
            playbook: 'deploy_app.yml',
            disableHostKeyChecking: true,
            extraVars: [
              image_name: "${IMAGE_NAME}"
            ]
          )
        }
      }
    }
  }
}
