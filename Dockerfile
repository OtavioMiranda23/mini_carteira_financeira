# --- Stage 1: Build ---
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copia os arquivos de configuração do Maven primeiro para aproveitar o cache de dependências
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Concede permissão de execução ao wrapper do Maven
RUN chmod +x mvnw

# Baixa as dependências do projeto (cache de camada do Docker)
RUN ./mvnw dependency:go-offline

# Copia o código-fonte e faz o build gerando o JAR sem rodar os testes
COPY src ./src
RUN ./mvnw clean package -DskipTests

# --- Stage 2: Runtime ---
FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app

# Cria um usuário não-root para segurança (boa prática equivalente ao Next/Node)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copia apenas o JAR gerado do estágio de build
COPY --from=builder /app/target/*.jar app.jar

# Variáveis de ambiente
ENV SPRING_PROFILES_ACTIVE=prod \
    PORT=8080

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]