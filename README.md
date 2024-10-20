
---
<h1 align="center">
  🚀 Task and Scraping 🚀
</h1>
<br>



Esse projeto foi desenvolvido com as seguintes tecnologias:

- [Ruby](https://www.ruby-lang.org/pt/)
- [React](https://reactjs.org)
- [Chakra-ui](https://v2.chakra-ui.com/)
- [MySql](https://www.mysql.com/)
- [Docker](https://www.docker.com/)

<div style="display: inline_block"><br>
  <img align="center" alt="Gui-Ruby" height="30" width="40" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/ruby/ruby-original.svg">
  <img align="center" alt="Gui-React" height="30" width="40" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original.svg">
  <img align="center" alt="MySql" height="30" width="40" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original.svg">
  <img align="center" alt="Docker" height="30" width="40" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original.svg">
</div>

-----

# 💻 Projeto

Este projeto é uma aplicação Ruby on Rails desenvolvida para realizar scraping do site WebMorts. O objetivo é coletar a marca e modelo do veículo.

#  💻 Passos para montar ambiente local
* Entrar na pasta do Projeto, e rodar `docker compose build`.
* Após entrar no bash de cada microserviço
    * Bash do serviço de autenticação: `docker exec -it auth_service bash`
    * Bash do serviço de notificação: `docker exec -it notification_service bash`
    * Bash do serviço de scrapping: `docker exec -it scraping_service bash`
    * Bash do serviço de tarefas: `docker exec -it task_management bash`
    * Rodar o comando `rails db:migrate` em cada umm deles para criar as tabelas. 
* Entrar na pasta <b>front-end</b> e rodar `npm install` para baixar os pacotes.
* Após rodar o comando `npm start` para iniciar front-end.


### Busca dos valores:
O scraping dos valores é feito através da gem <b>Nokogiri</b>, porém como o site WebMotors possuia uma validação de ReCapatcha, foi necessário fazer a busca dentro do Sidekiq, enfilerando os registros e fazendo uma busca em cada 5 minutos, mesmo que seja pedido para fazer 10 buscas ao mesmo tempo, foi necessário enfilerar essas requisições, para que não ocorra o problema de bloquio pelo ReCapatcha, portanto cada busca será feito dentro de 5 minutos.


### Notificação no Front-end do termino do Scraping:

Quando for finalizado o Scraping do modelo e marca do veículo no site WebMotors, será enviado uma notificação para o front-end feito em React através de um <b>WebSocket</b>, essa conexão de WebSocket é feita através do `user_id`, portanto só mostrará a notificação para o user que fez a criação da tarefa.

### Componentes do front-end:

Acabei optando por utilizar a biblioteca de componentes <b>Chakra-ui</b>, pois ela oferece componentes e estilizações de uma maneira simples, temos outras como Tailwind, porém tenho mais vivência com Chakra-ui, acabei escolhendo por esse frame.

Obs. O servidor do React deverá rodar na porta localhost:3004, pois as demais portas como 3000, 3001, 3002 e 3003 são ocupadas pelo microsserviços. 

### Bloqueio de rotas sem login:

Dentro do application_controller de cada microserviço foi implementado uma verificação, através do Barear Token, caso o mesmo não seja enviado pela requisição e seja um token válido, será retornado uma mensagem de sem autenticação e retornará status 401. 

#  💻 Tela login
<br>
Na tela de login, possuimos apenas o campo de Email e Password, decidi fazer uma tela simples, porém objetiva. 
<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/Login.png)

#  💻 Tela de cadastro
<br>
É possivel criar um usuário, informando Email e Senha, ele poderá ser utilizado posteriormente para logar na aplicação. 
<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/Register.png)

#  💻 Tala de Tarefas
<br>
Nessa tela possuímos a listagem de todas as tarefas. Temos o botão de incluir uma tarefa, deslogar do sistema, atualizar uma tarefa, excluir uma tarefa e também o botão para verificar os scrapings já realizados.
<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/ListaDeTarefas.png)


#  💻 Incluir uma Tarefa
<br>
É possível incluir uma tarefa, informando a URL e o campo de Tipo, caso seja o tipo scraping, será feito o scraping do site informado no campo url. 
<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/IncludeTask.png)



#  💻 Editar uma Tarefa

<br>

É possível editar a URL ou Tipo da tarefa. 

<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/EditTask.png)



#  💻 Notificação de finalização do Scraping

<br>
Após processar no Sidekiq o Scraping do site, será enviado uma notificação tipo Toas para o front-end React, através de um WebSocket com o objetivo de avisar o usuário que o pedido de Scraping, finalizou, após isso será possível ver as informações buscadas no botão `See scraping`.
<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/NoticateScraping.png)

#  💻 Ver listagem de Scraping realizados

<br>

Temos o botão `See scraping`, onde será possível verificar todos os scrapings feitos naquela atividade, como temos a possibilidade de alterar a url da tarefa, eu optei por ter o histórico de todos os scrapings já feitos na tarefa. 

<br>

![alt text](https://github.com/GUIFRE88/task/blob/main/images/SeeScraping.png)


#  💻 Rotas da Api

## Auth Service

### singup

![alt text](https://github.com/GUIFRE88/task/blob/main/images/auth/auth-signup.png)

### login

![alt text](https://github.com/GUIFRE88/task/blob/main/images/auth/auth-login.png)

### validate

![alt text](https://github.com/GUIFRE88/task/blob/main/images/auth/auth-token.png)


## Task Management

### create

![alt text](https://github.com/GUIFRE88/task/blob/main/images/task/task-create.png)

### index

![alt text](https://github.com/GUIFRE88/task/blob/main/images/task/task-index.png)

### show

![alt text](https://github.com/GUIFRE88/task/blob/main/images/task/task-show.png)

### update

![alt text](https://github.com/GUIFRE88/task/blob/main/images/task/task-update.png)

### delete

![alt text](https://github.com/GUIFRE88/task/blob/main/images/task/task-delete.png)


## Scraping Service

### start_scraping

![alt text](https://github.com/GUIFRE88/task/blob/main/images/scraping/scraping-start.png)

### index

![alt text](https://github.com/GUIFRE88/task/blob/main/images/scraping/scraping-index.png)


## Notification Service

### create

![alt text](https://github.com/GUIFRE88/task/blob/main/images/notification/notification-create.png)

### show

![alt text](https://github.com/GUIFRE88/task/blob/main/images/notification/notification-show.png)



---

# 💻 Rspec
Implementado testes com Rspec em cada projeto individualmente, por favor verifique a pasta /spec de cada projeto.



#  💻 Melhorias no projeto

Todo projeto oferece desafios e melhorias, creio que as melhorias seriam:

 * Gostaria de ter implementado algum serviço para quebra do ReCaptcha, pois o site do WebMotors estava bloquando quando eram feitas muitas requisições, uma forma de burlar isso foi através da utilização do Sidekiq, porém temos alguns serviços que podem fazer o preenchimento do ReCaptacha, mas os melhores que eu encontrei eram pagos.
 * A parte do front-end poderia apresentar uma paginação, talvez utilizando a gem <b>will_paginate</b>, decidi não fazer nesse momento, porém gostaria de implementar isso no sistema futuramente, compreendo a importancia disso pensando em uma grande quantidade de registros.


# 💻 Contribuição
Sinta-se à vontade para contribuir com melhorias ou correções! Para isso, faça um fork do repositório, crie uma branch com suas alterações e envie um pull request.

# 💻 Licença
Este projeto está licenciado sob a MIT License.


----
