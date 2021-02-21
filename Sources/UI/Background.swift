
import CoreGraphics
import SwiftUI

struct BackgroundView<Content: View, Background: View>: View, BuiltinView {

    let content: Content
    let background: Background
    let alignment: Alignment

    func size(proposed: ProposedSize) -> CGSize {
        content._size(proposed: proposed)
    }

    func render(in context: CGContext, size: CGSize) {
        let backgroundSize = background._size(proposed: ProposedSize(size))
        context.saveGState()
        context.translate(for: backgroundSize, in: size, alignment: alignment)
        background._render(in: context, size: backgroundSize)
        context.restoreGState()
        content._render(in: context, size: size)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.background(background.swiftUI, alignment: alignment.swiftUI)
    }
}

extension View {

    public func background<Background: View>(
        _ background: Background,
        alignment: Alignment = .center
    ) -> some View {
        BackgroundView(content: self, background: background, alignment: alignment)
    }
}
