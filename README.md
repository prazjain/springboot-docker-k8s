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
`kubectl apply -f docker-k8s.yaml`  
Steps to expose port on Google K8s cluster https://www.youtube.com/watch?v=SzbeDqBSRkc  
