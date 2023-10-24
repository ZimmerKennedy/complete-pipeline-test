FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/spring-boot-web.jar /app/
EXPOSE 9090
CMD [ "java,","-jar","spring-boot-web.jar" ]
