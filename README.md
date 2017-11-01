-------------
# Minikube CI/CD

The minikube-ci-cd project showcases Kubernetes features like compiling java, creating .war, sonarqube, artifactory, spinning up multiple pods and running a load test at scale. 
It also features Sonarqube, Artifactory and Jenkins running on its own a container and a JenkinsFile script to demonstrate how Kubernetes can be integrated into a full CI/CD pipeline. 

To get it up and running, simply follow the directions below. 

#### 1

`minikube start --memory 8000 --cpus 2 --kubernetes-version v1.8.0`

#### 2

Wait 20 seconds, and then view the Minikube Dashboard, a web UI for managing deployments.

`sleep 20; minikube service kubernetes-dashboard --namespace kube-system`

#### 3

Deploy the public nginx image from DockerHub into a pod. Nginx is an open source web server that will automatically download from Docker Hub if it’s not available locally.

`kubectl run nginx --image nginx --port 80`

#### 4

Create a service for deployment. This will expose the nginx pod so you can access it with a web browser.

`kubectl expose deployment nginx --type NodePort --port 80`

#### 5

Launch a web browser to test the service. The nginx welcome page displays, which means the service is up and running.

`minikube service nginx`

#### 6

Set up the cluster registry by applying a .yml manifest file.

`kubectl apply -f manifests/registry.yml`

#### 7

Wait for the registry to finish deploying. Note that this may take several minutes.

`kubectl rollout status deployments/registry`

#### 8

View the registry user interface in a web browser.

`minikube service registry-ui`

#### 9

Now let’s build an image, giving it a special name that points to our local cluster registry.

 docker build -t 127.0.0.1:30400/spring-petclinic:latest -f applications/spring-petclinic/Dockerfile applications/spring-petclinic

#### 10

We’ve built the image, but before we can push it to the registry, we need to set up a temporary proxy. By default the Docker client can only push to HTTP (not HTTPS) via localhost. To work around this, we’ll set up a container that listens on 127.0.0.1:30400 and forwards to our cluster.

 docker stop socat-registry; docker rm socat-registry; docker run -d -e "REGIP=`minikube ip`" --name socat-registry -p 30400:5000 chadmoon/socat:latest bash -c "socat TCP4-LISTEN:5000,fork,reuseaddr TCP4:`minikube ip`:30400"

With our proxy container up and running, we can now push our image to the local repository.

 docker push 127.0.0.1:30400/spring-petclinic

#### 11

The proxy’s work is done, so you can go ahead and stop it.

`docker stop socat-registry;`

#### 12

Install Jenkins, which we’ll use to create our automated CI/CD pipeline. It will take the pod a minute or two to roll out.

`kubectl apply -f manifests/jenkins.yml; kubectl rollout status deployment/jenkins`

#### 13

Open the Jenkins UI in a web browser.

`minikube service jenkins`

#### 14

Display the Jenkins admin password with the following command, and right-click to copy it. IMPORTANT: BE CAREFUL NOT TO PRESS CTRL-C TO COPY THE PASSWORD AS THIS WILL STOP THE SCRIPT.

`kubectl exec -it `kubectl get pods --selector=app=jenkins --output=jsonpath={.items..metadata.name}` cat /root/.jenkins/secrets/initialAdminPassword`

#### 15

Switch back to the Jenkins UI. Paste the Jenkins admin password in the box and click Continue. Click Install suggested plugins and wait for the process to complete.

`echo ''`

#### 16

Create an admin user and credentials, and click Save and Finish. (Make sure to remember these credentials as you will need them for repeated logins.) Click Start using Jenkins.

`echo ''`

#### 17

We now want to create a new pipeline for use with our Hello-Kenzan app. On the left, click New Item. Enter the item name as "Hello-Kenzan Pipeline", select Pipeline, and click OK.

`echo ''`

#### 18

Under the Pipeline section at the bottom, change the Definition to be "Pipeline script from SCM".

`echo ''`

#### 19

Change the SCM to Git.

`echo ''`

#### 20

Change the Repository URL to be the URL of your forked Git repository, such as https://github.com/[GIT USERNAME]/minikube-ci-cd. Click Save. On the left, click Build Now to run the new pipeline.

`echo ''`

#### 21

Set up a proxy so we can push the spring-petclinic Docker image we just built to our cluster's registry.

`docker stop socat-registry; docker rm socat-registry; docker run -d -e "REGIP=`minikube ip`" --name socat-registry -p 30400:5000 chadmoon/socat:latest bash -c "socat TCP4-LISTEN:5000,fork,reuseaddr TCP4:`minikube ip`:30400"`

#### 22

Push the spring-petclinic image to the registry.

`docker push 127.0.0.1:30400/spring-petclinic:`git rev-parse --short HEAD``

#### 23

The proxy’s work is done, so go ahead and stop it.

`docker stop socat-registry`

#### 24

Open the registry UI and verify that the spring-petclinic image is in our local registry.

`minikube service registry-ui`

#### 25

Create the spring-petclinic deployment and service.

`sed 's#127.0.0.1:30400/spring-petclinic:latest#127.0.0.1:30400/spring-petclinic:'`git rev-parse --short HEAD`'#' applications/spring-petclinic/k8s/deployment.yaml | kubectl apply -f -`

#### 26

Wait for the spring-petclinic deployment to finish.

`kubectl rollout status deployment/spring-petclinic`

#### 27

View pods to see the spring-petclinic pod running.

`kubectl get pods`

#### 28

View services to see the spring-petclinic service.

`kubectl get services`

#### 29

View ingress rules to see the spring-petclinic ingress rule.

`kubectl get ingress`

#### 30

View deployments to see the spring-petclinic deployment.

`kubectl get deployments`

#### 31

Check to see if the frontend has been deployed.

`kubectl rollout status deployment/spring-petclinic`

#### 32

Check out all the pods that are running.

`kubectl get pods`

#### 33

Enter the following command to open the Jenkins UI in a web browser. Log in to Jenkins using the username and password you previously set up.

`minikube service jenkins`

#### 34

We’ll want to create a new pipeline for the spring-petclinic service that we previously deployed. On the left in Jenkins, click New Item.

`echo ''`

#### 35

Enter the item name as "spring-petclinic", click Pipeline, and click OK.

`echo ''`

#### 36

Under the Build Triggers section, select Poll SCM. For the Schedule, enter the the string H/5 * * * * which will poll the Git repo every 5 minutes for changes.

`echo ''`

#### 37

In the Pipeline section, change the Definition to "Pipeline script from SCM". Set the SCM property to GIT. Set the Repository URL to your forked repo (created earlier), such as https://github.com/[GIT USERNAME]/minikube-ci-cd.git. Set the Script Path to applications/puzzle/Jenkinsfile


Commit and push the change to your forked Git repo.

`echo ''`

#### Step11

In Jenkins, open up the spring-petstore pipeline and wait until it triggers a build. It should trigger every 5 minutes.

 ## LICENSE
Copyright 2017 Nanite Software Ltd, LLC <http://nanitesoftware.co.uk>
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
    http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

