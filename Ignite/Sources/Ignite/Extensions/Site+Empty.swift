//
//  Site+Empty.swift
//  Ignite
//
//  Created by Mauricio on 3/9/25.
//

struct EmptySite: Site {    
    var author = ""
    var name = ""
    var titleSuffix = ""
    var url = URL(static: "https://example.com")
    var builtInIconsEnabled = BootstrapOptions.none
    var homePage = EmptyHome()
    var layout = EmptyLayout()
    var contentLayouts: [any ContentLayout] = []
    var useDefaultBootstrapURLs = BootstrapOptions.none
}

struct EmptyHome: StaticLayout {
    var title = ""
    var body: some HTML {
        EmptyHTML()
    }
}
