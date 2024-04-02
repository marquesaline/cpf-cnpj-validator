# cpf-cnpj-validator
Google Function that validates CPF and CNPJ


## Como rodar localmente

Para rodar o serviço localmente, basta rodar os comandos na pasta do serviço:

1. **Build**

```bash
docker build -t cpf-cnpj-validator .
```

2. **Run**

```bash
docker run -p 8080:8080 cpf-cnpj-validator
```