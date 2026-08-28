import Foundation
import Ignite

struct ResidentEvilGame {
    let slug: String
    let name: String
    let key: String

    static let all: [ResidentEvilGame] = [
        .init(slug: "re2", name: "RE2", key: "Club Key"),
        .init(slug: "re4", name: "RE4", key: "Jet Ski Key"),
        .init(slug: "re7", name: "RE7", key: "Crow Key")
    ]

    var title: String {
        "\(name) — \(key)"
    }

    var pagePath: String {
        "ref/resident-evil/\(slug)"
    }

    @MainActor var imagePaths: [String] {
        assetFiles(at: "images/ref/resident-evil/\(slug)")
    }

    @MainActor var modelPaths: [String] {
        assetFiles(at: "models/ref/resident-evil/\(slug)")
            .filter { $0.hasSuffix(".stl") }
    }

    // Enumerated at build time so images and models dropped into the
    // asset folders show up on the next rebuild without code changes.
    @MainActor private func assetFiles(at relativePath: String) -> [String] {
        let directory = PublishingContext.default
            .sourceDirectory
            .appending(path: "Assets/\(relativePath)")

        let files = (try? FileManager.default
            .contentsOfDirectory(atPath: directory.path())) ?? []

        return files
            .filter { !$0.hasPrefix(".") }
            .sorted()
            .map { "/\(relativePath)/\($0)" }
    }
}

struct ResidentEvilRefIndex: StaticLayout {
    var title = "Tatuagens"
    var path = "ref/resident-evil"
    var language = Language.portugueseBrazil
    var parentLayout: RefLayout { RefLayout() }

    var body: some HTML {
        Section {
            Text("tatuagens")
                .font(.title1)
        }

        Section {
            ForEach(ResidentEvilGame.all) { game in
                Link(target: "/\(game.pagePath)") {
                    Image(decorative: game.imagePaths.first ?? "")
                    Text(game.title)
                    Text("ver referências →")
                        .class("ref-cta")
                }
                .class("inverted")
            }
        }
        .class("re-ref-index")
    }
}

struct ResidentEvilRefGame: StaticLayout {
    let game: ResidentEvilGame

    var title: String { game.title }
    var path: String { game.pagePath }
    var language = Language.portugueseBrazil
    var parentLayout: RefLayout { RefLayout() }

    var body: some HTML {
        Section {
            Text(game.title)
                .font(.title1)
        }

        Section {
            ForEach(game.imagePaths) { imagePath in
                Image(decorative: imagePath)
            }
        }
        .class("moodboard")

        if !game.modelPaths.isEmpty {
            let sources = game.modelPaths
                .map { "\"\($0)\"" }
                .joined(separator: ", ")
            Script(code: "window.reModels = [\(sources)];")
            Script(file: "/js/stl-viewer.js")
        }
    }
}
