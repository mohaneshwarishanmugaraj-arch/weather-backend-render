# Step 1: Use Maven image to build the project
FROM maven:3.9.5-eclipse-temurin-20 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy all source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Step 2: Use lightweight Java image to run the app
FROM eclipse-temurin:20-jdk-alpine

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app uses (Spring Boot default 8080)
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java","-jar","app.jar"]
