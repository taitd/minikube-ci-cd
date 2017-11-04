
    kubectl apply -f manifests/jenkins.yml

    kubectl exec -it `kubectl get pods --selector=app=jenkins -output=jsonpath={.items..metadata.name}` cat /root/.jenkins/secrets/initialAdminPassword
