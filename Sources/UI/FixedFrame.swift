
import CoreGraphics
import SwiftUI

struct FixedFrame<Content: View>: View, BuiltinView {

    let content: Content
    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment

    func size(proposed: ProposedSize) -> CGSize {
        let proposed = ProposedSize(width: width ?? proposed.width, height: height ?? proposed.height)
        let child = content._size(proposed: proposed)
        return CGSize(width: width ?? child.width, height: height ?? child.height)
    }

    func render(in context: CGContext, size: CGSize) {
        let contentSize = content._size(proposed: ProposedSize(size))
        context.translate(for: contentSize, in: size, alignment: alignment)
        content._render(in: context, size: contentSize)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.frame(width: width, height: height, alignment: alignment.swiftUI)
    }
}

extension View {

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        FixedFrame(content: self, width: width, height: height, alignment: alignment)
    }
}
