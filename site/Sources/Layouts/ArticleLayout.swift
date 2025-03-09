//
//  ArticleLayout.swift
//  IgniteStarter
//
//  Created by Mauricio on 2/16/25.
//

import Ignite

struct ArticleLayout: ContentLayout {
    var body: some HTML {
        Section(tag: "article") {
            if let header = content.metadata["header"] as? String {
                Image(decorative: "/images"+header)
                    .class("rounded")
            }
            
            Text(content.title)
                .font(.title1)
             Text(parsedText)
        }
    }
    
    var parsedText: String {
        // TODO: Explain that MarkdownToHTML cannot for the life of god
        // TODO: render multi line code blocks properly without the
        // TODO: default Ignite syntax highlighting js code.
        // Setting `markdownRenderer` in the site does not affect `Text`'s
        // markdown rendering. We have to parse with a different renderer.
        do {
            return try InkMarkdownRenderer(
                markdown: content.body,
                removeTitleFromBody: true
            ).body
        } catch {
            return ""
        }
    }
}
