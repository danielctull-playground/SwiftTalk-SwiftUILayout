
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

public struct HostingView<Content: View>: SwiftUI.View {
    public let content: Content
    public let size: CGSize
    public init(content: Content, size: CGSize) {
        self.content = content
        self.size = size
    }
    public var body: some SwiftUI.View {
        SwiftUI.Image(nsImage: NSImage(data: CGContext.pdf(size: size) { context in
            content
                .frame(width: size.width, height: size.height)
                ._render(context: context, size: size)
        })!)
    }
}
