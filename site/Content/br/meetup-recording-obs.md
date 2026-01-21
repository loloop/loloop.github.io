---
title: Gravando o seu meetup
description: Um guia prático para organizadores poderem contribuir rapidamente com o ecossistema online do CocoaHeads
published: false
layout: ArticleLayout
date: 2025-09-01 00:00:00
language: pt-BR
---

Depois de anos gravando meetups, aprendi que você não precisa de equipamentos caros ou de uma configuração complexa para capturar conteúdo de qualidade para sua comunidade local. Este guia vai te mostrar o que comprar, como configurar, e como executar a gravação de forma que o esforço seja pequeno, ideal para que você possa subir ele rapidamente para o canal do CocoaHeads.

## A lista de compras de hardware

O hardware necessário para gravar o seu evento cabe na sua mochila e também cabe no seu bolso. Aqui, vamos tentar economizar e usar o mínimo viável para ter uma gravação com uma qualidade ok. A maior parte dos itens você já vai ter, porque você os usa como parte do seu dia a dia como desenvolvedora para plataformas Apple.

Resumindo, você vai precisar de:

* MacBook
* iPhone (e preferencialmente o cabo para conectar ele no Mac, mas você pode tentar usar uma conexão sem fio também)
* Tripé
* Microfone de lapela sem fio
* Placa de captura de vídeo, um cabo HDMI e um adaptador usb-c para HDMI (opcional)

A placa de captura auxilia na hora de capturar a tela do computador da palestrante, evitando que vocês fiquem passando arquivos de um computador para o outro na hora do evento, e também a deixando em um ambiente mais confortável para apresentar. As vezes uma pequena divergência pode causar um nervosismo adicional desnecessário, que vai atrapalhar bastante pessoas que tem menos experiência com palestras. Em caso de live demos, pode ser mais complicado ainda passar os arquivos para o seu computador, porque divergências de versão e configurações de ambiente também podem causar problemas.

Existem placas de captura mais acessíveis no mercado, mas caso você não queira fazer esse investimento, você pode criar uma chamada no FaceTime com a palestrante e pedir o compartilhamento da tela. Fique atento aos possíveis problemas de latência decorrentes da conexão sem fio, e também saiba que esse método exige mais poder de processamento, e pode impactar negativamente na sua gravação. No 67º CocoaHeads SP, perdi uma das gravações das palestras porque meu MacBook esquentou demais e entrou em thermal throttling, fazendo com que o vídeo ficasse travando, exatamente porque esse setup é mais exigênte com o hardware.

Compre o melhor microfone de lapela que puder. É possível gravar com os microfones do iPhone, mas dependendo do posicionamento dele, você vai acabar captando conversas paralelas e sons do ambiente, que é bastante indesejável e vai te dar retrabalho para tentar resgatar o áudio do video para fazer o upload.

No total, você provavelmente vai ter que investir por volta de 400 reais para ficar com esse setup bem acertado.

/* contextualizar a existência do OBS */ 

## Configurando o OBS Studio

O OBS Studio é grátis e muito tranquilo de usar. Veja como configurá-lo para gravar o evento:

### Passo 1: Baixe e instale o OBS
Pegue em [obs.studio](https://obs.studio). Instale e passe pelo assistente de configuração inicial, escolhendo "Otimizar para gravação" em vez de streaming (você sempre pode mudar isso depois).

### Passo 2: Configure suas cenas
Eu uso uma configuração simples de duas cenas:

**Cena 1**
- Fonte principal: Dispositivo de Captura de Vídeo (sua placa de captura USB)
- Fonte secundária: Feed da câmera do iPhone (Continuity Camera funciona perfeito aqui, não precisa instalar nada!)
- Áudio: Seu microfone sem fio conectado na USB

**Cena 2**
Essencialmente a mesma coisa, mas para o seu próprio Mac.

- Fonte principal: Captura de Tela
- Fonte secundária: Feed da câmera do iPhone (Continuity Camera funciona perfeito aqui, não precisa instalar nada!)
- Áudio: Seu microfone sem fio conectado na USB

### Passo 3: Adicione suas fontes

Clique no botão + em Fontes e adicione:

1. **Dispositivo de Captura de Vídeo**: Selecione sua placa de captura USB. Isso mostrará a tela do apresentador.

2. **Captura de Janela** (para iPhone): Use um app como EpocCam ou Camo para transformar seu iPhone em uma webcam. Adicione como captura de janela ou segundo dispositivo de vídeo.

3. **Captura de Entrada de Áudio**: Selecione o receptor do seu microfone sem fio.

### Passo 4: Organize seu layout

Para a cena de apresentação, faça a captura de tela ocupar a maior parte do canvas. Adicione o feed do iPhone como um pequeno picture-in-picture no canto inferior. Você pode redimensionar e posicionar as fontes clicando e arrastando-as na visualização.

### Passo 5: Configure as configurações de gravação

Vá para Configurações > Saída:
- Formato de Gravação: Fragmented MOV (Esse formato permite que você não perca a gravação caso algum problema técnico aconteça)
- Qualidade de Gravação: "Alta Qualidade, Tamanho de Arquivo Médio"

Uma vez configurado, você raramente precisará fazer alterações no OBS.

## O fluxo de gravação

### Antes do evento

/* resumir os pontos em um parágrafo */

1. **Chegue pelo menos uma hora minutos antes**: A configuração sempre leva mais tempo que o esperado.

2. **Teste tudo**: 
   - Conecte o laptop do apresentador à sua placa de captura
   - Verifique se o OBS está recebendo o sinal de vídeo
   - Teste os níveis de áudio com o microfone sem fio
   - Posicione e conecte seu iPhone no tripé
   - Faça uma gravação teste de 30 segundos

3. **Checklist do apresentador**:
   - Configurar o display para 1080p (resoluções maiores podem não funcionar com placas de captura mais baratas)
   - Desabilitar notificações
   - Fechar aplicações desnecessárias
   - Usar modo de apresentação se mostrar slides

### Depois do evento

3. **Edição básica** (opcional): 
   - Corte o início e o fim
   - Adicione um cartão de título
   - Normalize o áudio se necessário

/* reescrever essa parte de baixo que tá muito AI-coded lmao */ 

Apenas comece. Sua primeira gravação não será perfeita, e está tudo bem. A comunidade valoriza o conteúdo mais que a qualidade de produção. A cada evento, você ficará um pouco melhor na configuração, desenvolverá seu próprio fluxo de trabalho, e antes que perceba, gravar será apenas uma parte natural da rotina do seu meetup.

A configuração que descrevi aqui funcionou de forma confiável para dezenas de eventos. É simples o suficiente para que você possa configurar rapidamente, acessível o suficiente para não quebrar seu orçamento, e boa o suficiente para que sua comunidade aprecie ter acesso ao conteúdo.
