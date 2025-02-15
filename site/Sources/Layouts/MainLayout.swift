import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some HTML {
        HTMLDocument {
            Head(for: page)
            Body(for: page)
        }
    }
}
