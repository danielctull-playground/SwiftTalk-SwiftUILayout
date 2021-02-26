
import SwiftUI

@propertyWrapper
final class LayoutState<Value> {
    var wrappedValue: Value
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

struct LayoutInfo: Comparable {
    let lower: CGFloat
    let upper: CGFloat

    var isFixed: Bool { lower == upper }
    var isMax: Bool { upper != .greatestFiniteMagnitude }

    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.isFixed { return true }
        if rhs.isFixed { return false }
        if lhs.isMax { return true }
        if rhs.isMax { return false }
        return false
    }
}

public struct HStack: View, BuiltinView {

    public typealias Body = Never

    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let children: [AnyView]
    @LayoutState var sizes: [CGSize] = []

    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        content: [AnyView]
    ) {
        self.children = content
        self.alignment = alignment
        self.spacing = spacing
    }

    func size(proposed: ProposedSize) -> CGSize {

        let info: [LayoutInfo] = children.map { child in
            let lower = child.size(proposed: ProposedSize(width: 0, height: proposed.height))
            let upper = child.size(proposed: ProposedSize(width: .greatestFiniteMagnitude, height: proposed.height))
            return LayoutInfo(lower: lower.width, upper: upper.width)
        }

        var remainingIndices = children.indices.sorted { lhs, rhs in info[lhs] < info[rhs] }

        sizes = Array(repeating: .zero, count: children.count)
        var proposed = proposed
        var remainingWidth = proposed.width! // TODO
        while !remainingIndices.isEmpty {
            proposed.width = remainingWidth / CGFloat(remainingIndices.count)
            let index = remainingIndices.removeFirst()
            let child = children[index]
            let size = child.size(proposed: proposed)
            sizes[index] = size
            remainingWidth -= size.width
            if remainingWidth < 0 { remainingWidth = 0 }
        }
        let width = sizes.reduce(0) { $0 + $1.width }
        let height = sizes.reduce(0) { max($0, $1.height) }
        return CGSize(width: width, height: height)
    }

    func render(in context: CGContext, size: CGSize) {
        var x: CGFloat = 0
        for (child, childSize) in zip(children, sizes) {
            context.saveGState()
            context.translate(for: childSize, in: size, alignment: alignment)
            context.translateBy(x: x, y: 0)
            child.render(in: context, size: childSize)
            context.restoreGState()
            x += childSize.width
        }
    }

    public var swiftUI: some SwiftUI.View {
        SwiftUI.HStack(alignment: alignment.swiftUI, spacing: spacing) {
            ForEach(children.indices, id: \.self) { index in
                children[index].swiftUI
            }
        }
    }
}
