def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhubcred'
        DOCKERHUB_REPO = 'eshghi26/gametoripanel'
    }

    stages {
        stage('Fetch Code') {
            steps {
                git url: 'git@github.com:eshghi26/gametorii.git',
                branch: 'admin-panel',
                credentialsId: 'mygithubpk'
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    // Check if npm is installed
                    def npmVersion = sh(script: 'npm --version', returnStatus: true)

                    if (npmVersion != 0) {
                        // If npm is not installed, download and install it
                        echo 'Installing NodeJS and npm...'
                        sh '''
                        sudo apt update -y
                        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                        sudo apt-get install -y nodejs
                        node -v
                        npm --version
                        sudo npm install -g npm@10
                        node -v
                        npm -v
                        '''
                    } else {
                        echo 'NodeJS and npm are already installed.'
                    }
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
                sh 'npm test -- --watch=false --browsers=ChromeHeadless'
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
                    sh "sudo helm upgrade --install --force panel-stack helm/panelcharts --namespace gametorispace"
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
