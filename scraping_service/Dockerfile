# Dockerfile
FROM ruby:3.1

RUN apt-get update && apt-get install -y \
  chromium \
  chromium-driver \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile e Gemfile.lock para o container
COPY Gemfile* ./

# Instalar as dependências
RUN bundle install

# Copiar o restante do código do aplicativo
COPY . .

# Expôr a porta que o Rails usará
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
