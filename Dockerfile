#STAGE 1
FROM maven:3.9.6-amazoncorretto-21-al2023 AS builder
#COPY ci_settings.xml $MAVEN_CONFIG/settings.xml
WORKDIR /home/app
COPY pom.xml /home/app
COPY src /home/app/src
RUN mvn package

#STAGE 2
FROM amazoncorretto:21-alpine-jdk
LABEL authors="mario.altamura"
ENV TZ=Europe/Rome
ENV USER=spring
ENV GROUPNAME=$USER
ENV UID=500
ENV GID=500
RUN addgroup -S spring && adduser -S spring -G spring
USER $USER
#RUN addgroup --gid "$GID" "$GROUPNAME" &&  adduser -D -h /home/app -G $USER -u $UID $USER
#RUN apk add --no-cache curl
COPY --from=builder /home/app/target ./home/app
WORKDIR /home/app
ENTRYPOINT ["java", "-jar", "spring-boot-demo.jar"]

