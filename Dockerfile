FROM openjdk:17

LABEL maintainer="akrem.me"

EXPOSE 9090

ADD target/my-project.jar my-project.jar

ENTRYPOINT ["java","-jar","/my-project.jar"]