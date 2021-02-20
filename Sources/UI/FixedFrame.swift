
import CoreGraphics
import SwiftUI

struct FixedFrame<Content: View>: View, BuiltinView {

    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment
    let content: Content

    func render(context: CGContext, size: CGSize) {
        context.saveGState()
        let contentSize = content._size(proposed: size)
        context.translate(for: contentSize, in: size, alignment: alignment)
        content._render(context: context, size: contentSize)
        context.restoreGState()
    }

    func size(proposed: CGSize) -> CGSize {
        let proposed = CGSize(width: width ?? proposed.width, height: height ?? proposed.height)
        let child = content._size(proposed: proposed)
        return CGSize(width: width ?? child.width, height: height ?? child.height)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.frame(width: width, height: height, alignment: alignment.swiftUI)
    }
}

extension View {

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        FixedFrame(width: width, height: height, alignment: alignment, content: self)
    }
}
