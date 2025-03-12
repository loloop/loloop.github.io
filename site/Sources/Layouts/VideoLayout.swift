//
//  VideoLayout.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/2/25.
//

import Ignite

struct VideoLayout: ContentLayout {
    var body: some HTML {
        Text {
            """
            <iframe width="100%" height="500" src="\(videoURL)" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
            """
        }
        
        Text(content.title)
            .font(.title1)
        
        Text(inkMarkdown: content.body)
    }
    
    var videoURL: String {
        if let url = content.metadata["video"] as? String {
            url
        } else {
            fatalError("URL not found")
        }
    }
}
