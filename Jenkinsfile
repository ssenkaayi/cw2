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
          sh 'docker build -t $IMAGE_NAME .'
        }
      }
    }

    stage('Test Container') {
      steps {
        script {
          echo "Launching container from built image..."
          sh '''
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
          echo "Pushing image to DockerHub..."
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
          echo "Deploying application with Ansible..."
          ansiblePlaybook(
            disableHostKeyChecking: true,  // Disable host key checking if necessary (may improve security)
            installation: 'ansible',  // Ensure Ansible is installed and configured in Jenkins
            inventory: 'dev.inv',  // Path to your Ansible inventory file
            playbook: 'deploy_app.yml',  // Path to your Ansible playbook for deployment
            vaultTmpPath: ''  // Adjust if you use Ansible Vault for secrets management
          )
        }
      }
    }
  }
}
