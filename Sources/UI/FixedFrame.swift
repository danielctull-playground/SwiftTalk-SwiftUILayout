
import CoreGraphics

struct FixedFrame<Content: View>: View, BuiltinView {
    let width: CGFloat?
    let height: CGFloat?
    let content: Content

    func render(context: CGContext, size: CGSize) {
        context.saveGState()
        let contentSize = content._size(proposed: size)
        let x = (size.width - contentSize.width) / 2
        let y = (size.height - contentSize.height) / 2
        context.translateBy(x: x, y: y)
        content._render(context: context, size: contentSize)
        context.restoreGState()
    }

    func size(proposed: CGSize) -> CGSize {
        let proposed = CGSize(width: width ?? proposed.width, height: height ?? proposed.height)
        let child = content._size(proposed: proposed)
        return CGSize(width: width ?? child.width, height: height ?? child.height)
    }
}

extension View {

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        FixedFrame(width: width, height: height, content: self)
    }
}
