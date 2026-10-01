import Ignite

struct MetricsLabPage: StaticLayout {
    var title = "MetricsLab"
    var path = "metricslab"
    var language = Language.english
    var description = "A free native laboratory for SwiftUI, UIKit, and live window geometry on iPhone and iPad."

    var body: some HTML {
        Section(tag: "article") {
            Image("/images/apps/metricslab.png", description: "MetricsLab app icon")
                .style(.width, "96px")
                .style(.height, "96px")
                .class("rounded")
            Text("MetricsLab").font(.title1)
            Text("Native UI, measured on your device.").font(.title2)
            Text("MetricsLab is a free native utility for iPhone and iPad developers. Its catalog contains 19 interactive labs for exploring SwiftUI and UIKit behavior, alongside live measurements of the app’s window.")
            Text("Preparing for its first App Store release. Requires iOS or iPadOS 27.1. Free, always.")

            Text("Explore the labs").font(.title2)
            Text {
                Strong("Window Metrics. ")
                "Inspect bounds, safe-area insets, size classes, device and scene orientation, and reserved regions in the window you are using."
            }
            Text {
                Strong("Native UI. ")
                "Compare adaptive arrangements, toolbars, native and custom tabs, presentations, collections, and multiple windows across SwiftUI and UIKit."
            }
            Text {
                Strong("Geometry and camera behavior. ")
                "Experiment with container sizing, fitting layouts, orientation requests, live camera preview, and display accessories. Hardware-specific behavior depends on the device and its current configuration."
            }
            Text("Each lab runs inside MetricsLab with bundled examples. Window Metrics measures MetricsLab’s own window.")

            Text("Privacy").font(.title2)
            Text("No accounts, ads, analytics, or tracking. Measurements stay on your device. Optional camera access provides live preview without recording photos or videos.")
            Text {
                Link("Read the privacy policy", target: "/metricslab/privacy/")
                    .class("inverted")
            }

            Text("Support").font(.title2).id("support")
            Text("For questions or bug reports, contact Mauricio through the profiles on the contact page. Include your device, iOS or iPadOS version, the lab name, and the steps needed to reproduce the issue.")
            Text {
                Link("Contact Mauricio", target: "/contact/")
                    .class("inverted")
            }
        }
    }
}

struct MetricsLabPrivacyPage: StaticLayout {
    var title = "MetricsLab Privacy Policy"
    var path = "metricslab/privacy"
    var language = Language.english
    var description = "How MetricsLab handles window measurements, camera access, and local app state."

    var body: some HTML {
        Section(tag: "article") {
            Text("MetricsLab Privacy Policy").font(.title1)
            Text("Effective September 30, 2026. This policy covers the MetricsLab app for iOS and iPadOS, developed by Mauricio Cardozo.")

            Text("Data collection").font(.title2)
            Text("MetricsLab does not collect or transmit personal information, device or window measurements, or camera frames to the developer. The app has no accounts, advertising, analytics services, or tracking. Measurements are processed and displayed on your device.")

            Text("Camera access").font(.title2)
            Text("Camera permission is optional and is requested only when using the Camera lab on supported hardware. It enables a live on-device preview and camera-selection experiments. MetricsLab does not take photos, record video, save preview frames, or upload camera content. You can manage camera permission in the device’s Settings app.")

            Text("Local state").font(.title2)
            Text("Some interface settings may be restored locally by iOS or iPadOS when a scene is reopened. This state stays on your device. MetricsLab has no app-operated cloud storage or synchronization service.")

            Text("Website links and support").font(.title2)
            Text("Opening a website or contact link uses your browser and the destination’s own privacy practices. If you choose to contact the developer through an external profile, the information you share is handled by that service and used by the developer to respond to your request. This policy describes the app’s data handling, rather than the practices of those external services.")

            Text("Changes and contact").font(.title2)
            Text("If MetricsLab’s data practices change, this policy and the App Store privacy information will be updated. For privacy questions, use the contact profiles linked below.")
            Text {
                Link("Contact Mauricio", target: "/contact/").class("inverted")
                " · "
                Link("MetricsLab support", target: "/metricslab/#support").class("inverted")
            }
        }
    }
}
