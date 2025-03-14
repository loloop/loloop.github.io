---
title: Fazendo MotionEffects com SwiftUI
thumbnail: 
description: Já tentou aplicar efeitos de movimento em views de SwiftUI? Não? Vem comigo!
published: true
header: /motion/header.jpg
layout: ArticleLayout
date: 2020-08-01 00:00:00
---

Pequenos detalhes fazem toda a diferença, e pequenos detalhes me deixam desproporcionalmente feliz, porque trazem deleite, fazem com que pequenas interações que temos com os nossos aparelhos um sejam pouco mais legais, mais divertidas. E o que mais pode nos fazer felizes, como desenvolvedores? O SwiftUI, é claro! 

Uma das interações mais legais e super tranquilas da gente implementar nos nossos apps UIKit é o UIInterpolationMotionEffect, que dá aquele efeito de parallax quando mexemos o celular, mais conhecido pelo efeito [Perspectiva](https://support.apple.com/pt-br/HT200285) que podemos aplicar nas imagens de fundo de nossos iPhones e iPads. Mas quando tentei adicionar um em minha View de SwiftUI, fui pego por isso daqui:

![Imagem com uma view de SwiftUI onde um motionEffect que tenta ser aplicado nela dá erro, porque não existe](motion/motionError.png)

Eis que descubro, pesquisando pela documentação que não existe uma forma de colocar um efeito desses nativamente com o SwiftUI! Meu primeiro pensamento foi criar uma UIViewRepresentable que tivesse a minha View dentro de um container do SwiftUI, fazendo um bridge de SwiftUI -> UIKit -> SwiftUI, que tentei fazer, mas sem muito sucesso.
 
Decidi então ver se era possível ler os sensores do aparelho e recriar esse comportamento manualmente, criando uma view que me parece mais “nativa” ao SwiftUI. E com o [CoreMotion](https://developer.apple.com/documentation/coremotion) isso tudo não só é possível como é bem fácil, e vai nos dar mais facilidade para criar efeitos compostos, como elementos que se mexem em velocidades diferentes de acordo com o movimento do meu device.

Para acessar os dados do acelerômetro/giroscópio do aparelho, precisamos de uma instância do CMMotionManager, [que segundo as recomendações da Apple](https://developer.apple.com/documentation/coremotion/cmmotionmanager), precisa ser compartilhada:

```
import CoreMotion

extension CMMotionManager {
    static var shared = CMMotionManager()
}
```

Com o `CMMotionManager`, podemos acessar o acelerômetro, giroscópio, magnetômetro e o device-motion, que é uma multitude de dados inferidos pelos algoritmos do Core Motion. Como quero fazer meu efeito com a rotação do device, vou utilizar o giroscópio, que mede cada eixo de rotação do aparelho. Primeiro, crio uma `View` que vai cuidar dessa leitura e, assim como o [GeometryReader](https://developer.apple.com/documentation/swiftui/geometryreader) faz, expor esses dados para views filhas, e nela fazer as configurações necessárias do MotionManager, como o intervalo de update dos dados (com uma frequência de atualização de 30x por segundo), o início/fim da leitura deles e o publisher onde vamos ler e processar esses dados:

```
struct MotionReader<Content>: View where Content: View {

    private let contentView: () -> Content
    private let motionManager: CMMotionManager = .shared
    private let timer = Timer.publish(every: 1/30, on: .main, in: .common).autoconnect()

    init(@ViewBuilder content: @escaping () -> Content) {
        contentView = content
    }

    var body: some View {
        contentView()
        .onAppear {
            self.motionManager.gyroUpdateInterval = 1/30
            self.motionManager.startGyroUpdates()
        }
        .onDisappear {
            self.motionManager.stopAccelerometerUpdates()
        }
        .onReceive(timer) { _ in
        }
    }
}
```

E assim podemos começar a ler os dados do nosso manager, alterando o `onReceive`. Também criei um `struct` que encapsula os dados do giroscópio (eixos x,y e z) para passá-los para nossas child views:

```
/// MotionReader.swift
    private let contentView: (MotionProxy) -> Content
    @State private var currentOffset: MotionProxy = .zero
...
    contentView(currentOffset)
...
    .onReceive(timer) { _ in
        guard let data = self.motionManager.gyroData else { return }
        let rate = data.rotationRate
        self.currentOffset = MotionProxy(x: rate.x, y: rate.y, z: rate.z)
    }

/// ContentView.swift
struct ContentView: some View {
    var body: some View {
        MotionReader { proxy in
            CardView()
                .offset(x: proxy.x, y: proxy.y)
        }
    }
}
```

<video loop autoplay muted>
    <source type="video/mp4" src="/images/motion/effectless.mp4">
</video>
<p>
<span class="caption muted">Tive que balançar <strong>bastante</strong> o iPad pra conseguir esse pouquinho de mudança</span>
</p>


Fazendo isso tudo, devemos rodar o app no device (o simulador não tem suporte ao CoreMotion, infelizmente), e aí, podemos atestar que quase nada mudou, e o pouco que mudou não é perceptível quando utilizamos o aparelho em si, sendo visível apenas pelo vídeo numa tela parada. Além disso, o movimento está muito tremido.

Os valores que o giroscópio emite são muito baixos, então precisamos manipular eles de forma que o `offset` do card seja alterado com mais intensidade, e podemos aproveitar para configurar alguns limites, iguais às propriedades `minimumRelativeValue` e `maximumRelativeValue` do `UIInterpolationMotionEffect`, além de adicionar uma animação básica na view, para que a tremedeira pare:

```
    private let strength: Double
    private let minimum: Double
    private let maximum: Double
...
    init(motionRange: ClosedRange<Double> = (-5.0...5.0),
         motionStrength: Double = 1,
         @ViewBuilder content: @escaping (MotionProxy) -> Content) {
        minimum = motionRange.lowerBound
        maximum = motionRange.upperBound
        contentView = content
        strength = motionStrength * 5
    }

    var body: some View {
        contentView()
        .animation(.linear)
        .onAppear {
            self.motionManager.gyroUpdateInterval = 1/30
            self.motionManager.startGyroUpdates()
        }
        .onDisappear {
            self.motionManager.stopAccelerometerUpdates()
        }
        .onReceive(timer) { _ in
            guard let data = self.motionManager.gyroData else { return }
            let rate = data.rotationRate
            self.currentOffset = calculateOffset(x: rate.x, y: rate.y, z: rate.z)
        }
    }

    private func calculateOffset(x: Double, y: Double, z: Double) -> MotionProxy {
        let xAxis = max(minimum, min((x * strength), maximum))
        let yAxis = max(minimum, min((y * strength), maximum))
        return MotionProxy(x: xAxis, y: yAxis, z: z)
    }
```

<video loop autoplay muted>
    <source type="video/mp4" src="/images/motion/smooth-comp.mp4">
</video>
<p>
    <span class="caption muted">Ficou bem mais suave agora né? Eu tava chacoalhando o iPad de novo</span>
</p>

Agora além de ter uma animação muito mais suave, podemos configurar todos os valores do movimento para que o efeito fique exatamente da forma como desejamos! Mas ao virar o device, podemos perceber que o movimento não está indo pros mesmos lados quando mexemos nosso device. Por que? As coordenadas de x e y da minha view e as coordenadas que o giroscópio está emitindo não são consistentes em cada orientação, então precisamos calcular e fazer essa troca manualmente.

Para isso, precisamos criar uma forma de detectar quando o aparelho muda de orientação, e mudar o cálculo do offset de acordo, e isso é bem simples:
```
/// DeviceOrientation.swift
final class DeviceOrientation: ObservableObject {
    private var observer: AnyCancellable?
    @Published var deviceOrientation: UIDeviceOrientation

    init() {
        deviceOrientation = UIDevice.current.orientation
        observeOrientation()
    }

    private func observeOrientation() {
        observer = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap({ $0.object as? UIDevice})
            .sink { [weak self] device in
                self?.deviceOrientation = device.orientation
            }
    }
}

/// MotionReader.swift
    @ObservedObject var deviceOrientation = DeviceOrientation()
...
    .onReceive(timer) { _ in
        guard let data = self.motionManager.gyroData else { return }
        let rate = data.rotationRate
        self.currentOffset = calculateOffsetForCurrentOrientation(x: rate.x, y: rate.y, z: rate.z)
    }

    private func calculateOffsetForCurrentOrientation(x: Double, y: Double, z: Double) -> MotionProxy {
        let xAxis = max(minimum, min((x * strength), maximum))
        let yAxis = max(minimum, min((y * strength), maximum))

        switch deviceOrientation.deviceOrientation {
        case .portrait:
            return MotionProxy(x: yAxis, y: xAxis, z: z)
        case .portraitUpsideDown:
            return MotionProxy(x: yAxis, y: -xAxis, z: z)
        case .landscapeLeft:
            return MotionProxy(x: -xAxis, y: -yAxis, z: z)
        case .landscapeRight:
            return MotionProxy(x: -xAxis, y: yAxis, z: z)
        case .unknown, .faceDown, .faceUp:
            return MotionProxy(x: xAxis, y: yAxis, z: z)
        @unknown default:
            return MotionProxy(x: xAxis, y: yAxis, z: z)
        }
    }
```

Para finalizar, o nosso Reader deve respeitar qualquer configuração que o usuário possa fazer no aparelho, como o [modo de baixa energia](https://developer.apple.com/documentation/foundation/processinfo/1617047-islowpowermodeenabled) e a configuração de acessibilidade para [reduzir movimentos](https://developer.apple.com/videos/play/wwdc2019/244/). Para isso, precisamos criar duas propriedades, uma para acessar o Environment que representa o Reduce Motion e uma que encapsula todas as barreiras de acesso ao acelerômetro:

```
/// MotionReader.swift
    @Environment(\.accessibilityReduceMotion) var isReduceMotionOn: Bool
...
    .onAppear {
        guard self.shouldEnableMotion else { return }
        self.motionManager.gyroUpdateInterval = 1/30
        self.motionManager.startGyroUpdates()
    }
...
    .onReceive(timer) { publisher in
        guard self.shouldEnableMotion,
              let data = self.motionManager.gyroData else { return }

        let rate = data.rotationRate
        self.currentOffset = self.calculateOffsetForCurrentOrientation(x: rate.x, y: rate.y, z: rate.z)
    }
...
    private var shouldEnableMotion: Bool {
        !ProcessInfo.processInfo.isLowPowerModeEnabled &&
            motionManager.isAccelerometerAvailable &&
            !isReduceMotionOn
    }
```

Como uma cerejinha em cima do bolo para facilitar o uso do nosso Reader, criaremos uma extension de `View` que faz todo o processo de parallaxing automagicamente para a gente! 

```
extension View {
    func motionEffect(scale: CGFloat = 1.2,
                    range: ClosedRange<Double> = (-5.0...5.0),
                    strength: Double = 1) -> some View {
        MotionReader(motionRange: range, motionStrength: strength) { proxy in
            self
                .scaleEffect(scale)
                .offset(x: proxy.x, y: proxy.y)
        }
    }
}
```

E com isso, o nosso código lá do começo funciona perfeitamente, da forma que eu queria que ele funcionasse :)

![Imagem com uma view de SwiftUI onde um motionEffect é aplicado com sucesso](motion/motionSucc.png)

O projeto completo com o exemplo do card e o reader do giroscópio está no [meu GitHub](https://github.com/loloop/SwiftInMotion), e deixo meus agradecimentos aqui ao [@Alan Pégoli](https://twitter.com/alanpegoli) que fez o beta test e apontou uma falha gritante no artigo :)
