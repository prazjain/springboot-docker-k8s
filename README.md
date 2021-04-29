# Readme

## Run with docker

Building a docker image  
`docker build -t springboot-docker-k8s .`  
Tag image with full name to upload to docker hub repository  
`docker tag springboot-docker-k8s prashant4life/springboot-docker-k8s`  
List the newly created images  
`docker images`  
Push new image to docker hub repository  
`docker push prashant4life/springboot-docker-k8s`  
Remove the image from local images (we will fetch it from hub)  
`docker rmi -f prashant4life/springboot-docker-k8s`  
Fetch docker image from docker hub and run in local container  
`docker run --name springboot-docker-k8s -p 8080:8080 -d prashant4life/springboot-docker-k8s:latest`  

---

## Run on Kubernetes

Create a k8s configuration yaml file 'docker-k8s.yaml'  
https://static.brandonpotter.com/kubernetes/DeploymentBuilder.html  
Upload the file to kubernetes cluster (lets say google cloud), then run below command to start container  
`kubectl apply -f release-docker-k8s.yaml`  
Steps to expose port on Google K8s cluster https://www.youtube.com/watch?v=SzbeDqBSRkc  

Below are steps to run the app in local k8s cluster using commands:  

---

## Run on Kubernetes using Minikube

Install Minikube  
- Start minikube (by default starts with docker driver  
`minikube start`  
- Start minikube with Virtual box driver (to have mounted files from file system)  
`minikube start --driver=virtualbox --cpus 4 --memory 8196`  
- Login to minikube cluster, to build docker image
`minikube ssh`  
`cd \navigate\to\project\springboot-docker-k8s`  
`docker build . --tag=springboot-docker-k8s`  
`exit`  
- Run the application  
`kubectl run springboot-docker-k8s --image=springboot-docker-k8s --port=8080 --image-pull-policy Never`  
- Check the deployment was successful  
`kubectl get deployments`  
- Get Pod id, and check the logs for the pod  
`kubectl get pods`  
`kubectl logs <pod id>`  
- Create Service and expose external endpoint  
`kubectl expose deployment springboot-docker-k8s --type=NodePort`  
- Verify the service was created successfully, and check the port it is exposed on  
`kubectl get services`  
- Invoke the endpoint in browser (this will give info about service and also invoke it in browser)  
`minikube service springboot-docker-k8s`  
- Cleaning up Service and Deployment  
`kubectl delete service springboot-docker-k8s`  
`kubectl delete deployment springboot-docker-k8s`  

The application can also be run locally by adding all above setup into a yaml file (local-docker-k8s.yaml) and running it:  
`kubectl apply -f local-docker-k8s.yaml`  

---

## Run on kubernetes minikube and deploying with Skaffold

Deploy using Skaffold  
`brew install skaffold`  
Create default skaffold file based on existing DockerFile  
`skaffold init -f skaffold.yaml`  
`skaffold build` to build our application  
`skaffold deploy` to deploy our application  
`skaffold run` to build and deploy  
`skaffold dev` to enter development mode, with auto-deploy  
`mvn clean package` for hot swap using Skaffold, rebuild the project to re-create new jar, and `skaffold dev` will pick up the change.   
`skaffold run --tail` to get logs  

More info on how to build docker file from maven: https://medium.com/swlh/build-a-docker-image-using-maven-and-spring-boot-58147045a400  

---

## Deploy on Kubernetes using Helm

Using Helm with Spring boot  
https://jhooq.com/building-first-helm-chart-with-spring-boot/  

* Install Helm  
`brew install helm`  
* Setup helm in project  
`helm create springboot-docker-k8s`  
* Install tree  
`brew install tree`  
* Check dir structure  
`tree springboot-docker-k8s`  
This will create a directory structure as below inside project directory:
```
    springboot-docker-k8s
    ├── Chart.yaml
    ├── charts
    ├── templates
    │   ├── NOTES.txt
    │   ├── _helpers.tpl
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   ├── serviceaccount.yaml
    │   └── tests
    │       └── test-connection.yaml
    └── values.yaml
```
The new files created by helm do not conflict with any of the existing yamls so far.  

* Add `target/` dir in `.helmignore` file, so helm chart will not be bloated, else you will get error like :  
```
Error: create: failed to create: Request entity too large: limit is 3145728
```

* Navigate one level above the project dir, and run below commands  
`helm lint springboot-docker-k8s`  # to check for any failure  
`helm install myhelmspringboot-docker-k8s --debug --dry-run springboot-docker-k8s`  # to check for any failures  
`helm package springboot-docker-k8s`  # to create tar file  
`helm install myhelm-springboot-docker-k8s springboot-docker-k8s`  # to install helm package  
`helm list -a`  # to verify helm install  
`kubectl get all`  # to see that helm has done its work  
Execute the commands you see at the end of install command, and see your live application    
```
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=springboot-docker-k8s,app.kubernetes.io/instance=myhelm-springboot-docker-k8s" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
echo "Visit http://127.0.0.1:8080 to use your application"
```
In our case visit  
`http://localhost:8080/`  
`http://localhost:8080/api/hello`  

---
