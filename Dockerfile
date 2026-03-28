# Dockerfile simple y estable para Spring Boot
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copiar solo lo necesario para Maven
COPY mvnw .
COPY pom.xml .
COPY .mvn/ .mvn

# Dar permisos
RUN chmod +x ./mvnw

# Descargar dependencias
RUN ./mvnw dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Construir
RUN ./mvnw clean package -DskipTests

# Imagen final
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]