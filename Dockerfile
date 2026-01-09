# ================================
# Build stage
# ================================
FROM maven:3.9.6-openjdk-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml first and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the Spring Boot jar
RUN mvn clean package -DskipTests


# ================================
# Runtime stage
# ================================
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render uses PORT env variable)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
