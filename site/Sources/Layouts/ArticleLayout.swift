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
            Text(inkMarkdown: content.body)
        }
    }
}
