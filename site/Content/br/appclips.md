---
title: Criando o seu primeiro App Clip
description: Neste artigo conto como foi a experiência de criar um App Clip para o app do maior evento de plataformas Apple do Brasil, e te falo como é fácil fazer o seu próprio!
published: true
header: /appclips/header.png
layout: ArticleLayout
date: 2021-01-26 00:00:00
---

Na WWDC 2020, um dos anúncios mais interessantes que acabou passando batido foi o surgimento dos App Clips. App Clips são pequenos pedaços de apps que podem ser baixados sem a necessidade de passar por toda a burocracia de usar a App Store. Foram feitos para interações rápidas e simples, mas podem ser uma ótima porta de entrada do usuário para conhecer o seu app!

Os App Clips tem um tamanho limite de 10MB por Clip, então é importante escolher bem a funcionalidade que você quer apresentar para o seu usuário nele! Neste artigo, vamos ver como foi criar o App Clip da NSBrazil, que mostra o cronograma de atividades do evento para o usuário. O importante é escolher uma funcionalidade que pode ser utilizada "na hora" pelo usuário, pois o App Clip é deletado após 30 dias e não vira um ícone na home screen do usuário para que ele acesse o aplicativo depois. Alguns exemplos interessantes são fluxos de pagamento (você pode usar o Apple Pay para deixar a interação ainda mais simples!) ou um trial de uma funcionalidade do seu app, para convencer o usuário a instalar a experiência completa.

<img src="/images/appclips/chibi-clip.png" height="300px" />
<p class="center muted caption">Testa esse Clip! Aposto que você não vai se decepcionar</p>

Começando do começo, os App Clips são um app como qualquer outro, apenas com algumas limitações, então para criá-los é bem simples, basta criar um target novo no seu projeto com o App Clip desejado. Como é possível criar mais de um clip por app, é interessante utilizar um bundle identifier que vai representar a funcionalidade do seu clip. Não se preocupe muito com isso, porque dá pra criar e configurar outros depois :) No app da NSBrazil, criei como `com.cocoaheads.conf.baseClip`

![](appclips/creating-clip-target.png)

Uma das coisas mais legais dos App Clips é que eles são obrigatoriamente apps de iOS 14+, então nós podemos usar o lifecycle de um app SwiftUI ao invés do clássico App/SceneDelegate do UIKit. Também é possível usar eles, claro, mas se a gente pode optar pelo processo mais simples, por que não?

```
@main
struct NSClipApp: App {

    // O FeedViewModel carrega as informações necessárias para mostrar
    // a agenda do evento dentro do App Clip.
    // Dentro de um App Clip, é possível fazer requests para baixar
    // todo o conteúdo necessário para que ele funcione, mesmo que isso
    // supere o limite de 10MB
    @StateObject var feedModel = FeedViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch feedModel.isLoading {
                case .loading:
                    ActivityIndicatorView()
                case .loaded:
                    loadedBody
                case .failed:
                    errorBody
                }
            }
        }
    }

    var loadedBody: some View {
        VStack {
            DownloadCallToAction()
                .padding(.bottom)
            ScheduleListView(viewModel: feedModel)
        }
    }

    var errorBody: some View {
        VStack(spacing: 20) {
            Text("Algo deu errado")
                .font(Font.title.bold())

            Button(action: {
                self.feedModel.fetchInfo()
            }, label: {
                Text("Tentar novamente")
            })
        }
    }
}
```

Fora isso, podemos lidar com o código do Clip de 3 formas: Criar tudo de novo pro Clip, marcando os arquivos para serem compilados junto com o target do clip ou embeddando um framework que usamos no app principal dentro do clip. Criando tudo de novo, corremos o risco de duplicar bugs ou esquecer da evolução da funcionalidade, sem contar que aí é mais um app pra se manter, mas é possível, caso seja necessário. 

No clip da NSBrazil, existe uma `View` que só existe dentro do código do App Clip, porque não faria sentido usar ela dentro do app normal. Com frameworks, podemos reaproveitar todo o código necessário, que já está modularizado, e assim também podemos criar diversos clips sem correr o risco de esquecer de marcar as flags de compilação no Xcode toda vez que criarmos arquivos novos. No NSBrazil, o approach escolhido foi o mais simples, de marcar os arquivos necessários para compilação no Clip, pela facilidade de se fazer isso num primeiro momento, mas a intenção é de separar tudo que for necessário em um framework, para não prejudicar a evolução do app.

Escolhendo esse approach de compilar os mesmos arquivos para targets diferentes, as vezes ainda precisamos fazer alterações específicas para a experiência do nosso clip. Para esses casos, podemos criar uma compiler flag que vai incluir o código apenas na compilação do clip, em `Swift Compiler - Custom Flags` do target do App Clip, adicionando a `-D <NOMEDASUAFLAG>`:

![](appclips/swiftflag.png)

Com isso, podemos escrever nosso código incluindo as flags quando necessário, como por exemplo:

```
/* Snippet de código da `TalkView` da agenda do app */

VStack(alignment: .leading, spacing: 5) {
    Spacer().frame(maxHeight: 5)
    Text(feedItem.name)
        .font(.headline)

    Text(feedItem.speaker)
        .lineLimit(3)
        .font(.system(size: 14))
        .lineSpacing(4)

    Text(date())
        .font(.callout)
        .fontWeight(.bold)
        .foregroundColor(.gray)

    #if APPCLIP
        Text("I am running inside the App Clip!")
    #endif
    Spacer().frame(maxHeight: 5)
}
```

E aí, compilando tanto o app quanto o App Clip, podemos ver o resultado:

![](appclips/clipcomparison.png)

## Invocando e testando o App Clip

Com o nosso código pronto e organizado, agora precisamos testar o clip. Rodando pelo Xcode, o clip se comporta com o mesmo processo de um app comum no simulador, mas essa não é a experiência completa que o usuário vai ter quando for invocar o clip, não é? Para isso, precisamos associar o domínio da URL que usaremos para invocar nas capabilities do target do clip:

![](appclips/assoc-domains.png)

E também precisamos criar uma Local Experience no menu de Desenvolvedor (`Desenvolvedor -> Local Experiences -> Register Local Experience`) do aparelho:

![](appclips/local-experience.png)

<p class="center muted caption">Caso o menu Desenvolvedor não esteja aparecendo nos Ajustes, instale um app no seu device pelo Xcode</p>

Assim que esse menu for preenchido, podemos abrir a câmera ou o Scanner de códigos do sistema e testar o nosso App Clip!

Caso queira testar em outros devices, é possível arquivar uma versão para instalação *ad-hoc* ou subir o app para o `TestFlight`, e aí, só seguir os mesmos passos de criar a experiência local.

![](appclips/testflight.png)

Uma das limitações mais importantes do App Clip é o tamanho do app, e é bem fácil da gente checar isso também, basta arquivar o App Clip para instalações *ad-hoc* e marcar essas opções:

![](appclips/thinning.png)

Dentro da pasta que o Xcode criou pra gente, existe um arquivo chamado `App Thinning Size Report.txt`, com o tamanho do seu clip para cada variante do App Thinning. Procure pela variante `Universal` do app e verifique o tamanho **uncompressed** dela. Esse é o tamanho que não pode passar de 10MB.

{% highlight plain %}
    Variant: NSClip.ipa
    Supported variant descriptors: Universal
    App + On Demand Resources size: 333 KB compressed, 667 KB uncompressed
    App size: 333 KB compressed, 667 KB uncompressed
    On Demand Resources size: Zero KB compressed, Zero KB uncompressed
{% endhighlight %}

## Publicando o App Clip

Agora que estamos com tudo pronto do lado do app, precisamos criar formas de acessar o nosso App Clip! Os App Clips podem ser acessados por meio de tags NFC, QR Codes comuns, banners em websites, códigos de App Clip, pelo app Mapas e sugestões da Siri. Configurando a URL do domínio, podemos cobrir 4 destes casos, excluindo apenas os Mapas e a Siri. 

Para isso, é necessário configurar o domínio no seu servidor, colocando um arquivo JSON com o seguinte caminho na raiz do seu site: `.well-known/apple-app-site-association`.

```
{
    "appclips": {
        "apps": [
            "TEAMIDENTIFIER.bundle.identifier.do.seu.clip"
        ]
    }
}
```

Se você já usa Universal Links no seu app, é mais simples ainda, só adicionar a chave referente aos `appclips` no arquivo, e caso você tenha feito mais de um clip, é só colocar todos eles dentro do array de apps.

**Atenção**: Caso você esteja hospedando o seu site com o GitHub Pages, assim como fazemos na NSBrazil, não é possível adicionar o arquivo apenas criando o JSON na raiz. Resolvemos esse problema no NSBrazil utilizando o CloudFlare como CDN, e com os CloudFlare Workers, interceptar a chamada para o caminho do arquivo e executar código JavaScript para retornar o JSON correto:

```
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Since GitHub Pages does not support .well-known root files,
 * we have to add the Apple App Site Association file via a worker
 */
async function handleRequest(request) {
  let aasa = JSON.stringify({
    appclips: {
      apps: ["V45SL99ZK4.com.cocoaheadsbr.conf.baseClip"]
    }
  })
  return new Response(aasa, {
    headers: {
      "content-type": "application/json"
    },
    status: 200
  })
}
```

A partir daí, podemos criar as imagens de acesso, que podem ser tanto um QR Code comum que contém a URL, ou o App Clip Code especializado da Apple, que pode ser criado pelo App Store Connect, que te dá a opção de criar um quando você sobe o app, ou com a ferramenta de linha de comando [App Clip Code Generator](https://developer.apple.com/app-clips/resources/). Também dá pra criar um Smart App Banner que leva o usuário direto para o seu App Clip, desta maneira:

```
<!-- Você pode encontrar o `app-id` do seu app na página de informações dele, dentro do AppStore Connect  -->
<meta name="apple-itunes-app"
      content="app-id=1180455342, app-clip-bundle-id=com.cocoaheads.conf.baseClip">
```

<img src="/images/appclips/nsclip.svg" height="300px" />

O último passo é criar a experiência no AppStore Connect, preencher todos os detalhes para formar o card do clip, e esperar até 48h para que ele se propague. (OBS: Essa parte só vai aparecer no seu Connect depois que você subir um build que contém um App Clip)

![](appclips/appstore.png)

E é isso! Nosso App Clip está pronto para ser compartilhado com o mundo. Se você quiser conferir o projeto completo do app da NSBrazil, é só entrar lá no [Repositório do Projeto](https://github.com/CocoaHeadsConference/CHConferenceApp), completamente feito com SwiftUI, com target a partir do iOS13!
