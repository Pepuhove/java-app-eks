# -------------------------
# 1. BUILD STAGE
# -------------------------
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source
COPY pom.xml .
COPY src ./src

# Build WAR file (skip tests)
RUN mvn clean package -DskipTests --no-transfer-progress

# -------------------------
# 2. RUNTIME STAGE
# -------------------------
FROM tomcat:9.0.81-jdk17-temurin
# Official Tomcat 9 + JDK 17 Temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
