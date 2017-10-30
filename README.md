
minikube stop
Stopping local Kubernetes cluster...
Machine stopped.

Clear out Minikube
Let’s get rid of the leftovers from any previous experiments you might have conducted with Minikube. Enter the following terminal command:

minikube delete; sudo rm -rf ~/.minikube; sudo rm -rf ~/.kube
Deleting local Kubernetes cluster...
Machine deleted.

1. Start up the Kubernetes cluster with Minikube, giving it some extra resources.
minikube start --memory 8000 --cpus 2 

docker stop socat-registry; docker rm socat-registry 
docker run -d -e "REGIP=`minikube ip`" --name socat-registry -p 30400:5000 chadmoon/socat:latest bash -c "socat TCP4-LISTEN:5000,fork,reuseaddr TCP4:`minikube ip`:30400"

kubectl apply -f manifests/jenkins.yml 
kubectl rollout status deployment/jenkins
minikube service jenkins
kubectl exec -it `kubectl get pods --selector=app=jenkins --output=jsonpath={.items..metadata.name}` cat /root/.jenkins/secrets/initialAdminPassword

#https://hub.docker.com/r/anthonydahanne/spring-petclinic/~/dockerfile/
docker build -t 127.0.0.1:30400/spring-petclinic:latest -f applications/spring-petclinic/Dockerfile applications/spring-petclinic
docker push 127.0.0.1:30400/spring-petclinic


