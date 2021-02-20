
import AppKit
import SwiftUI

struct Border<Content: View>: View, BuiltinView {

    let color: NSColor
    let width: CGFloat
    let content: Content

    func size(proposed: CGSize) -> CGSize {
        content._size(proposed: proposed)
    }

    func render(context: CGContext, size: CGSize) {
        content._render(context: context, size: size)
        context.setStrokeColor(color.cgColor)
        context.stroke(CGRect(origin: .zero, size: size).insetBy(dx: width/2, dy: width/2), width: width)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.border(SwiftUI.Color(color), width: width)
    }
}

extension View {

    public func border(_ color: NSColor, width: CGFloat) -> some View {
        Border(color: color, width: width, content: self)
    }
}
