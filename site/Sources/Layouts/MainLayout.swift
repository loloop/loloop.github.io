import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some HTML {
        // TODO: Fix this for en_US articles
        HTMLDocument(language: .portugueseBrazil) {
            Head(for: page) {
                // OpenGraph
                MetaTag(name: "og:type", content: "article")
                MetaTag(name: "og:locale", content: "pt_BR") // TODO: Fix this for en_US articles
                MetaTag(.openGraphDescription, content: page.description)

                MetaLink(href: "/css/style.css", rel: .stylesheet)
            }
            Body {
                Navigation()
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
