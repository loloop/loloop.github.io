---
title: Arquitetura baseada em eventos para SpriteKit
thumbnail: 
description: Vamos dar uma olhada em como podemos facilitar o desenvolvimento de apps com SpriteKit
published: true
header: /img/spritekit/logo.png
layout: ArticleLayout
date: 2020-07-19 00:00:00
---

Este artigo é um pedaço do que apresentei na [talk que dei no CocoaHeads ES em Vitória](https://www.youtube.com/watch?v=69lGgGLGoJQ), realizado na Brooder, em novembro de 2019, "Criando o seu primeiro jogo com SpriteKit". Lá, falo um pouco mais sobre os objetos, funcionalidades e lifecycle do SpriteKit em si, além de introduzir a arquitetura baseada em eventos.

{% assign img = "/img/spritekit" %}

O SpriteKit é um framework desenvolvido pela Apple para a criação de jogos de alta performance em 2D. Como ex-desenvolvedor de jogos, este framework me atraiu naturalmente assim que comecei a estudar Swift e desenvolver apps, mas como desenvolvia com a Unity, que é bastante opinativa em sua arquitetura, fiquei um pouco perdido ao tentar criar experiências com ele. A talk que fiz e por consequência este artigo são o resultado de uma tentativa de deixar o desenvolvimento com SpriteKit mais estruturado para facilitar o seu entendimento.

O jogo de exemplo que desenvolvi para expor esta arquitetura é um infinite runner bem simples, que conta com todos os elementos básicos que se espera de um jogo: uma personagem que tem movimentos, ações, animações, pontos de vida, sons, que existe em um ambiente animado com inimigos que reagem a personagem e tentam acabar com a existência dela, e claro, com uma boa trilha sonora de fundo também.

![]({{img}}/game.jpeg)
<p class="center muted caption">Toda a arte deste jogo é composta de assets de domínio público, criados pelo ótimo <a href="https://kenney.nl">Kenney</a></p>

O objeto básico do SpriteKit é o `SKNode`, todos os objetos que vão ser utilizados no contexto dele são do mesmo tipo, e quando juntos, formam uma árvore de nós pais e filhos, com métodos prontos para acessá-los.

{% include posts/spritekit/node-doc.html %}
{% include posts/spritekit/node-draw.html %}

Quando um nó qualquer é criado, o SpriteKit automaticamente organiza a sua cadeia com essa estrutura, e podemos assim criar uma forma de comunicação padronizada entre os nós. Com um objeto base e uma simples extension, nosso nó pode receber um evento e escolher propagar, modificar ou impedir que este evento continue pela cadeia: 

{% highlight swift %}
@objc class Event: NSObject {}

extension SKNode: EventHandler {
    @objc func handle(event: Event) {
        guard !children.isEmpty else { return }
        children.forEach { $0.handle(event: event) }
    }

    @objc func raise(event: Event) {
        parent?.raise(event: event)
    }
}
{% endhighlight %}

Com estes dois métodos, quando criarmos um nó qualquer, ele automaticamente propaga o evento passado para baixo ou para cima na cadeia e quando quisermos causar alguma mudança no evento, podemos lidar com eles assim:

{% highlight swift %}
final class MyNode: SKNode {
    override func handle(event: Event) {
        // lido com os eventos da forma que eu quiser
        super.handle(event: event) // e passo eles pra frente, caso necessário
    }

    override func raise(event: Event) {
        // faço o que quero com meu evento
        super.raise(event: event) // e continuo a propagação do evento para cima na árvore
    }
}
{% endhighlight %}

Também podemos criar elementos na árvore que não fazem parte do SpriteKit, que não são necessariamente um `SKNode`, para lidar com elementos externos, como uma view do `UIKit`, um objeto que controle o haptic feedback do device pra gente, etc. Para isso, utilizo o protocolo `EventHandler`, que meus `SKNodes` implementam:

{% highlight swift %}
protocol EventHandler: AnyObject {
    func handle(event: Event)
    func raise(event: Event)
}
{% endhighlight %}

Agora que temos uma base, podemos começar a criar nossos objetos, eventos e a interação que pode acontecer entre eles. Para começar, estabeleço toda a criação dos nós de UI, da fase e do personagem no começo do ciclo de vida de minha `SKScene`

{% highlight swift %}    
override func didMove(to view: SKView) {
    setupHandlers()
    setupSpeed()
}

func setupHandlers() {
    let sknodes = [
        UIController(),
        LevelController(),
        PlayerController()
    ]
    sknodes.forEach(addChild)
}

func setupSpeed() {
    handle(event: SpeedEvent(speed: 30))
}
{% endhighlight %}

Cada evento que será passado pelo sistema é um objeto completo que pode apenas indicar alguma coisa que aconteceu, ou carregar dados adicionais sobre o evento em si, como o `SpeedEvent`, que define a velocidade do jogo, e cada objeto meu lida com ele da forma que desejar:

{% highlight swift %}
final class SpeedEvent: Event {
    let speed: CGFloat

    init(speed: CGFloat) {
        self.speed = speed
    }
}

// VisibleFloor.swift 
override func handle(event: Event) {
    if let event = event as? SpeedEvent {
        floorSpeed = event.speed
        removeAllActions()
        animateTiles()
    }
}

// EnemyController.swift
override func handle(event: Event) {
    if let event = event as? SpeedEvent {
        floorSpeed = event.speed
        removeAllActions()
        animateEnemies()
    }
}
{% endhighlight %}

Para lidar com eventos que apenas indicam algum acontecimento no sistema, podemos simplificar o processo:

{% highlight swift %}
// AudioController.swift
override func handle(event: Event) {
    if event is DeathEvent {
        playDeathSound()
    }
}
{% endhighlight %}

E por fim, para mostrar a facilidade de se criar objetos que interagem com o sistema como um todo e causam efeitos na cadeia, mesmo que não sejam SKNodes, para adicionar suporte aos controles de Xbox One e PlayStation 4 no nosso jogo, podemos simplesmente adicionar uma classe como esta: 

{% highlight swift %}
import GameController

final class GameController: EventHandler {

    private weak var parent: EventHandler?
    private var controller: GCController?

    init(parent: EventHandler) {
        self.parent = parent
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupInput),
                                               name: .GCControllerDidConnect, 
                                               object: nil)
    }

    @objc func setupInput() {
        self.controller = GCController.controllers().first
        controller?.extendedGamepad?.buttonA.pressedChangedHandler = { [weak self] (_,_, pressed) in
            if pressed {
                self?.raise(event: InteractionEvent(type: .tap))
            }
        }
    }

    func handle(event: Event) {}

    func raise(event: Event) {
        parent?.raise(event: event)
    }

}
{% endhighlight %}

A talk que fiz tem um hands-on no final que mostra essa arquitetura toda funcionando, incluindo um live code que mostra o quão fácil é incluir novas funcionalidades e criar objetos que interagem com o sistema de forma dinâmica, sem a necessidade de objetos que conhecem uns aos outros diretamente. O projeto completo do jogo pode ser visto no [meu GitHub](https://github.com/loloop/SpriteKitCocoaHeadsES)
