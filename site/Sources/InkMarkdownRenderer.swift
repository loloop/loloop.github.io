//
//  InkMarkdownRenderer.swift
//  IgniteStarter
//
//  Created by Mauricio on 3/9/25.
//

import Ignite
import Ink
import Splash

public struct InkMarkdownRenderer: MarkdownRenderer {
    public var title: String
    
    public var description: String
    
    public var body: String
    
    public var removeTitleFromBody: Bool
    
    public var metadata: [String : String]
    
    public init(markdown: String, removeTitleFromBody: Bool) throws {
        let result = MarkdownParser.default.parse(markdown)

        title = result.title ?? ""
        description = result.metadata["description"] ?? ""
        body = result.html
        metadata = result.metadata
        self.removeTitleFromBody = removeTitleFromBody
    }
    
    public init(url: URL, removeTitleFromBody: Bool) throws {
        let markdown: String
        do {
            markdown = try String.init(contentsOf: url)
        } catch {
            throw InkError.cannotOpenFile
        }

        let result = MarkdownParser.default.parse(markdown)

        title = result.title ?? ""
        description = result.metadata["description"] ?? ""
        body = result.html
        metadata = result.metadata
        self.removeTitleFromBody = removeTitleFromBody
    }
    
    enum InkError: Error {
        case cannotOpenFile
    }
}

extension MarkdownParser {
    static var `default`: MarkdownParser {
        var parser = MarkdownParser()
        let codeBlockModifier = Modifier(target: .codeBlocks) { html, markdown in
            let decorated = MarkdownDecorator().decorate(String(markdown))
            return decorated
        }
        parser.addModifier(codeBlockModifier)
        return parser
    }
}
