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

    stage('Push to DockerHub') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
              echo "Logging in to DockerHub..."
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

              echo "Pushing image to DockerHub..."
              docker push $IMAGE_NAME

              echo "Logout from DockerHub..."
              docker logout
            '''
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sshagent(['private-key']) {
          sh '''
            echo "Running Ansible Playbook for Deployment..."
            ansible-playbook -i dev.inv deploy_app.yml
          '''
        }
      }
    }

  }
}
