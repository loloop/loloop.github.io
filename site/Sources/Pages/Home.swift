import Foundation
import Ignite

struct Home: StaticLayout {
    var title = "Home"
    
    @Environment(\.content) var content
    
    var body: some HTML {
        Section {
            Text("Oi, eu sou o Mauricio")
                .font(.title1)
                .class("huge")
            
            Text("Vamos falar sobre tecnologias Apple?")
                .font(.title2)
        }
        .class("intro")
        
        Section {
            ForEach(content.home) { content in
                HomeLink(content: content)
            }
        }
    }
}
