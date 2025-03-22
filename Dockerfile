## Docker Build Maven Stage
#FROM maven:3-jdk-8-alpine AS build
## Copy folder in docker
#WORKDIR /opt/app
#COPY ./ /opt/app
#RUN mvn clean install -DskipTests
## Run spring boot in Docker
#FROM openjdk:8-jdk-alpine
#COPY --from=build /opt/app/target/*.jar app.jar
#ENV PORT 8181
#EXPOSE $PORT
#ENTRYPOINT ["java","-jar","-Xmx1024M","-Dserver.port=${PORT}","app.jar"]
# Docker Build Maven Stage
#FROM maven:3-openjdk-17-alpine AS build
FROM maven:3.6.3-openjdk-17 AS build
# Copy folder into Docker container
WORKDIR /opt/app
COPY ./ /opt/app

# Build the application, skipping tests
RUN mvn clean install -DskipTests

# Run Spring Boot in Docker with Java 17
FROM openjdk:17-jdk-alpine
COPY --from=build /opt/app/target/*.jar app.jar
ENV PORT 8181
EXPOSE $PORT

# Command to run the Spring Boot app
ENTRYPOINT ["java", "-jar", "-Xmx1024M", "-Dserver.port=${PORT}", "app.jar"]
