
import CoreGraphics
import SwiftUI


extension CGSize {

    fileprivate mutating func clamping(
        _ property: WritableKeyPath<CGSize, CGFloat>,
        from minValue: CGFloat,
        to maxValue: CGFloat
    ) {
        self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
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
        p.clamping(\.width,
                   from: minWidth ?? p.width,
                   to: maxWidth ?? p.width)
        p.clamping(\.height,
                   from: minHeight ?? p.height,
                   to: maxHeight ?? p.height)
        let contentSize = content._size(proposed: ProposedSize(p))

        var result = CGSize(proposed)
        result.clamping(\.width,
                        from: minWidth ?? contentSize.width,
                        to: maxWidth ?? contentSize.width)
        result.clamping(\.height,
                        from: minHeight ?? contentSize.height,
                        to: maxHeight ?? contentSize.height)
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
