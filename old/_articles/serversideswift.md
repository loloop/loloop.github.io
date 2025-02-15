---
title: Vamos falar de Swift no Linux?
thumbnail: 
description: Swift no Linux é uma área pouco explorada pelo desenvolvedor de plataformas Apple, mas pode ser uma ferramenta muito útil e uma fonte de conhecimento imensa, e que vale muito a pena de se aprender. 
publish: true
layout: article
header: /img/serverswift/tux.png
date: 2023-10-25 00:00:00
---

Swift no Linux é uma área pouco explorada pelo desenvolvedor de plataformas Apple, mas pode ser uma ferramenta muito útil e uma fonte de conhecimento imensa, e que vale muito a pena de se aprender. 

{% assign img = "/img/serverswift" %}

Escrever o código todos nós já entendemos bem, e ver o resultado da nossa criação não é muito diferente das outras plataformas quando estamos no servidor, mas uma coisa que eu pessoalmente sempre tive muito problema é: Como eu faço o meu código ficar disponível para outras pessoas? A gente já sabe como subir um app na App Store, mas e subir um serviço aberto na internet? Existem tantas formas, todas corretas, cada uma de seu jeito e é quase impossível escolher uma. 

## O Projeto

Eu criei o [@F1LandinhoBot](https://t.me/F1LandinhoBot) com o intuito de me ajudar a lembrar os horários das corridas da Fórmula 1 num grupo de amigos, acessando a API do Telegram e mandando mensagens para que a gente não perdesse o horário de uma sessão sequer das corridas. 

![]({{img}}/telegram.png)

E funcionou tudo bem tranquilo rodando direto no meu Mac, mas eu não quero deixar o meu Mac ligado o tempo todo, rodando esse código pro bot funcionar, e não quero nem pensar em como eu vou garantir que ele vai funcionar o tempo todo. Onde moro, quedas de energia são bem comuns, e isso me parece um desperdício de processamento do meu computador de qualquer forma.

Então resolvi colocar esse código para rodar no meu servidor na Amazon, que eu já tenho faz uns anos rodando um [servidor de Quake](https://quake.host), então não precisaria desembolsar nenhum centavo a mais do que eu já pago por ele pra colocar o serviço no ar. O setup do Swift no Linux está todo detalhado no [Swift.org](https://swift.org) e apesar de um pouco trabalhoso, é fácil de seguir. Clonei o código do GitHub e eu não estava esperando o que vinha a seguir: 

![]({{img}}/wont-build.png)
<p class="center muted caption">OpenCombine é uma biblioteca feita especificamente pra gente usar o Combine no Linux, como assim ela não existe? Desde quando URLSession é um AnyObject?</p>

## Swift no Linux

Existem algumas lombadas durante o caminho do Swift no servidor que são raramente mencionadas, principalmente porque são abstraídas pelos frameworks famosos, mas que você vai encontrar bem rápido se for pelo caminho de escrever o código "puro". Todas elas existem por conta do fato de que o Swift no Mac não traz as mesmas bibliotecas que o Swift no Linux. O Foundation, que a gente está bastante acostumado a usar no mundo Apple não é o mesmo Foundation que existe no Linux, e isso [não é documentado](https://forums.swift.org/t/what-are-best-practices-to-write-a-linux-software-on-macos/) em lugar algum. É um problema que [não deve durar muito tempo](https://www.swift.org/blog/future-of-foundation/), mas ainda é um problema.

![]({{img}}/urlsession.png)
<p class="center muted caption">O URLSession fica em uma biblioteca completamente diferente no Linux, que nem existe no macOS!</p>

## Publicando o nosso trabalho

Resolvidos esses problemas, tenho meu projeto compilando e rodando no servidor, finalmente! Mas e agora, como que eu deixo ele rodando lá? Não posso simplesmente fechar o ssh no meu terminal, porque ele vai parar a execução do código. Para resolver esse problema, eu utilizei o `systemd`, que é o gerenciador de serviços padrão do Ubuntu.

O meu arquivo de configuração dele é bem simples, eu pedi pro GPT criar uma base e fui customizando com as necessidades que eu tinha, tipo as minhas variáveis de ambiente (não coloquem elas direto no seu código!) e o que o meu serviço teria de fazer caso acontecesse um problema.

```
[Unit]
Description=Landinho formula one schedule telegram bot
After=network-online.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/LandinhoBot
ExecStart=/home/ubuntu/swift/swift-5.7.3-RELEASE-ubuntu22.04/usr/bin/swift run
Environment="TELEGRAM_TOKEN=6103171:AAHrN7p7rTJPgeNoeYRo"
Environment=“DEBUG_CHAT=-123131234"
Restart=always

[Install]
WantedBy=multi-user.target
```

Depois disso, ainda preciso entrar no servidor, baixar o código, compilar e rodar o serviço. Esse processo todo é muito chato de se fazer, e como não é parte do nosso dia a dia, é até capaz de esquecermos como são todos esses passos, então escrevi um script de deploy bem simples, para facilitar o processo. Ele baixa o código, compila e reinicia o serviço:

```swift {% comment %} O highlight fica esquisito com a opção de bash {% endcomment %}
#!/bin/bash

git fetch
git pull origin main
(
  cd telegram
  swift build
  sudo systemctl restart landinho.service
)
```
Mas eu ainda tenho que entrar no servidor, rodar o script e ver se tá tudo ok. Dá pra deixar melhor. Para resolver isso, depois de conversar com um amigo que é full-stack, decidi ir para o caminho mais simples possível: Automatizar o processo que eu já estava fazendo manualmente, pelo GitHub Actions. 

``` {% comment %} syntax highlight de yaml fica ruim aqui tb {% endcomment %}
on:
  push:
    branches:
    - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: configure-ssh
      run: |
          mkdir -p ~/.ssh/
          echo "$key" > ~/.ssh/server.key
          chmod 400 ~/.ssh/server.key
          cat >>~/.ssh/config <<END
          Host server
            HostName $host
            User $username
            IdentityFile ~/.ssh/server.key
            StrictHostKeyChecking no
          END
    - name: run-deploy-script
      run: ssh server 'cd LandinhoBot; sh deploy.sh'
    env:
      host: ${% raw %}{{secrets.SSH_HOST}}{% endraw %}
      username: ${% raw %}{{secrets.SSH_USERNAME}}{% endraw %}
      key: ${% raw %}{{secrets.SSH_KEY}}{% endraw %}
``` 

Importante agradecer o [@flpms](https://twitter.com/flpms), que é o amigo que menciono durante o artigo. A parte da configuração que cria o arquivo de configuração do SSH para o GitHub Actions é de autoria dele.

Dissecando a configuração do Actions, a gente tem um job que vai ser executado toda vez que acontecer um push na minha branch `main`, com um passo pra configurar o SSH e um passo para executar o nosso script de deploy.

E é isso! Desse jeito você consegue automatizar a execução do seu código em qualquer máquina Linux que você tenha acesso ao terminal. Mas existe uma outra alternativa:

## Platform as a Service

Um jeito muito mais fácil de se realizar esse processo todo é utilizando uma plataforma como o [Render](https://render.com) (ou outros milhares de serviços que fazem a mesma coisa), que vai abstrair todo o processo de configurar o ambiente, realizar o deploy quando houver um merge, e vai te dar outras regalias, como backups de banco de dados e etc. Essa facilidade toda tem o seu custo ($), e caso você queira subir outro serviço, os custos vão subir bem mais rápido.

![]({{img}}/render.png)

Não tem muito o que ficar falando sobre essas plataformas, cada uma vai ter suas particularidades, mas é uma alternativa que eu gosto muito de usar! Quanto menos tempo a gente gasta na infraestrutura, mais a gente pode investir no produto em si, e isso é o que importa no final. Até a próxima!