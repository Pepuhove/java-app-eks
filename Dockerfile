# -------------------------
# 1. BUILD STAGE
# -------------------------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy only pom.xml first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build WAR
COPY src ./src
RUN mvn clean package -DskipTests --no-transfer-progress

# -------------------------
# 2. RUNTIME STAGE
# -------------------------
FROM tomcat:9.0-jre17-temurin-alpine

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR into Tomcat
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
