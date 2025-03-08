//
//  HomeLink.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/2/25.
//

import Ignite

struct HomeLink: BlockHTML {
    var columnWidth = ColumnWidth.automatic

    let content: Content

    var body: some HTML {
        Section {
            Text {
                Link(content)
                    .class("inverted")
            }
            .font(.title2)
            
            Text(markdown: content.description)
        }
    }
}
