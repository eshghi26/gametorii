def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhubcred'
        DOCKERHUB_REPO = 'eshghi26/gametoriapi'
        DOTNET_VERSION = '8.0'  // Specify the version of the .NET SDK you want to use
    }

    stages {
        stage('Install .NET SDK') {
            steps {
                script {
                    // Check if .NET SDK is installed
                    def dotnetVersion = sh(script: 'dotnet --version', returnStatus: true)

                    if (dotnetVersion != 0) {
                        // If .NET SDK is not installed, download and install it
                        echo 'Installing .NET SDK...'
                        sh '''
                        curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel ${DOTNET_VERSION}
                        export PATH="$PATH:$HOME/.dotnet"
                        wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
                        sudo dpkg -i packages-microsoft-prod.deb
                        sudo rm packages-microsoft-prod.deb
                        sudo apt-get update && \
                          sudo apt-get install -y dotnet-sdk-8.0
                        sudo apt-get update && \
                          sudo apt-get install -y aspnetcore-runtime-8.0
                        sudo apt-get install -y dotnet-runtime-8.0
                        sudo apt install zlib1g
                        '''
                    } else {
                        echo '.NET SDK is already installed.'
                    }
                }
            }
        }

        stage('Fetch Code') {
            steps {
                git url: 'git@github.com:eshghi26/gametorii.git',
                branch: 'GameApi',
                credentialsId: 'mygitubpk'
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
                    sh "sudo helm upgrade --install --force api-stack helm/apicharts --namespace gametorispace --recreate-pods"
                }
        }
    }

    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#gametori',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
            // Clean the workspace to remove any temporary files
            cleanWs()
        }
    }

}
