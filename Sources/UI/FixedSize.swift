
import CoreGraphics
import SwiftUI

struct FixedSize<Content: View>: View, BuiltinView {

    let content: Content
    let horizontal: Bool
    let vertical: Bool

    func size(proposed: ProposedSize) -> CGSize {
        var proposed = proposed
        if horizontal { proposed.width = nil }
        if vertical { proposed.height = nil }
        return content._size(proposed: proposed)
    }

    func render(in context: CGContext, size: CGSize) {
        content._render(in: context, size: size)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.fixedSize(horizontal: horizontal, vertical: vertical)
    }
}

extension View {

    public func fixedSize(
        horizontal: Bool = true,
        vertical: Bool = true
    ) -> some View {
        FixedSize(content: self, horizontal: horizontal, vertical: vertical)
    }
}
