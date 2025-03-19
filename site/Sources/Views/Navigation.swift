//
//  Navigation.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/2/25.
//

import Ignite

struct Navigation: InlineElement {
    
    var language: Language
    
    var body: some HTML {
        Section(tag: "nav") {
            Section {
                Link(target: language == .english ? "/en" : "/") {
                    Text("MC")
                        .fontWeight(.medium)
                }
                .class("inverted")
                .id("title")

                List {
                    articleLink
                    
                    Link(target: language == .english ? "/en/apps" : "/apps") {
                        Text("apps")
                    }
                    .class("inverted")
                                        
                    contactLink
                    
                    Link(target: "https://nsbrazil.com") {
                        Text("NSBrazil")
                    }
                    .class("inverted")
                    
                    langLink
                }
                
            }
            .class("site-navigation")
        }
    }
    
    var articleLink: Link {
        if language == .english {
            Link(target: "/en") {
                Text("articles")
            }
            .class("inverted")
        } else {
            Link(target: "/") {
                Text("artigos")
            }
            .class("inverted")
        }
    }
    
    var contactLink: Link {
        if language == .english {
            Link(target: "/contact") {
                Text("contact")
            }
            .class("inverted")
        } else {
            Link(target: "/me") {
                Text("contato")
            }
            .class("inverted")
        }
    }
    
    var langLink: Link {
        if language == .english {
            Link(target: "/") {
                Text("🇧🇷")
            }
            .class("inverted")
        } else {
            Link(target: "/en") {
                Text("🇺🇸")
            }
            .class("inverted")
        }
    }
}
