//
//  ContentLoader+Filters.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/18/25.
//

import Ignite

extension ContentLoader {
    var homeContent: [Content] {
        all.filter {
            !$0.isHidden && $0.language == .portugueseBrazil
        }
    }
    
    var englishLanguageContent: [Content] {
        homeContent.filter {
            !$0.isHidden && $0.language == .english
        }
    }
}
