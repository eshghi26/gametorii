def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhubcred'
        DOCKERHUB_REPO = 'eshghi26/gametorifront'
    }

    stages {
        stage('Fetch Code') {
            steps {
                git url: 'git@github.com:eshghi26/gametorii.git',
                branch: 'game-frontend',
                credentialsId: 'mygithubpk'
            }
        }

        stage('Install Node.js') {
            steps {
                // Install Node.js using the NodeJS plugin in Jenkins (assuming it's installed)
                // You may also install it manually on the agent machine
                script {
                    def nodejs = tool name: 'NodeJS', type: 'NodeJSInstallation'
                    env.PATH = "${nodejs}/bin:${env.PATH}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install the project dependencies
                sh 'npm install'
            }
        }

        stage('Run Unit Tests') {
            steps {
                // Run unit tests for the Angular app
                sh 'npm test -- --watch=false --code-coverage'
            }
        }

        stage('Build Frontend') {
            steps {
                // Build the production version of the Angular app
                sh 'npm run build -- --prod'
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
                    sh "sudo helm upgrade --install --force front-stack helm/frontcharts --namespace gametorispace"
                }
        }
    }

    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#gametori',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
            // Clean the workspace after the build
            cleanWs()
        }
    }

}
