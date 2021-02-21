
import AppKit
import CoreGraphics
import SwiftUI

extension View {

    public func foregroundColor(_ color: NSColor) -> some View {
        ForegroundColor(content: self, color: color)
    }
}

struct ForegroundColor<Content: View>: View, BuiltinView {

    var content: Content
    var color: NSColor

    func size(proposed: ProposedSize) -> CGSize {
        content._size(proposed: proposed)
    }

    func render(in context: CGContext, size: CGSize) {
        context.setFillColor(color.cgColor)
        content._render(in: context, size: size)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.foregroundColor(Color(color))
    }
}
