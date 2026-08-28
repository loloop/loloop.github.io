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

    // Enumerated at build time so images dropped into the asset
    // folder show up on the next rebuild without code changes.
    @MainActor var imagePaths: [String] {
        let assetsPath = "images/ref/resident-evil/\(slug)"
        let directory = PublishingContext.default
            .sourceDirectory
            .appending(path: "Assets/\(assetsPath)")

        let files = (try? FileManager.default
            .contentsOfDirectory(atPath: directory.path())) ?? []

        return files
            .filter { !$0.hasPrefix(".") }
            .sorted()
            .map { "/\(assetsPath)/\($0)" }
    }
}

struct ResidentEvilRefIndex: StaticLayout {
    var title = "Resident Evil"
    var path = "ref/resident-evil"
    var language = Language.portugueseBrazil

    var body: some HTML {
        Section {
            Text("resident evil")
                .font(.title1)
        }

        Section {
            ForEach(ResidentEvilGame.all) { game in
                Link(target: "/\(game.pagePath)") {
                    Image(decorative: game.imagePaths.first ?? "")
                    Text(game.title)
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
    }
}
