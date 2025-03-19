import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some HTML {
        HTMLDocument(language: page.language) {
            Head(for: page) {
                // Additional OpenGraph tags
                MetaTag(name: "og:type", content: "article")
                MetaTag(name: "og:locale", content: page.language.rawValue)
                MetaTag(.openGraphDescription, content: page.description)
                
                // Dart-sass generated style
                MetaLink(href: "/css/style.css", rel: .stylesheet)
            }
            Body {
                Navigation(language: page.language)
                Section(tag: "main") {
                    Section {
                        page.body.render()
                    }
                    .class("content")
                }
            }
        }
    }
}
