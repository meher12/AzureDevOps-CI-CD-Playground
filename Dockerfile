# Use the official OpenJDK base image for Java 17
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

ARG JAR_FILE=*.jar
# Copy the Spring Boot application JAR file into the container
COPY /target/${JAR_FILE} app.jar

# Expose the port your application will run on (default is 8080)
EXPOSE 8080

# Command to run your application
CMD ["java", "-jar", "app.jar"]