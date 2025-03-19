//
//  Content+Language.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/18/25.
//

import Ignite

extension Content {
    var language: Language {
        guard
            let lang = metadata["lang"] as? String,
            let language = Language(rawValue: lang)
        else { return .portugueseBrazil }
        
        return language
    }
}
