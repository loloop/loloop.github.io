---
title: Site Pessoal
thumbnail: /img/index/pessoal.png
description: Desenvolvido para expor meu portfolio, criado com Jekyll, hospedado pelo GitHub Pages. Quer entender melhor como o desenvolvi? Dá uma olhada aí
layout: article
header: "/img/site-pessoal/header.png"
---
Iteração após iteração, o meu site pessoal surgiu da minha vontade de ter, em um lugar só, a coleção de todos os meus trabalhos, 
apresentados de uma forma que não fosse apenas uma mera lista de pontos num currículo, mas sim coleção de artigos expondo seu processo
de desenvolvimento, as etapas por quais esses projetos passaram, as dificuldades encontradas e as decisões tomadas diante delas.

Com isso, era de se esperar que o próprio também tivesse um artigo, detalhando tudo que aconteceu desde seus primórdios até o seu estado atual.

**Aviso:** este é um documento em constante mutação, pois é de se esperar que ele evolua juntamente com o site. Tendo dito isto, começo contando
sobre o meu ponto de partida.

O chute inicial que o desenvolvimento desse site precisava era, não só a necessidade de atualizar conteíudo do meu site antigo (na imagem, aqui embaixo, tava bem triste),
como também de se criar um espaço onde eu poderia, com uma certa facilidade, dar manutenção e expor os meus projetos pessoais futuros. Uma página HTML estática com alguns
poucos links é um lugar péssimo pra se fazer isso, mas por outro lado, uma página com um stack legal, hospedado pelo próprio GitHub? Aí sim a gente gosta.

!["Foto da minha página antiga, fundo cinza, alguns poucos links azuis para projetos meus que não estão mais disponíveis na internet"](/img/site-pessoal/old-website.png)

Por falar no stack, ele é bem simples, já que é o "padrão" que o GitHub Pages oferece aos seus usuários, e é um stack que eu estou bastante acostumado a 
lidar com, pois o utilizamos com uma certa frequência nos conteúdos que a gente produz na Rowbots, e é o mesmo stack que utilizei quando fiz a minha
contribuição, inclusive com o mesmo intuito de expandir e facilitar a manutenção, no site da [CocoaHeads Conference](http://cocoaheadsconference.com.br).

O stack em si é bem simples, composto do: [Jekyll](http://jekyllrb.com), usando o [Sass](http://sass-lang.com) pra escrever os estilos, e o bom e velho markdown para escrever os textos.
O site tá todo aberto lá no meu [GitHub](https://github.com/loloop/loloop.github.io). Pull requests são bem vindos :P

# design & docs

!["Foto da minha página antiga, fundo cinza, alguns poucos links azuis para projetos meus que não estão mais disponíveis na internet"](/img/site-pessoal/design-stage.png)

A primeira etapa do desenvolvimento deste site foi a criação de uma pequena guia de design ([disponível aqui](/design)), onde eu pude testar e experimentar o estilo que eu queria dar ao site antes de me comprometer a desenvolver os blocos que dariam o visual final para ele. Nesta etapa, eu procurei encontrar algum estilo em que eu fosse conseguir fazer com que cada página, caso eu quisesse, teria uma personalidade própria, mas ainda compartilharia elementos básicos como tipografia com as outras páginas, criando consistência entre elas.

--- inserir uma foto das páginas coloridas, provavelmente um print da home, um print da página do roger that e um outro artigo, talvez o da conf

[   Texto antigo: 

- páginas internas

O esquema de cores de uma página é baseado no esquema de cores do que o conteúdo dela (exceto por esta página aqui, pois amarelo no rosa é péssimo para se ler textos longos) representa. 
Daí, conseguimos ver uma página como a do Roger That! como uma mistura do que eu ofereço com o que o [artista](the art of lucas mendonça) intencionou.

]

O esquema de cores básico padrão é o preto e branco, igual ao dessa página aqui. Na home (a lista de projetos), escolhi um esquema em que tento expor a minha visão pessoal da minha personalidade, com cores bastante fortes, mas que tem um quê de diversão. 

OBS: Acabei não reparando inicialmente, mas ele é bem similar ao esquema de cores de um grupo que eu gosto muito, e recomendo pra todos, o [Kero Kero Bonito](http://kerokerobonito.com) (Apesar do nome, eles não tem nada a ver com o Brasil, mas são muito bons, garanto!)

<div class="row">
    <div class="col-md-6">
        <img src="/img/site-pessoal/kkb.png" class="d-flex">
    </div>
    <div class="col-md-6">
        <iframe width="560" height="234" src="https://www.youtube.com/embed/4aQBkCrpWOg" frameborder="0" allowfullscreen></iframe>
    </div>
</div>

Quanto a navegação, procurei manter uma sidebar limpa mas que me desse a possibilidade de expandir e iterar sobre ela quando necessário no desktop, e no mobile, procurei resolver um problema que muito me incomoda no mundo mobile, que era remover os botões de navegação da parte de cima, porque ficam muito distantes dos dedos do usuário.

--- inserir aquele heatmap da mão do usuário no celular
--- não esquecer de incluir fonte

Sendo assim, optei por deixá-la na parte inferior da tela, num lugar muito mais acessível, e procurei fazer com que ela tivesse um visual parecido com o da nossa querida [UITabBar](https://developer.apple.com/reference/uikit/uitabbar).

--- inserir uma foto da ui tab bar (em qual app? Clock? Music? App Store?) vs tab bar desse site em mobile


# Créditos

Ícone de contato na navegação: Contacts book by iconsphere from the Noun Project
Ícone de portfolio na navegação: code by Joshua McDonald from the Noun Project