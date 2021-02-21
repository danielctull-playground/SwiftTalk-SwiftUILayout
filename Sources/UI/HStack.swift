
import SwiftUI

public struct HStack: View, BuiltinView {

    public typealias Body = Never

    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: [AnyView]

    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        content: [AnyView]
    ) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizes(for proposed: ProposedSize) -> [CGSize] {
        var proposed = proposed
        var remainingWidth = proposed.width! // TODO
        var remainingContent = content
        var sizes: [CGSize] = []
        while !remainingContent.isEmpty {
            proposed.width = remainingWidth / CGFloat(remainingContent.count)
            let content = remainingContent.removeFirst()
            let size = content.size(proposed: proposed)
            sizes.append(size)
            remainingWidth -= size.width
        }
        return sizes
    }

    func size(proposed: ProposedSize) -> CGSize {
        let sizes = self.sizes(for: proposed)
        let width = sizes.reduce(0) { $0 + $1.width }
        let height = sizes.reduce(0) { max($0, $1.height) }
        return CGSize(width: width, height: height)
    }

    func render(in context: CGContext, size: CGSize) {
        let sizes = self.sizes(for: ProposedSize(size))
        var x: CGFloat = 0
        for (content, contentSize) in zip(content, sizes) {
            context.saveGState()
            context.translate(for: contentSize, in: size, alignment: alignment)
            context.translateBy(x: x, y: 0)
            content.render(in: context, size: contentSize)
            context.restoreGState()
            x += contentSize.width
        }
    }

    public var swiftUI: some SwiftUI.View {
        SwiftUI.HStack(alignment: alignment.swiftUI, spacing: spacing) {
            ForEach(content.indices, id: \.self) { index in
                content[index].swiftUI
            }
        }
    }
}
