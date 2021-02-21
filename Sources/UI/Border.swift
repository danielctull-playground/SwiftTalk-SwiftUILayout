
import AppKit
import SwiftUI

struct Border<Content: View>: View, BuiltinView {

    let content: Content
    let color: NSColor
    let width: CGFloat

    func size(proposed: ProposedSize) -> CGSize {
        content._size(proposed: proposed)
    }

    func render(in context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
            .insetBy(dx: width/2, dy: width/2)
        content._render(in: context, size: size)
        context.setStrokeColor(color.cgColor)
        context.stroke(rect, width: width)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.border(SwiftUI.Color(color), width: width)
    }
}

extension View {

    public func border(_ color: NSColor, width: CGFloat) -> some View {
        Border(content: self, color: color, width: width)
    }
}
