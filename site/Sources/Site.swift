import Foundation
import Ignite
import DartSass

@main
struct IgniteWebsite {
    static func main() async {
        // Build site
        let site = ExampleSite()
        do {
            try site.initialize()
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
        
        // Compile and save Sass
        do {
            let sassDirectory = PublishingContext
                .default
                .sourceDirectory
                .appending(path: "_sass/style.scss")

            let compiler = try Compiler()
            let result = try await compiler.compile(fileURL: sassDirectory)
            let fileManager = FileManager.default
            
            let cssFileURL = PublishingContext
                .default
                .buildDirectory
                .appending(path: "css/style.css")
            
            if fileManager.fileExists(atPath: cssFileURL.absoluteString) {
                try fileManager.removeItem(atPath: cssFileURL.absoluteString)
            }
                
            try result
                .css
                .write(
                    to: cssFileURL,
                    atomically: true,
                    encoding: .utf8
                )
            // TODO: prettier message
            print("CSS generated and copied")
        } catch {
            dump(error)
        }
        
        print("Build process ended at", Date())
    }
}

struct ExampleSite: Site {
    var author = "John Appleseed"
    var name = "Hello World"
    var titleSuffix = " – My Awesome Site"
    var url = URL(static: "https://www.example.com")
    var builtInIconsEnabled = BootstrapOptions.none
    var homePage = Home()
    var layout = MainLayout()
    var contentLayouts: [any ContentLayout] = [
        ArticleLayout(),
        VideoLayout()
    ]
    var useDefaultBootstrapURLs = BootstrapOptions.none
    var markdownRenderer: InkMarkdownRenderer.Type {
        InkMarkdownRenderer.self
    }
}
