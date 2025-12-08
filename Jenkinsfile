pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = 'sofienezayati/timesheet'
        IMAGE_VERSION = '1.1'
    }
    
    stages {
        stage('GIT') {
            steps {
                echo 'Pulling from GitHub...'
                git branch: 'master',
                    url: 'https://github.com/SofieneZayati/timesheet-project.git'
            }
        }
        
        stage('COMPILATION') {
            steps {
                echo 'Cleaning and compiling...'
                sh 'mvn clean compile'
            }
        }
        
        stage('INSTALLATION') {
            steps {
                echo 'Building JAR...'
                sh 'mvn package -DskipTests'
                
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_VERSION} ."
                
                echo 'Logging into DockerHub.. .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                
                echo 'Pushing to DockerHub...'
                sh "docker push ${DOCKER_IMAGE}:${IMAGE_VERSION}"
            }
        }
        
        stage('DEPLOIEMENT') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh """
                    kubectl set image deployment/timesheet-dep \
                    timesheet=${DOCKER_IMAGE}:${IMAGE_VERSION} \
                    -n chap4
                """
                
                echo 'Checking rollout status...'
                sh 'kubectl rollout status deployment/timesheet-dep -n chap4'
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
