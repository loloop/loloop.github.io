//
// Site.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that defines the configuration and structure of an Ignite website.
///
/// The `Site` protocol is the core configuration point for your Ignite website. It defines
/// everything from basic metadata like the site's name and author, to the layout structure,
/// theming, and content organization.
///
/// To create a site, create a type that conforms to this protocol and implement the required
/// properties. Many properties have default implementations that provide common functionality,
/// which you can override as needed.
///
/// ```swift
/// struct MySite: Site {
///     var name = "My Awesome Site"
///     var url = URL(string: "https://example.com")!
///     var homePage = HomeView()
///     var layout = MainLayout()
///     var darkTheme: (any Theme)? = nil
/// }
/// ```
///
/// - Important: When implementing optional properties like `lightTheme` and `darkTheme`,
///   ensure the return type exactly matches the protocol requirement, e.g., `(any Theme)?`.
///   Swift's type system requires this exact match.
@MainActor
public protocol Site: Sendable {
    /// The type of your homepage. Required.
    associatedtype HomePageLayout: StaticLayout

    /// The type used to generate your tag pages. A default is provided that means
    /// no tags pages are generated.
    associatedtype TagPageLayout: TagLayout

    /// The type that defines the base layout structure for all pages.
    associatedtype LayoutType: Layout

    /// The Markdown parser to use for Content pages.
    associatedtype MarkdownRendererType: MarkdownRenderer

    /// A robots.txt configuration for your site. A default is provided that means
    /// all robots can index all pages.
    associatedtype RobotsType: RobotsConfiguration

    /// The author of your site, which should be your name.
    /// Defaults to an empty string.
    var author: String { get }

    /// A string to append to the end of your page titles. For example, if you have
    /// a page titled "About Me" and a site title suffix of " – My Awesome Site", then
    /// your rendered page title will be "About Me – My Awesome Site".
    /// Defaults to an empty string.
    var titleSuffix: String { get }

    /// The name of your site. Required.
    var name: String { get }

    /// An optional description for your site. Defaults to nil.
    var description: String? { get }

    /// The language your site is published in. Defaults to `.en`.
    var language: Language { get }

    /// The base URL for your site, e.g. https://www.example.com
    var url: URL { get }

    /// The time zone used for date outputs in your site. Defaults to `.gmt`.
    var timeZone: TimeZone? { get }

    /// Choose whether to use a local version of Bootstrap, a remote version,
    /// or none at all
    var useDefaultBootstrapURLs: BootstrapOptions { get }

    /// Set to `localBootstrap` if you want to use the Bootstrap icon collection on your site.
    /// and use a local copy of the files or `remoteBootstrap` if you want to use the icon
    /// collection and load the files from a CDN
    /// Visit https://icons.getbootstrap.com for the full list.
    var builtInIconsEnabled: BootstrapOptions { get }

    /// The Markdown renderer to use for content in this site. Note: This
    /// only applies to content pages rendered from the Content folder;
    /// the standard MarkdownToHTML parser is used for `Text` and
    /// other built-in elements regardless of the setting here.
    var markdownRenderer: MarkdownRendererType.Type { get }

    /// Controls how the RSS feed for your site should be generated. The default
    /// configuration sends back content description only for 20 items. To disable
    /// your site's RSS feed, set this property to `nil`.
    var feedConfiguration: FeedConfiguration? { get }

    /// Controls how search engines and similar index your site. The default
    /// configuration allows all robots to index everything.
    var robotsConfiguration: RobotsType { get }

    /// The homepage for your site; what users land on when visiting your root domain.
    var homePage: HomePageLayout { get }

    /// A type that conforms to `TagLayout`, to be used when rendering individual
    /// tag pages or the "all tags" page.
    var tagLayout: TagPageLayout { get }

    /// The base layout applied to all pages. This is used to render all pages that don't
    /// explicitly override the layout with something custom.
    var layout: LayoutType { get }

    /// The theme used when the system is in light mode.
    var lightTheme: (any Theme)? { get }

    /// The theme used when the system is in dark mode.
    var darkTheme: (any Theme)? { get }

    /// Additional themes that can be selected by users beyond light and dark mode.
    var alternateThemes: [any Theme] { get }

    ///  The syntax highlighters used throughout the site. Highlighters used
    ///  in Markdown files _must_ be included here. Highlighters specified in `CodeBlock`
    ///  will be added automatically.
    var syntaxHighlighters: [HighlighterLanguage] { get }

    /// Controls whether HTML output should be formatted with proper indentation.
    ///
    /// - Important: If your site has code blocks containing angle brackets (`<`...`>`),
    /// such as Swift generics, the prettifier will interpret these as HTML tags
    /// and break the code's formatting. To avoid this issue, either set this property
    /// to `false` or replace `<` and `>` with their character entity references,
    /// `&lt;` and `&gt;` respectively.
    var prettifyHTML: Bool { get }

    /// The path to the favicon
    var favicon: URL? { get }

    /// An array of all the static layouts you want to include in your site.
    @StaticLayoutBuilder var staticLayouts: [any StaticLayout] { get }

    /// An array of all the content layouts you want to include in your site.
    @ContentLayoutBuilder var contentLayouts: [any ContentLayout] { get }

    /// Publishes this entire site from user space.
    func publish(from file: StaticString, buildDirectoryPath: String) async throws
}

public extension Site {
    /// No default author.
    var author: String { "" }

    /// No default title suffix.
    var titleSuffix: String { "" }

    /// No default description.
    var description: String? { nil }

    /// English as default language.
    var language: Language { .english }

    /// Uses `.gmt` as the default.
    var timeZone: TimeZone? { .gmt }

    /// Uses the default light theme based on Bootstrap.
    var lightTheme: (any Theme)? { DefaultLightTheme() }

    /// Uses the default dark theme based on Bootstrap.
    var darkTheme: (any Theme)? { DefaultDarkTheme() }

    /// No additional themes by default.
    var alternateThemes: [any Theme] { [] }

    /// Formats HTML output with proper indentation by default.
    var prettifyHTML: Bool { true }

    /// No syntax highlighter languages by default.
    var syntaxHighlighters: [HighlighterLanguage] { [] }

    /// Enable local Bootstrap files by default
    var useDefaultBootstrapURLs: BootstrapOptions { .localBootstrap }

    /// Disable Bootstrap icons by default.
    var builtInIconsEnabled: BootstrapOptions { .localBootstrap }

    /// Use the standard MarkdownToHTML renderer by default.
    var markdownRenderer: MarkdownToHTML.Type {
        MarkdownToHTML.self
    }

    /// A default feed configuration allows 20 items of content, showing just
    /// their descriptions.
    var feedConfiguration: FeedConfiguration? { .default }

    /// A default robots.txt configuration that allows all robots to index all pages.
    var robotsConfiguration: DefaultRobotsConfiguration { DefaultRobotsConfiguration() }

    /// No static layouts by default.
    var staticLayouts: [any StaticLayout] { [] }

    /// No content layouts by default.
    var contentLayouts: [any ContentLayout] { [] }

    /// An empty tag layout by default, which triggers no tag pages being made.
    var tagLayout: EmptyTagLayout { EmptyTagLayout() }

    /// The default favicon being nil
    var favicon: URL? { nil }

    /// The syntax highlighting themes from every site theme.
    internal var allHighlighterThemes: OrderedSet<HighlighterTheme> {
        var themes = OrderedSet<HighlighterTheme>()

        if let theme = lightTheme?.syntaxHighlighterTheme {
            themes.append(theme)
        }
        if let darkTheme = darkTheme?.syntaxHighlighterTheme {
            themes.append(darkTheme)
        }
        themes.formUnion(alternateThemes.compactMap(\.syntaxHighlighterTheme))
        themes.remove(.none)
        return .init(themes.sorted())
    }

    /// An array of every site theme.
    internal var allThemes: [Theme] {
        var themes = [Theme]()
        if let lightTheme = lightTheme {
            themes.append(lightTheme)
        }
        if let darkTheme = darkTheme {
            themes.append(darkTheme)
        }
        if darkTheme != nil, lightTheme != nil {
            themes.append(AutoTheme())
        }
        themes.append(contentsOf: alternateThemes)
        return themes
    }

    internal var supportsLightTheme: Bool {
        lightTheme != nil
    }

    internal var supportsDarkTheme: Bool {
        darkTheme != nil
    }
    
    func initialize(
        from file: StaticString = #filePath,
        buildDirectoryPath: String = "Build"
    ) throws {
        try PublishingContext.initialize(
            for: self,
            from: file,
            buildDirectoryPath: buildDirectoryPath
        )
    }

    /// Performs the entire publishing flow from a file in user space, e.g. main.swift
    /// or Site.swift.
    /// - Parameters:
    ///   - file: The path of the file that triggered the build. This is used to
    ///   locate the base directory for their project, so we can find
    ///   key folders.
    ///   - buildDirectoryPath: This path will generate the necessary
    ///   artifacts for the web page. Please modify as needed.
    ///   The default is "Build".
    func publish(from file: StaticString = #filePath, buildDirectoryPath: String = "Build") async throws {
        let context = PublishingContext.default
        try await context.publish()

        if !context.warnings.isEmpty || !context.errors.isEmpty {
            print("📘 Publish completed with exceptions:")
            print(context.errors.map { "\t📕 \($0.errorDescription!)" }.joined(separator: "\n"))
            print(context.warnings.map { "\t📙 \($0)" }.joined(separator: "\n"))
        } else {
            print("📗 Publish completed!")
        }
    }
}
