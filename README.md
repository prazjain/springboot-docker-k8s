### Readme

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

Create a k8s configuration yaml file 'docker-k8s.yaml'  
https://static.brandonpotter.com/kubernetes/DeploymentBuilder.html  
Upload the file to kubernetes cluster (lets say google cloud), then run below command to start container  
`kubectl apply -f release-docker-k8s.yaml`  
Steps to expose port on Google K8s cluster https://www.youtube.com/watch?v=SzbeDqBSRkc  

Below are steps to run the app in local k8s cluster using commands:  

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
