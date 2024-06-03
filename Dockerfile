# Stage 1: Build stage
FROM gradle:jdk11 AS build
WORKDIR /app

# Copy the build.gradle.kts file into the container
COPY . /app/

# Execute the Gradle build script to get the new version
RUN VERSION=$(gradle -q updateVersion  | grep 'Version: ' | awk '{print $4}') \
    && echo "New version: $VERSION" \
    && gradle build --no-daemon

# Package it into an artifact
RUN gradle shadowJar

# Stage 2: Production stage
FROM adoptopenjdk/openjdk11:jre
WORKDIR /app

# Copy the artifact from the build stage
COPY --from=build /appgradle-hello-world/build/libs/your-application.jar /app/your-application.jar

# Tag the Docker image as the Jar version automatically
ARG VERSION
LABEL version=$VERSION

# Ensure the Docker image doesn't run with root
USER 1000:1000

# Push the Docker image to Docker Hub
# Assuming you have already logged in and set up Docker Hub credentials
ARG omersh12
ARG omer12shafir
RUN echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
RUN docker push your-dockerhub-username/your-application:$VERSION

# Download and run the Docker image
# Use `docker run` command with the appropriate options
# Example: docker run -p 8080:8080 your-dockerhub-username/your-application:$VERSION
