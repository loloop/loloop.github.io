---
title: Making MotionEffects with SwiftUI
thumbnail:
description: Have you ever tried applying motion effects to SwiftUI views? No? Come with me!
published: true
header: /motion/header.jpg
layout: ArticleLayout
date: 2020-08-01 00:00:00
translated: Kayque Moraes
language: en
---

The small details make all the difference, and small details make me more happy than they should, because they bring delight, make the small interactions that we have with our devices a little cooler, more fun. And what else can make us happy as developers? SwiftUI, of course!

One of the coolest and super smooth interactions for us to implement in our UIKit apps is the `UIInterpolationMotionEffect`, which gives that parallax effect when we move the phone, better known as the [Perspective effect](https://support.apple.com/pt-br/HT200285) that we can apply on the background images of our iPhones and iPads. But when I tried to add one in my SwiftUI View, I got caught by this:

![Image with a SwiftUI view where a motionEffect fails to apply, because it doesn't exist](motion/motionError.png)

Then I discovered, searching through the documentation, that there is no way to place an effect like this natively with SwiftUI! My first thought was to create a `UIViewRepresentable` that had my View inside a SwiftUI container, making a SwiftUI -> UIKit -> SwiftUI bridge, which I tried to do, without much success.

So I decided to see if it was possible to read the device’s sensor and manually recreate this behavior, creating a view that seems more "native" to SwiftUI. And with [CoreMotion](https://developer.apple.com/documentation/coremotion) all of this is not only possible but also very easy, and it will be easier for us to create composite effects, such as elements that move at different speeds according to my device’s movement.

To access the device's accelerometer/gyroscope data, we need a `CMMotionManager` instance, that [according to Apple’s recommendations](https://developer.apple.com/documentation/coremotion/cmmotionmanager), needs to be shared:

```swift
import CoreMotion

extension CMMotionManager {
    static var shared = CMMotionManager()
}
```

With `CMMotionManager`, we can access the accelerometer, gyroscope, magnetometer, and device-motion, which is a multitude of data inferred by the Core Motion algorithms. Because I want to make my effect with the device’s rotation, I will use the gyroscope, which measures each rotation axis of the device. First, I will create a `View` that is going to handle this reading and, just like the [GeometryReader](https://developer.apple.com/documentation/swiftui/geometryreader) does, expose this data to child views, and make the necessary `MotionManager` settings in it, like the data update interval (with an update frequency of 30x per second), the start/end of data reading, and the publisher where we will read and process this data:

```swift
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
        .onReceive(timer) { _ in }
    }
}
```

And then we can start reading our manager’s data, changing `onReceive`. I also created a `struct` that encapsulates the gyroscope data (x,y, and z axes) to pass it to our child views:

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
<span class="caption muted">I had to shake <strong>a lot</strong> to get this little bit of change</span>
</p>

Doing all this, we must run the app on the device (the simulator doesn’t have CoreMotion support, unfortunately), and then we can attest that almost nothing has changed, and the little that has is not noticeable when we use the device itself, being only visible on a video on a still screen. Furthermore, the movement is very shaky.

The values that the gyroscope emits are very low, so we need to manipulate them in a way that the `offset` of the card is altered with more intensity, and we can set some limits, like the `minimumRelativeValue` and `maximumRelativeValue` properties of the `UIInterpolationMotionEffect`, in addition to adding a basic animation to the view, so that the shaking stops:

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
    <span class="caption muted">It's much smoother now, right? I was shaking the iPad again</span>
</p>

Now in addition to having a much smoother animation, we can set all the movement values so that the effect is exactly the way we want! But when turning the device, we can see that the movement is not going in the same direction when we move our device. Why? The x and y coordinates of my view and the coordinates that the gyroscope is emitting are not consistent in each orientation, so we need to calculate and swap the values.

For this, we need to create a way to detect when the device changes orientation and change the offset calculation accordingly, and this is very simple:

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

Finally, our reader should respect any setting that the user can make on the device, such as [low power mode](https://developer.apple.com/documentation/foundation/processinfo/1617047-islowpowermodeenabled) and accessibility configuration to [reduce motion](https://developer.apple.com/videos/play/wwdc2019/244/):

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

As a cherry on top to make it easier to use our Reader, we will create a `View` extension that does the entire parallaxing automatically for us!

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

And with this, our code from the beginning works perfectly, the way that I wanted it to work :)

![Image with a SwiftUI view where a motionEffect is applied successfully](motion/motionSucc.png)

The complete project with the card example and the gyroscope reader is on my [GitHub](https://github.com/loloop/SwiftInMotion), and I would like to thank [@Alan Pégoli](https://twitter.com/alanpegoli) who did the beta test and pointed out a glaring flaw in the article :)


