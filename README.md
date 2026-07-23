# Spring Boot Hello World com Docker

Projeto minimalista Java com Spring Boot 3 e Docker pronto para desenvolvimento local e deploy automatizado em VPS via GitHub Actions.

## 🚀 Estrutura do Projeto

```
hello-world-springboot/
├── .github/workflows/
│   └── deploy.yml
├── .env.example
├── Dockerfile
├── docker-compose.yml
├── pom.xml
├── README.md
└── src/
    ├── main/
    │   ├── java/com/example/helloworld/
    │   │   ├── HelloWorldApplication.java
    │   │   └── controller/
    │   │       └── HelloController.java
    │   └── resources/
    │       └── application.properties
    └── test/
        └── java/com/example/helloworld/
            ├── HelloWorldApplicationTests.java
            └── controller/
                └── HelloControllerTest.java
```

## 🛠️ Como Executar Localmente

### 1. Com Docker Compose (Recomendado)

Suba o container com o comando:
```bash
docker compose up --build
```
Acesse a aplicação no navegador ou via curl:
```bash
curl http://localhost:8080/
# Output: Hello World!
```

Para parar o container:
```bash
docker compose down
```

### 2. Com Docker diretamente

Construa a imagem Docker:
```bash
docker build -t hello-world-springboot .
```

Rode o container:
```bash
docker run -p 8080:8080 hello-world-springboot
```

### 3. Localmente com Maven

Compilar e rodar os testes:
```bash
mvn clean package
```

Executar a aplicação localmente:
```bash
mvn spring-boot:run
```

## 🌐 Deploy em VPS com GitHub Actions

O projeto utiliza **GitHub Container Registry (GHCR)** e SSH automatizado.

### 1. Configurar Secrets no Repositório GitHub

No seu repositório em `Settings` > `Secrets and variables` > `Actions`, adicione as seguintes **Repository secrets**:

| Secret | Descrição | Exemplo |
| --- | --- | --- |
| `VPS_HOST` | IP ou domínio do seu servidor VPS | `192.0.2.1` |
| `VPS_USERNAME` | Usuário do SSH na VPS | `root` ou `ubuntu` |
| `VPS_SSH_KEY` | Conteúdo da sua Chave Privada SSH | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `VPS_PORT` *(opcional)* | Porta do SSH no servidor | `22` |

> ⚠️ Certifique-se de adicionar a chave pública correspondente ao arquivo `~/.ssh/authorized_keys` da sua VPS.

### 2. Fluxo Automático de Deploy

Ao realizar um `git push` na branch `main` ou `master`:
1. **Build & Push**: O GitHub Actions compila o projeto, constrói a imagem Docker e publica no GitHub Container Registry (`ghcr.io`).
2. **Deploy via SSH**: O GitHub Actions transfere o `docker-compose.yml` atualizado para a VPS, realiza `docker compose pull` e atualiza a aplicação em segundo plano (`docker compose up -d`).

