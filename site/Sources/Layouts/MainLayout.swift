import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some HTML {
        HTMLDocument {
            // TODO: Write own Head
            Head(for: page)
            Head {
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
