# Start with a base image containing Java runtime
FROM openjdk:17

# Add Maintainer Info
LABEL maintainer="akrem.me"

# Add a volume pointing to /tmp
VOLUME /tmp

# Make port 9090 available to the world outside this container
EXPOSE 9090

# The application's jar file

# Add the application's jar to the container
ADD target/my-project.jar my-project.jar

# Run the jar file 
ENTRYPOINT ["java","-jar","/my-project.jar"]
