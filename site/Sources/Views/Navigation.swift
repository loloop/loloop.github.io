//
//  Navigation.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/2/25.
//

import Ignite

struct Navigation: InlineElement {
    var body: some HTML {
        Section(tag: "nav") {
            Section {
                Link(target: "/") {
                    Text("MC")
                        .fontWeight(.medium)
                }
                .class("inverted")
                .id("title")

                List {
                    Link(target: "/") {
                        Text("artigos")
                    }
                    .class("inverted")
                    
                    Link(target: "/apps") {
                        Text("apps")
                    }
                    .class("inverted")
                    
                    Link(target: "/me") {
                        Text("contato")
                    }
                    .class("inverted")
                    
                    Link(target: "https://nsbrazil.com") {
                        Text("NSBrazil")
                    }
                    .class("inverted")
                    
//                    Text("artigos")
//                    Text("apps")
//                    Text("contato")
//                    Text("NSBrazil")
                }
                
            }
            .class("site-navigation")
        }
    }
}
