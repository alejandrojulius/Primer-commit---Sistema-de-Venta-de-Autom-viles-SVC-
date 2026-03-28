# Dockerfile para Spring Boot con Maven
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copiar archivos de Maven
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Dar permisos al mvnw
RUN chmod +x ./mvnw

# Descargar dependencias (para cache)
RUN ./mvnw dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Construir la aplicación
RUN ./mvnw clean package -DskipTests

# Imagen final más ligera
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copiar el JAR generado
COPY --from=build /app/target/*.jar app.jar

# Puerto que usa Render
EXPOSE 8080

# Comando para ejecutar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
