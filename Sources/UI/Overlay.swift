
import SwiftUI

struct OverlayView<Content: View, Overlay: View>: View, BuiltinView {

    let content: Content
    let overlay: Overlay
    let alignment: Alignment

    func size(proposed: CGSize) -> CGSize {
        content._size(proposed: proposed)
    }

    func render(context: CGContext, size: CGSize) {
        let overlaySize = overlay._size(proposed: size)
        content._render(context: context, size: size)
        context.translate(for: overlaySize, in: size, alignment: alignment)
        overlay._render(context: context, size: overlaySize)
    }

    var swiftUI: some SwiftUI.View {
        content.swiftUI.overlay(overlay.swiftUI, alignment: alignment.swiftUI)
    }
}

extension View {

    public func overlay<Overlay: View>(
        _ overlay: Overlay,
        alignment: Alignment = .center
    ) -> some View {
        OverlayView(content: self, overlay: overlay, alignment: alignment)
    }
}
