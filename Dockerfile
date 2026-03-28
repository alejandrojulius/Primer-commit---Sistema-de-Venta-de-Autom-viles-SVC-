# Dockerfile simple y estable para Spring Boot en Render
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copiar archivos esenciales
COPY mvnw .
COPY pom.xml .
COPY .mvn .mvn

RUN chmod +x ./mvnw

# Descargar dependencias
RUN ./mvnw dependency:go-offline -B --no-transfer-progress

# Copiar código fuente
COPY src ./src

# Construir la aplicación
RUN ./mvnw clean package -DskipTests --no-transfer-progress

# Etapa final - imagen ligera
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]