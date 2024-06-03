FROM openjdk:17-jre-slim

# Create a non-root user and set permissions
RUN useradd -m gradle
USER gradle

# Create a directory for the application
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/*.jar /app/*

# Run the application
ENTRYPOINT ["java", "-jar", "/app/your-artifact.jar"]