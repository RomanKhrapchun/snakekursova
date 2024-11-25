pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE_NAME = 'romankhrapchnun/snakekursova'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out the code...'
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                sh '''
                    docker build -t $DOCKER_IMAGE_NAME .
                '''
            }
        }
        stage('Test Docker Image') {
            steps {
                echo 'Running tests in Docker container...'
                // Тести можуть бути специфічними для проекту. Якщо у вас є окремий скрипт для тестування,
                // наприклад run_tests.sh, скористайтеся ним. Або тестування може включати запуск програми.
                sh '''
                    docker run --rm $DOCKER_IMAGE_NAME ./snake --test
                '''
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                sh '''
                    echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                    docker push $DOCKER_IMAGE_NAME
                    docker logout
                '''
            }
        }
        stage('Run Container and Collect Output') {
            steps {
                echo 'Running Docker container to generate output files...'
                // Якщо програма створює вихідні файли, вкажіть директорію для їх збереження
                sh '''
                    mkdir -p output
                    docker run --rm -v $(pwd)/output:/app/output $DOCKER_IMAGE_NAME
                '''
            }
        }
        stage('Upload Output Files to S3') {
            steps {
                echo 'Uploading output files to S3...'
                withAWS(credentials: 'aws-credentials', region: 'eu-north-1') {
                    s3Upload(bucket: 'jenkins-sonarqube-builds-k1z6vsfz', file: 'output/', path: 'artifacts/output/')
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline завершено успішно!'
        }
        failure {
            echo 'Pipeline завершено з помилкою.'
        }
    }
}