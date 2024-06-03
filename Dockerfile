FROM openjdk:17-jdk-slim



# Create a directory for the application
RUN mkdir /app
COPY . /app
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/*.jar /app/
RUN ls -ltrh
RUN chmod 777 /app/*.jar

# Create a non-root user and set permissions
RUN useradd -m gradle
USER gradle
# Run the application
ENTRYPOINT ["java", "-jar", "/app/gradle-hello-world-*-all.jar"]