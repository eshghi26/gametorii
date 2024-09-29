def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhubcred'
        DOCKERHUB_REPO = 'eshghi26/gametoridb'
    }

    stages {
        stage('Fetch Code') {
            steps {
                git url: 'git@github.com:eshghi26/gametorii.git',
                branch: 'DB',
                credentialsId: 'mygitubpk'
            }
        }

        stage('Build Docker Image'){
            steps {
                script {
                    dockerImage = docker.build( DOCKERHUB_REPO + ":V$BUILD_NUMBER", "./")
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
                    sh "sudo helm upgrade --install --force postgresql-stack helm/dbcharts --namespace gametorispace --recreate-pods"
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
