
FROM openjdk:17-jdk-slim

ARG VERSION

# Create a directory for the application
RUN mkdir /app
COPY . /app
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/*.jar /app/
RUN ls -ltrh
RUN chmod +x "/app/gradle-hello-world-$VERSION-all.jar"

# Create a non-root user and set permissions
RUN useradd --home /app gradle
RUN chown -R gradle:gradle /app
RUN echo "#!/bin/bash" >> docker-entrypoint.sh
RUN echo "java -jar gradle-hello-world-$VERSION-all.jar" >> docker-entrypoint.sh
RUN cat docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
USER gradle
# Run the application
ENTRYPOINT ["/app/docker-entrypoint.sh"]