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
          echo "Building Docker image..."
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
            docker run -d --name test-container $IMAGE_NAME
            sleep 3
            docker exec test-container ps aux
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
          echo "Pushing image to DockerHub..."
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
          ansiblePlaybook(
            inventory: 'dev.inv',
            playbook: 'deploy_app.yml',
            disableHostKeyChecking: true
            // No need for credentialsId if the private key is already in /var/lib/jenkins/.ssh
          )
        }
      }
    }
  }
}
