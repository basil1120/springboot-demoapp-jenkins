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

        stage('Clean Up Docker System') {
            script {
                // Capture output of docker system prune
                def systemPruneOutput = sh(script: '/usr/local/bin/docker system prune -f', returnStdout: true).trim()
                echo "Docker System Prune Output:\n${systemPruneOutput}"

                // Extract reclaimed space from the output
                def reclaimedSpaceSystem = extractReclaimedSpace(systemPruneOutput)
                echo "Reclaimed space from Docker System Prune: ${reclaimedSpaceSystem}"

                // Capture output of docker builder prune
                def builderPruneOutput = sh(script: '/usr/local/bin/docker builder prune -f', returnStdout: true).trim()
                echo "Docker Builder Prune Output:\n${builderPruneOutput}"

                // Extract reclaimed space from the output
                def reclaimedSpaceBuilder = extractReclaimedSpace(builderPruneOutput)
                echo "Reclaimed space from Docker Builder Prune: ${reclaimedSpaceBuilder}"

                // Calculate total reclaimed space
                def totalReclaimedSpace = reclaimedSpaceSystem + reclaimedSpaceBuilder
                echo "Total reclaimed disk space: ${totalReclaimedSpace}"
            }
        }

        stage('Setup Docker Buildx') {
            script {
                sh '/usr/local/bin/docker buildx create --use || true'
                sh '/usr/local/bin/docker buildx inspect --bootstrap'
                sh '/usr/local/bin/docker buildx ls' // Debug: List builders
            }
        }

        stage('Docker Login - STEP 1') {
            sh 'echo "$DOCKER_PASSWORD" | /usr/local/bin/docker login -u "$DOCKER_USERNAME" --password-stdin'
            sh '/usr/local/bin/docker info' // Debug: Verify login
        }

        stage('Build and Push Docker Image') {
            script {
                echo "Building Image Name : ${dockerImageTag}"

                echo "************************************************"
                sh 'echo "$DOCKER_USERNAME"'
                sh 'echo "$DOCKER_PASSWORD"'
                echo "************************************************"

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

        stage('Post-Build Cleanup') {
            script {
                // Capture output of docker system prune
                def systemPruneOutput = sh(script: '/usr/local/bin/docker system prune -f', returnStdout: true).trim()
                echo "Docker System Prune Output:\n${systemPruneOutput}"

                // Extract reclaimed space from the output
                def reclaimedSpaceSystem = extractReclaimedSpace(systemPruneOutput)
                echo "Reclaimed space from Docker System Prune: ${reclaimedSpaceSystem}"

                // Capture output of docker builder prune
                def builderPruneOutput = sh(script: '/usr/local/bin/docker builder prune -f', returnStdout: true).trim()
                echo "Docker Builder Prune Output:\n${builderPruneOutput}"

                // Extract reclaimed space from the output
                def reclaimedSpaceBuilder = extractReclaimedSpace(builderPruneOutput)
                echo "Reclaimed space from Docker Builder Prune: ${reclaimedSpaceBuilder}"

                // Calculate total reclaimed space
                def totalReclaimedSpace = reclaimedSpaceSystem + reclaimedSpaceBuilder
                echo "Total reclaimed disk space: ${totalReclaimedSpace}"
            }
        }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {
        notifyBuild(currentBuild.result)
    }
}

// Helper function to extract reclaimed space from prune output
def extractReclaimedSpace(String output) {
    def reclaimedSpace = 0
    def match = output =~ /Total reclaimed space:\s+([\d.]+)\s*(\w+)/
    if (match) {
        def size = match[0][1].toFloat()
        def unit = match[0][2]
        // Convert to bytes for consistency
        switch (unit.toLowerCase()) {
            case "kb":
                reclaimedSpace = size * 1024
                break
            case "mb":
                reclaimedSpace = size * 1024 * 1024
                break
            case "gb":
                reclaimedSpace = size * 1024 * 1024 * 1024
                break
            default:
                reclaimedSpace = size // Assume bytes
                break
        }
    }
    return reclaimedSpace
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