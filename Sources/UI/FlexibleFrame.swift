
import CoreGraphics
import SwiftUI


extension CGSize {

    mutating func clamping(
        _ property: WritableKeyPath<CGSize, CGFloat>,
        from minValue: CGFloat?,
        to maxValue: CGFloat?,
        fallback: CGFloat
    ) {
        switch (minValue, maxValue) {
        case (.none, .none):
            self[keyPath: property] = fallback
        case let (.some(minValue), .some(maxValue)):
            self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
        case let (.some(minValue), .none):
            let maxValue = max(minValue, fallback)
            self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
        case let (.none, .some(maxValue)):
            let minValue = min(maxValue, fallback)
            self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
        }
    }
}

struct FlexibleFrame<Content: View>: View, BuiltinView {

    let content: Content
    let minWidth: CGFloat?
    let idealWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let idealHeight: CGFloat?
    let maxHeight: CGFloat?
    let alignment: Alignment

    func size(proposed: ProposedSize) -> CGSize {

        let proposed = ProposedSize(width: proposed.width ?? idealWidth,
                                    height: proposed.height ?? idealHeight)
        var p = CGSize(proposed)
        p.clamping(\.width, from: minWidth, to: maxWidth, fallback: p.width)
        p.clamping(\.height, from: minHeight, to: maxHeight, fallback: p.height)
        let contentSize = content._size(proposed: ProposedSize(p))

        var result = CGSize(proposed)
        result.clamping(\.width, from: minWidth, to: maxWidth, fallback: contentSize.width)
        result.clamping(\.height, from: minHeight, to: maxHeight, fallback: contentSize.height)
        return result
    }

    func render(in context: CGContext, size: CGSize) {
        let contentSize = content._size(proposed: ProposedSize(size))
        context.translate(for: contentSize, in: size, alignment: alignment)
        content._render(in: context, size: contentSize)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.frame(
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight,
            alignment: alignment.swiftUI)
    }
}

extension View {

    public func frame(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        FlexibleFrame(
            content: self,
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight,
            alignment: alignment)
    }
}
