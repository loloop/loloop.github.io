//
//  Text+Markdown.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/9/25.
//

import Ignite

extension Text {
    // TODO: Explain that MarkdownToHTML cannot for the life of god
    // TODO: render multi line code blocks properly without the
    // TODO: default Ignite syntax highlighting js code.
    // Setting `markdownRenderer` in the site does not affect `Text`'s
    // markdown rendering. We have to parse with a different renderer.
    init(inkMarkdown: String) {
        let body = try? InkMarkdownRenderer(
            markdown: inkMarkdown,
            removeTitleFromBody: true
        ).body

        self.init(body ?? "inkMarkdown error")
    }
}
