import Foundation
import Ignite

/// A minimal layout for unlisted reference pages: no site navigation,
/// just the content plus a breadcrumb back to the section index.
struct RefLayout: Layout {
    var body: some HTML {
        HTMLDocument(language: page.language) {
            Head(for: page) {
                MetaLink(href: "/css/style.css", rel: .stylesheet)
            }
            Body {
                Section(tag: "main") {
                    Section {
                        if page.url.path() != "/ref/resident-evil" {
                            Text {
                                Link(target: "/ref/resident-evil") {
                                    "← tatuagens"
                                }
                                .class("inverted light")
                            }
                            .class("breadcrumb")
                        }
                        page.body.render()
                    }
                    .class("content")
                }
            }
        }
    }
}
