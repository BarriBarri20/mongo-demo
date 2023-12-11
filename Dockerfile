# Start with a base image containing Java runtime
FROM openjdk:17

# Add Maintainer Info
LABEL maintainer="akrem.me"

# Add a volume pointing to /tmp
VOLUME /tmp

# Make port 8080 available to the world outside this container
EXPOSE 8081

# The application's jar file
ARG JAR_FILE=target/my-project.jar

# Add the application's jar to the container
ADD ${JAR_FILE} my-project.jar

# Run the jar file 
ENTRYPOINT ["java","-jar","/my-project.jar"]
