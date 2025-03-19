//
//  EnglishHome.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/18/25.
//

import Ignite

struct EnglishHome: StaticLayout {
    var title = "Home"
    var path = "en"
    var language: Language = .english
    
    @Environment(\.content) var content
    
    var body: some HTML {
        Section {
            Text("Hey, it's me, Mauricio")
                .font(.title1)
                .class("huge")
            
            Text("Apple tech talk and the like")
                .font(.title2)
        }
        .class("intro")
        
        Section {
            ForEach(content.englishLanguageContent) {
                HomeLink(content: $0)
            }
        }
    }
}
