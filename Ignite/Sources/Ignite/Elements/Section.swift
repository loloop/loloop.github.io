//
// GroupBox.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container element that wraps its children in a `div` element.
///
/// Use `Section` when you want to group elements together and have them rendered
/// within a containing HTML `div`. This is useful for applying shared styling,
/// creating layout structures, or logically grouping related content.
///
/// - Note: Unlike ``Group``, modifiers applied to a `Section` affect the
///         containing `div` element rather than being propagated to child elements.
public struct Section: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString
    
    var tag: String = "div"

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    var items: [any HTML] = []
    
    /// Initializes an HTML element with a specified tag and content.
    ///
    /// - Parameters:
    ///   - tag: A `String` representing the HTML tag for this element. Defaults to `"div"`.
    ///   - content: A closure that returns an `HTML`-conforming value, constructed using an `@HTMLBuilder` result builder.
    ///
    /// This initializer assigns the provided `tag` to the instance and processes
    /// the `content` using `flatUnwrap(_:)` to handle any optional or nested HTML structures.
    ///
    /// ### Example Usage
    /// ```swift
    /// Section {
    ///     Text {
    ///         "Hello, world!"
    ///     }
    /// }
    /// ```
    /// This creates an HTML element with a default `<div>` tag containing a `<p>` element with text.
    ///
    /// If a custom tag is needed:
    /// ```swift
    /// Section(tag: "section") {
    ///     Text("This is a section.")
    /// }
    /// ```
    /// This produces a `<section>` element instead of the default `<div>`.
    public init(
        tag: String = "div",
        @HTMLBuilder content: () -> some HTML
    ) {
        self.tag = tag
        self.items = flatUnwrap(content())
    }

    public init(_ items: any HTML) {
        self.items = flatUnwrap(items)
    }

    public func render() -> String {
        let content = items.map { $0.render() }.joined()
        var attributes = attributes
        attributes.tag = tag
        return attributes.description(wrapping: content)
    }
}
