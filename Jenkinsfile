pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    IMAGE_VERSION = "v${env.BUILD_NUMBER}"
    IMAGE_NAME = "ssenkaaayi/cw2-server:${env.IMAGE_VERSION}"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          echo "Building Docker image: $IMAGE_NAME..."
          try {
            sh '''
              docker build -t $IMAGE_NAME . > docker_build.log 2>&1
              echo "Build complete. Log stored in docker_build.log"
            '''
          } catch (err) {
            error("Docker build failed. Check docker_build.log for details.")
          }
        }
      }
    }

    stage('Test Container') {
      steps {
        script {
          echo "Testing Docker container..."
          sh '''
            if [ "$(docker ps -aq -f name=test-container)" ]; then
              echo "Removing existing container named test-container..."
              docker rm -f test-container
            fi

            docker run -d --name test-container $IMAGE_NAME
            sleep 3
            docker exec test-container ps aux
            echo "---- Container Logs ----"
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
              echo "Image pushed to DockerHub."
            '''
          }
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        script {
          echo "Deploying application with Ansible..."
          writeFile file: 'image_version.txt', text: "$IMAGE_NAME\n"
          ansiblePlaybook(
            inventory: 'dev.inv',
            playbook: 'deploy_app.yml',
            extraVars: [ image_name: IMAGE_NAME ],
            disableHostKeyChecking: true
          )
        }
      }
    }

    stage('Cleanup') {
      steps {
        script {
          echo "Cleaning up local Docker image..."
          sh 'docker rmi $IMAGE_NAME || true'
        }
      }
    }
  }
}
