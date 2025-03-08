//
//  ArticleLayout.swift
//  IgniteStarter
//
//  Created by Mauricio on 2/16/25.
//

import Ignite

struct ArticleLayout: ContentLayout {
    var body: some HTML {
        Text(markdown: content.body)
    }
}
