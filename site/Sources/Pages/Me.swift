import Foundation
import Ignite

struct Me: StaticLayout {
    var title: String { language == .english ? "Contact Info" : "Contato" }
    var path: String { language == .english ? "contact" : "me" }
    var language: Language

    var body: some HTML {
        Section {
            Text(language == .english ? "contact" : "contato")
                .font(.title1)
                .id("contato")
            
            Text {
                ForEach(ContactInfo.allCases) { info in
                    Link(target: info.url) {
                        Strong(info.name)
                        Span(info.completion)
                    }
                    .class("inverted light")
                    "<br>"
                }
            }
        }
    }
}

private struct ContactInfo {
    let name: String
    let completion: String
    let url: String
}

extension ContactInfo: CaseIterable {
    static var allCases: [ContactInfo] {
        [
            .init(
                name: "linkedin",
                completion: "/in/mauricio-cardozo",
                url: "https://www.linkedin.com/in/mauricio-cardozo/"
            ),
            .init(
                name: "github",
                completion: " @loloop",
                url: "https://github.com/loloop"
            ),
            .init(
                name: "bluesky",
                completion: " @mauriciocardozo.me",
                url: "https://bsky.app/profile/mauriciocardozo.me"
            ),
            .init(
                name: "instagram",
                completion: " @cocoa.mauricio",
                url: "https://instagram.com/cocoa.mauricio"
            ),
            .init(
                name: "iOSDevBR",
                completion: " @mauricio",
                url: ""
            ),
        ]
    }
}
