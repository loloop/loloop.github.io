//
//  VideoLayout.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/2/25.
//

import Ignite

struct VideoLayout: ContentLayout {
    var body: some HTML {
        Text(markdown: content.body)
    }
}
