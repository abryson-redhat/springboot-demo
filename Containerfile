####
# This Dockerfile is used in order to build a container that runs the Spring Boot application
#
# Build the image with:
#
# docker build -f docker/Dockerfile -t springboot/sample-demo .
#
# Then run the container using:
#
# docker run -i --rm -p 8081:8081 springboot/sample-demo
####
FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

# Build dependency offline to streamline build
USER root

RUN mkdir project
WORKDIR /home/jboss/project

### AMB - taking out.  Will rely on upstream process to build the archive
### assumes project workspace in state after mvn package
### AMB COPY pom.xml .
### AMB RUN mvn dependency:go-offline

### AMB COPY src src
### AMB RUN mvn package -Dmaven.test.skip=true
# compute the created jar name and put it in a known location to copy to the next layer.
# If the user changes pom.xml to have a different version, or artifactId, this will find the jar
#ADD target /home/jboss/project/
COPY target target
RUN grep version target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-version && \
    grep artifactId target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-id && \
    chmod -R "ug+rwX" /home/jboss/project && \
    chown -R 1001 /home/jboss/project && \
    mv ./target/$(cat .env-id)-$(cat .env-version).jar ./target/export-run-artifact.jar
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.15-1.1682053056
COPY --from=builder /home/jboss/project/target/export-run-artifact.jar  /deployments/export-run-artifact.jar
EXPOSE 8081

USER 1001

ENTRYPOINT ["/opt/jboss/container/java/run/run-java.sh", "--server.port=8081"]

