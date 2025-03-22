node {
    def dockerImageTag = "springboot-demoapp-jenkins:${env.BUILD_NUMBER}"
    def dockerHubImage = "basiljereh/springboot-demoapp-jenkins:${env.BUILD_NUMBER}"
    def platforms = "linux/amd64,linux/arm64"  // Multi-platform support

    try {
        notifyBuild('STARTED')

        stage('Clone Repo') {
            git url: 'https://github.com/basil1120/springboot-demoapp-jenkins.git',
                credentialsId: 'CREDENTIALS_GITHUB',
                branch: 'main'
        }

        stage('Ensure Docker is Available') {
            echo "------- Starting Setting HOME_PATH variables ---------"
            sh 'export PATH=$PATH:/usr/local/bin/docker'
            echo "------- Completing Setting HOME_PATH variables ---------"
        }

        stage('Setup Docker Buildx') {
            script {
                //sh 'docker buildx create --use || true' // Ensure Buildx is enabled
                //sh 'docker buildx inspect --bootstrap'
                sh '/usr/local/bin/docker buildx create --use || true' // Ensure Buildx is enabled
                sh '/usr/local/bin/docker buildx inspect --bootstrap'
            }
        }

        stage('Docker Login - STEP 1') {
            sh 'echo "$DOCKER_PASSWORD" | /usr/local/bin/docker login -u "$DOCKER_USERNAME" --password-stdin'
        }

        /*
        stage('Docker Login - STEP 2') {
            script {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    //sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                    sh "/usr/local/bin/docker login -u $DOCKER_USER -p $DOCKER_PASS"
                }
            }
        }*/
        /*
        stage('Build and Push Docker Image') {
            script {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS',
                usernameVariable: 'DOCKER_USERNAME',
                passwordVariable: 'DOCKER_PASSWORD')]) {

                    // Securely log in without exposing secrets
                    echo "********* Start Login Phase 1 ********* "
                    sh 'echo "$DOCKER_PASSWORD" | /usr/local/bin/docker login -u "$DOCKER_USERNAME" --password-stdin'
                    echo "*********  End Login Phase 1 ********* "

                    echo "---- START Login Phase 2 ----"
                    sh '/usr/local/bin/docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                    echo "---- END Login Phase 2 ----"

                    echo "Building and Pushing Image Name: ${dockerImageTag}"
                    sh """
                    /usr/local/bin/docker buildx build --platform=${platforms} \
                        -t ${dockerImageTag} \
                        -t docker.io/${dockerHubImage} \
                        --push .
                    """
                }
            }
        }*/


        stage('Build and Push Docker Image') {
            script {
                echo "Building Image Name : ${dockerImageTag}"

                echo "************************************************"
                sh 'echo "$DOCKER_USERNAME"'
                sh 'echo "$DOCKER_PASSWORD"'
                echo "************************************************"

                sh 'echo "$DOCKER_PASSWORD" | /usr/local/bin/docker login -u "$DOCKER_USERNAME" --password-stdin'
                sh """
                /usr/local/bin/docker buildx build --platform=${platforms} \
                    -t ${dockerImageTag} \
                    -t docker.io/${dockerHubImage} \
                    --push .
                """
            }
        }

        stage('Deploy Docker Container') {
            script {
                echo "Deploying Docker Image: ${dockerImageTag}"
                sh 'export PATH=$PATH:/usr/local/bin/docker'
                // Stop and remove existing container if running
                sh "docker stop springboot-demoapp-jenkins || true"
                sh "docker rm springboot-demoapp-jenkins || true"

                // Run the new container
                sh """
                docker run --name springboot-demoapp-jenkins -d -p 8181:8181 ${dockerImageTag}
                """
            }
        }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {
        notifyBuild(currentBuild.result)
    }
}

def notifyBuild(String buildStatus = 'STARTED') {
    buildStatus = buildStatus ?: 'SUCCESSFUL'

    def now = new Date()
    def subject_email = "Spring Boot Deployment - ${buildStatus}"
    def details = """<p><strong>Status:</strong> ${buildStatus}</p>
    <p><strong>Job:</strong> ${env.JOB_NAME} - Build [${env.BUILD_NUMBER}]</p>
    <p><strong>Time:</strong> ${now}</p>
    <p>Check console output at <a href="${env.BUILD_URL}">${env.JOB_NAME}</a></p>"""

    emailext(
        to: "basiljereh@gmail.com",
        subject: subject_email,
        body: details,
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}
