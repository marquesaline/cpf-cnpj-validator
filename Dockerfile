# Use uma imagem Ruby como base
FROM ruby:3.2.2

# Atualize o sistema e instale as dependências necessárias
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev wget gnupg2 unzip

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos Gemfile para o diretório de trabalho
COPY Gemfile* ./

# Instale as gems
RUN bundle install

# Copie o restante dos arquivos para o diretório de trabalho
COPY . .

# Exponha a porta 8080
EXPOSE 8080

# Defina o comando para iniciar o servidor do Functions Framework na porta 8080
CMD ["bundle", "exec", "functions_framework", "--source", "app.rb", "--target", "cpf-cnpj-validator", "--port", "8080"]