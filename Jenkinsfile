node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "spring-petclinic"
    appNameSonarqube = "sonarqube"
    appNameArtifactory = "artifactory"
    registryHost = "127.0.0.1:30400/"
    imageName = "${registryHost}${appName}:${tag}"
    imageNameSonarqube = "${registryHost}${appNameSonraqube}:${tag}"
    imageNameArtifactory = "${registryHost}${appNameArtifactory}:${tag}"
    env.BUILDIMG=imageName
    env.BUILDIMG=imageNameSonarqube
    env.BUILDIMG=imageNameArtifactory

    stage "Build Docker sonarqube"
    
        sh  "docker build -t ${imageName} -f applications/sonarqube/Dockerfile applications/sonarqube"

    stage "Build Docker artifactory"
    
        sh  "docker build -t ${imageName} -f applications/artifactory/Dockerfile applications/artifactory"

    stage "Build application"
    
        sh  "docker build -t ${imageName} -f applications/spring-petclinic/Dockerfile applications/spring-petclinic"
    
    stage "Push"

        sh "docker push ${imageName}"

    stage "Deploy"

        sh "sed 's#127.0.0.1:30400/spring-petclinic:latest#'$BUILDIMG'#' applications/spring-petclinic/k8s/deployment.yaml | kubectl apply -f -"
        sh "kubectl rollout status deployment/spring-petclinic"
}
