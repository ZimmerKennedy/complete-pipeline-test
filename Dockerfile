# --- Build Stage ---
FROM maven:3.8.3-jdk-11-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean install

# --- Package Stage ---
FROM openjdk:11.0-jre-slim
WORKDIR /app
COPY --from=build /app/target/spring-boot-web.jar /app/
EXPOSE 9090
CMD [ "java", "-jar", "spring-boot-web.jar" ]
