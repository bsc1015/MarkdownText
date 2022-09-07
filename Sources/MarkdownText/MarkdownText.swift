import SwiftUI
import Markdown

private struct MarkdownContent: View {
    @Environment(\.multilineTextAlignment) private var alignment
    @Environment(\.markdownHeadingStyle) private var headerStyle
    @Environment(\.markdownParagraphStyle) private var paragraphStyle
    @Environment(\.markdownQuoteStyle) private var quoteStyle
    @Environment(\.markdownCodeStyle) private var codeStyle
    @Environment(\.markdownThematicBreakStyle) private var thematicBreak
    @Environment(\.markdownOrderedListStyle) private var orderedStyle
    @Environment(\.markdownUnorderedListStyle) private var unorderedStyle
    @Environment(\.markdownChecklistStyle) private var checkedStyle
    @Environment(\.markdownImageStyle) private var imageStyle
    private var inlineStyle = InlineMarkdownStyle()

    private var content: some View {
        ForEach(elements.indices, id: \.self) { index in
            switch elements[index] {
            case let .header(config):
                headerStyle.makeBody(configuration: config)
            case let .paragraph(config):
                paragraphStyle.makeBody(configuration: config)
            case let .inline(config):
                inlineStyle.makeBody(configuration: config)
            case let .quote(config):
                quoteStyle.makeBody(configuration: config)
            case let .orderedList(config):
                orderedStyle.makeBody(configuration: config)
            case let .unorderedList(config):
                unorderedStyle.makeBody(configuration: config)
            case let .checklist(config):
                checkedStyle.makeBody(configuration: config)
            case let .code(config):
                codeStyle.makeBody(configuration: config)
            case let .thematicBreak(config):
                thematicBreak.makeBody(configuration: config)
            case let .image(config):
                imageStyle.makeBody(configuration: config)
            }
        }
    }
    

    let elements: [MarkdownElement]
    let paragraphSpacing: CGFloat?
    let isLazy: Bool

    private var stackAlignment: HorizontalAlignment {
        alignment == .leading
        ? .leading
        : alignment == .trailing
            ? .trailing
            : .center
    }

    init(elements: [MarkdownElement], paragraphSpacing: CGFloat?, isLazy: Bool) {
        self.elements = elements
        self.paragraphSpacing = paragraphSpacing
        self.isLazy = isLazy
    }

    public var body: some View {
        if isLazy {
            if #available(iOS 14.0, *) {
                LazyVStack(alignment: stackAlignment, spacing: paragraphSpacing) { content }
            } else {
                VStack(alignment: stackAlignment, spacing: paragraphSpacing) { content }
            }
        } else {
            VStack(alignment: stackAlignment, spacing: paragraphSpacing) { content }
        }
    }
}

@available(iOS 14, *)
public struct LazyMarkdownText: View, MarkupWalker {
    private let content: MarkdownContent

    public init(_ markdown: String, paragraphSpacing: CGFloat? = 20) {
        let elements = MarkdownTextBuilder(
            document: Document(parsing: markdown)
        ).elements

        content = .init(elements: elements, paragraphSpacing: paragraphSpacing, isLazy: true)
    }

    public var body: some View {
        content
    }
}

public struct MarkdownText: View, MarkupWalker {
    private let content: MarkdownContent

    public init(_ markdown: String, paragraphSpacing: CGFloat? = 20) {
        let elements = MarkdownTextBuilder(
            document: Document(parsing: markdown, options: [.parseSymbolLinks, .parseSymbolLinks])
        ).elements

        content = .init(elements: elements, paragraphSpacing: paragraphSpacing, isLazy: false)
    }

    public var body: some View {
        content
    }
}

struct MarkdownText_Previews: PreviewProvider {
    static let text = """
    # Large title

    ## Title 1
    ### Title 2
    #### Title 3
    ##### Headline
    ###### Subheadline

    A opening paragraph from [Apple](apple.com)

    Some `inline` code

    ```
    func foo() { }
    ```

    > A blockquote
    > with multiple lines

    *Emphasized* **strong**
    A soft break

    1. First list item
    3. Second list item

    - An
    - unordered
    - list

    Another paragraph

    - [ ] Unchecked
    - [x] Checked
    """

    static var previews: some View {
        MarkdownText(text)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
