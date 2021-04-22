docker build -t springboot-docker-k8s .
docker tag springboot-docker-k8s prashant4life/springboot-docker-k8s
docker push prashant4life/springboot-docker-k8s
docker stop springboot-docker-k8s
docker rm springboot-docker-k8s
docker rmi -f prashant4life/springboot-docker-k8s
docker run --name springboot-docker-k8s -p 8080:8080 -d prashant4life/springboot-docker-k8s:latest