FROM maven:3.6.3-openjdk-17 AS build
# Copy folder into Docker container
WORKDIR /opt/app
COPY ./ /opt/app

# Build the application, skipping tests
RUN mvn clean install -DskipTests

# Run Spring Boot in Docker with Java 17
FROM openjdk:17-jdk-slim
COPY --from=build /opt/app/target/*.jar app.jar
ENV PORT 8181
EXPOSE $PORT

# Command to run the Spring Boot app
ENTRYPOINT ["java", "-jar", "-Xmx1024M", "-Dserver.port=${PORT}", "app.jar"]
