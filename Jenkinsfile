node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "spring-petclinic"
    appNameSonarqube = "sonarqube"
    appNameOracleJava = "docker-oracle-java"
    appNameArtifactory = "artifactory"
    registryHost = "127.0.0.1:30400/"
    imageName = "${registryHost}${appName}:${tag}"
    imageNameOracleJava = "${registryHost}${appNameOracleJava}:${tag}"
    imageNameSonarqube = "${registryHost}${appNameSonarqube}:${tag}"
    imageNameArtifactory = "${registryHost}${appNameArtifactory}:${tag}"
    env.BUILDIMG=imageName
    env.BUILDIMGOracelJava=imageNameOracleJava
    env.BUILDIMGSonarqube=imageNameSonarqube
    env.BUILDIMGArtifactory=imageNameArtifactory

    stage "Build Docker oracle java"
    
        sh  "docker build -t ${imageNameOracleJava} -f applications/docker-oracle-java/Dockerfile applications/docker-oracle-java"
    
    stage "Push oracle java"

        sh "docker push ${imageNameOracleJava}"

    stage "Deploy oracle java"

        sh "sed 's#127.0.0.1:30400/docker-oracle-java:latest#'$BUILDIMGOracleJava'#' applications/docker-oracle-java/k8s/deployment.yml | kubectl apply -f -"
        sh "kubectl rollout status deployment/docker-oracle-java"

    stage "Build Docker sonarqube"
    
        sh  "docker build -t ${imageNameSonarqube} -f applications/sonarqube/Dockerfile applications/sonarqube"
    
    stage "Push sonarqube"

        sh "docker push ${imageNameSonarqube}"

    stage "Deploy sonarqube"

        sh "sed 's#127.0.0.1:30400/sonarqube:latest#'$BUILDIMGSonarqube'#' applications/sonarqube/k8s/deployment.yml | kubectl apply -f -"
        sh "kubectl rollout status deployment/sonarqube"

    stage "Build Docker artifactory"
    
        sh  "docker build -t ${imageNameArtifactory} -f applications/artifactory/Dockerfile applications/artifactory"
    
    stage "Push artifactory"

        sh "docker push ${imageNameArtifactory}"

    stage "Deploy artifactory"

        sh "sed 's#127.0.0.1:30400/artifactory:latest#'$BUILDIMGArtifactory'#' applications/arifactory/k8s/deployment.yaml | kubectl apply -f -"
        sh "kubectl rollout status deployment/artifactory"

    stage "Build application"
    
        sh  "docker build -t ${imageName} -f applications/spring-petclinic/Dockerfile applications/spring-petclinic"
    
    stage "Push"

        sh "docker push ${imageName}"

    stage "Deploy"

        sh "sed 's#127.0.0.1:30400/spring-petclinic:latest#'$BUILDIMG'#' applications/spring-petclinic/k8s/deployment.yaml | kubectl apply -f -"
        sh "kubectl rollout status deployment/spring-petclinic"
}
