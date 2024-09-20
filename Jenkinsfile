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
                git url: 'git@github.com:eshghi26/gametorii.git',
                branch: 'GameApi',
                credentialsId: 'mygithubpk'
            }
        }

        stage('Restore Dependencies') {
            steps {
                // Restore the project dependencies
                sh 'dotnet restore'
            }
        }

        stage('build') {
            steps {
                // Build the API project
                sh 'dotnet build --configuration Release'
            }
        }

        stage('Unit Tests') {
            steps {
                // Run unit tests
                sh 'dotnet test --no-build --verbosity normal'
            }
        }

        stage('Integration Tests') {
            steps {
                // Optionally run integration tests (if you have separate test projects for integration tests)
                // sh 'dotnet test ./Tests/IntegrationTests/IntegrationTests.csproj --no-build --verbosity normal'
                echo 'Integration tests step (implement if necessary)'
            }
        }

        stage('Publish') {
            steps {
                // Publish the API for deployment
                sh 'dotnet publish -c Release -o ./publish'
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
                    sh "sudo helm upgrade --install --force api-stack helm/apicharts --namespace gametorispace"
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
