# Create base container image
FROM java:8 AS builder
ARG INPUT_JAR_FILE=target/springboot-docker-k8s.jar
ARG FINAL_JAR_FILE=springboot-docker-k8s.jar
COPY ${INPUT_JAR_FILE} ${FINAL_JAR_FILE}
RUN java -Djarmode=layertools -jar ${FINAL_JAR_FILE} extract

# Create layered main docker container image from base container
FROM java:8
# Expose port 8080, used when this container is run using `docker run`
EXPOSE 8080
COPY --from=builder dependencies/ ./
COPY --from=builder snapshot-dependencies/ ./
RUN true
COPY --from=builder spring-boot-loader/ ./
COPY --from=builder application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
