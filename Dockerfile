FROM openjdk:17-jdk-slim



# Create a directory for the application
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/*.jar /app/*

RUN chmod 777 /app/*.jar

# Create a non-root user and set permissions
RUN useradd -m gradle
USER gradle
# Run the application
ENTRYPOINT ["java", "-jar", "/app/gradle-hello-world-all*.jar"]