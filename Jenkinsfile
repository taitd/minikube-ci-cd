node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "spring-petclinic"
    registryHost = "127.0.0.1:30400/"
    imageName = "${registryHost}${appName}:${tag}"
    env.BUILDIMG=imageName

    stage "Build"
    
        sh  "docker build -t ${imageName} -f applications/spring-petclinic/Dockerfile applications/spring-petclinic"
    
    stage "Push"

        sh "docker push ${imageName}"

    stage "Deploy"

        echo "sed 's#127.0.0.1:30400/spring-petclinic:latest#'$BUILDIMG'#' applications/spring-petclinic/k8s/deployment.yaml | kubectl apply -f -"
        echo "kubectl rollout status deployment/spring-petclinic"
}
