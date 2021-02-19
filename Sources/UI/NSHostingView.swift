
import CoreGraphics
import Foundation
import SwiftUI

extension CGContext {

    static func pdf(size: CGSize, render: (CGContext) -> ()) -> Data {
        let pdfData = NSMutableData()
        let consumer = CGDataConsumer(data: pdfData)!
        var mediaBox = CGRect(origin: .zero, size: size)
        let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)!
        pdfContext.beginPage(mediaBox: &mediaBox)
        render(pdfContext)
        pdfContext.endPage()
        pdfContext.closePDF()
        return pdfData as Data
    }
}

func render<V: UI.View>(view: V) -> Data {
    let size = CGSize(width: 600, height: 400)
    return CGContext.pdf(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

extension NSHostingView where Content == SwiftUI.Image {

    public convenience init<V: UI.View>(rootView: V) {
        let image = SwiftUI.Image(nsImage: NSImage(data: render(view: rootView))!)
        self.init(rootView: image)
    }
}

public struct HostingView<Content: View>: SwiftUI.View {
    public let content: Content
    public init(content: Content) {
        self.content = content
    }
    public var body: some SwiftUI.View {
        SwiftUI.Image(nsImage: NSImage(data: render(view: content))!)
    }
}
