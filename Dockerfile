# ---- Build stage ----
FROM eclipse-temurin:21-jdk-jammy AS builder

WORKDIR /build

COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

COPY src src
RUN ./mvnw package -DskipTests -B

# ---- Runtime stage ----
FROM harbor.devops.kcbgroup.com/mirror/redhat/ubi8/openjdk-21-runtime:1.21

LABEL maintainer="KCB Group - BSS DevOps"
LABEL service="springboot-demoapp-jenkins"
LABEL version="0.0.1-SNAPSHOT"

# Security patches
USER root
RUN microdnf update -y && microdnf clean all

WORKDIR /app

# Download OpenTelemetry Java agent

ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.10.0/opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar
RUN chmod 644 /app/opentelemetry-javaagent.jar


COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

# Run as non-root
USER 1001

ENV TZ="Africa/Nairobi"
ENV JAVA_OPTS="-XX:+UseG1GC \
  -XX:MaxRAMPercentage=75.0 \
  -Djava.security.egd=file:/dev/./urandom \
  -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE:-default}"

ENV JAVA_TOOL_OPTIONS="-javaagent:/app/opentelemetry-javaagent.jar"
ENV OTEL_SERVICE_NAME="springboot-demoapp-jenkins"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-collector.observability.svc.cluster.local:4317"
ENV OTEL_EXPORTER_OTLP_PROTOCOL="grpc"
ENV OTEL_TRACES_EXPORTER="otlp"
ENV OTEL_METRICS_EXPORTER="otlp"
ENV OTEL_LOGS_EXPORTER="otlp"


HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -sf http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
