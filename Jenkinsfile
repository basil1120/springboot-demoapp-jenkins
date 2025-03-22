node {
    def WORKSPACE = "/var/lib/jenkins/workspace/springboot-demoapp-jenkins"
    def dockerImageTag = "springboot-demoapp-jenkins${env.BUILD_NUMBER}"
try{
    notifyBuild('STARTED')
    stage('Clone Repo') {
        // for display purposes
        // Get some code from a GitHub repository
        git url: 'https://gitlab.com/gpranataAsyst/springboot-demodeploy.git',
            credentialsId: 'springdeploy-user',
            branch: 'main'
     }
    stage('Build docker') {
         dockerImage = docker.build("springboot-demoapp-jenkins:${env.BUILD_NUMBER}")
    }
    stage('Deploy docker'){
          echo "Docker Image Tag Name: ${dockerImageTag}"
          sh "docker stop springboot-demoapp-jenkins || true && docker rm springboot-demoapp-jenkins || true"
          sh "docker run --name springboot-demoapp-jenkins -d -p 8081:8081 springboot-demoapp-jenkins:${env.BUILD_NUMBER}"
    }
}catch(e){
    currentBuild.result = "FAILED"
    throw e
}finally{
    notifyBuild(currentBuild.result)
 }
}