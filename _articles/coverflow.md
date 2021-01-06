---
title: Recriando o CoverFlow com SwiftUI
thumbnail: 
description: Neste artigo vamos ver como podemos criar componentes divertidos que também podem nos ajudar no nosso dia a dia!
publish: true
header: /img/coverflow/header.png
layout: article
date: 2021-01-05 00:00:00
---

O ano é 2009. Você acabou de comprar o novíssimo iPod Touch, e copiou o _clássico_ Elephunk dos Black Eyed Peas pelo iTunes. Deitado na cama, foi pro app _iPod_ trocar de música e, wow, o que é essa interface toda bonita e futurista me mostrando os álbuns que eu tenho aqui?

{% assign img = "/img/coverflow" %}

Onze anos depois, você acordou com vontade de replicar essa experiência, mas se perguntava como, oh, como? Se pararmos pra analisar, o CoverFlow não é nada muito diferente de um carrossel de imagens, com alguns efeitos que deixam ele bem mais impactante. O resultado final vai ficar mais ou menos assim:

# MAURICIO INSERIR GIF DO RESULTADO FINAL
![]({{img}}/game.jpeg)




Vamos quebrar os pedaços necessários para desenvolver algo parecido? Para chegar nisso, vamos precisar de:

* Lista de álbuns normal
* Reagir a troca de orientação do device
* Um componente de carrossel de imagens
* O "açúcar" do CoverFlow
* 200ml de coca cola
* Bônus - parte 1
* Bônus - parte 2

## Lista de álbuns

Essa é a parte mais simples do projeto, crio um modelo simples para os álbuns e mostro com um `List`, bem simples. Alguns componentes, como o `DownloadImage` estão disponíveis lá no [repositório do projeto]() no GitHub :)

{% highlight swift %}
struct Album: Identifiable, Equatable {
    let id = UUID()
    let art: URL
    let name: String
    let artist: String
}

struct AlbumList: View {

    let albums: [Album]

    var body: some View {
        List {
            ForEach(albums, id: \.id) { album in
                AlbumListItem(album: album)
            }
        }
    }
}

struct AlbumListItem: View {

    let album: Album

    var body: some View {
        HStack {
            DownloadImage(imageURL: album.art, width: 100, height: 100, contentMode: .fill)
                .continuousRadius(20)
            VStack(alignment: .leading) {
                Text(album.artist)
                    .font(.title2)
                Text(album.name)
                    .font(.footnote)
            }
        }
        .padding(5)
    }
}
{% endhighlight %}
<p class="center muted caption">Bem tranquilo, né?</p>

#  Reagir a orientação do device

Vou reaproveitar o componente de `DeviceOrientation` que criei no meu post sobre [Motion Effects no SwiftUI](/post/swiftui-motion-effects/) e aplicar ele diretamente em uma `View` que me servirá de base para decidir entre o componente de CoverFlow e a lista de álbuns:

# mauricio favor arrumar o código pro deviceOrientation pegar certo da primeira vez
# mauricio favor arrumar o código pro uikeycommand funcionar mesmo com o lance da orientação

{% highlight swift %}
    struct ContentView: View {

    @ObservedObject var deviceOrientation: DeviceOrientation

    var body: some View {
        if deviceOrientation.deviceOrientation.isLandscape {
            CoverFlow(viewModel: .init())
        } else {
            AlbumList(albums: Album.debug)
        }
    }
}
{% endhighlight %}

# Um componente de carrossel de imagens

Introduzir e explicar a PagingDragView

## bônus para o mauricio: introduzir a possibilidade de passar múltiplos drags de uma vez
## bônus para o mauricio: drags com velocity pra ir rapidaooooo vuashhh

# O açúcar do CoverFlow

Explicar as rotações dimensões espelhamento para fazer o card

## bônus para o mauricio: tentar fazer a rotação do card com a parte de trás que nem tinha no coverflow do iOS

# Bônus - parte 1

UIKeyCommands

# Bônus - parte 2

Fazer um seletor de música com a album art tipo aquele massa do Spotify














{% highlight swift %}
{% endhighlight %}

{% highlight swift %}
{% endhighlight %}

{% highlight swift %}
{% endhighlight %}

{% highlight swift %}
{% endhighlight %}

{% highlight swift %}
{% endhighlight %}

{% highlight swift %}
{% endhighlight %}