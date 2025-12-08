# Use Eclipse Temurin JRE 17 (official OpenJDK distribution)
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file from target directory
COPY target/timesheet-devops-1.0.jar app.jar

# Expose port 8089 as specified in application.properties
EXPOSE 8089

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
