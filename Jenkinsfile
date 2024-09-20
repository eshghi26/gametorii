def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhubcred'
        DOCKERHUB_REPO = 'eshghi26/gametoriapi'
    }

    stages {
        stage('Fetch Code') {
            steps {
                git url: 'git@github.com:eshghi26/gametori.git',
                branch: 'main',
                credentialsId: 'mygithubpk'
            }
        }

        stage('Build Docker Image'){
            steps {
                script {
                    dockerImage = docker.build( DOCKERHUB_REPO + ":V$BUILD_NUMBER", "./src/GameApi")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push("V$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Delete Image from Jenkins') {
            steps {
                sh "docker rmi $DOCKERHUB_REPO:V$BUILD_NUMBER $DOCKERHUB_REPO:latest"
            }
        }

        stage('Deploy to Kubernetes') {
            agent {label 'KOPS'}
                steps {
                    sh "sudo helm upgrade --install --force db-stack helm/dbcharts --namespace gametorispace"
                }
        }
    }

    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#gametori',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }

}
