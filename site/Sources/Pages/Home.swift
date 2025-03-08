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
            
            Text("Esse é o meu blog sobre tecnologias Apple e mais algumas outras coisas :)")
                .font(.title2)
        }
        .class("intro")
        
        Section {
            ForEach(content.all) { content in
                HomeLink(content: content)
            }
        }
    }
}
