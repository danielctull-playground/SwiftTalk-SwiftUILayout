
import SwiftUI

public struct Text: BuiltinView, View {

    public typealias Body = Never

    let text: String
    public init(_ text: String) {
        self.text = text
    }

    let font = NSFont.systemFont(ofSize: 16)

    var framesetter: CTFramesetter {
        let attributes = [NSAttributedString.Key.font: font]
        let string = NSAttributedString(string: text, attributes: attributes)
        return CTFramesetterCreateWithAttributedString(string)
    }

    func size(proposed: CGSize) -> CGSize {
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, proposed, nil)
    }

    func render(context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        let path = CGPath(rect: rect, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), path, nil)
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        CTFrameDraw(frame, context)
    }

    public var swiftUI: some SwiftUI.View {
        SwiftUI.Text(text).font(Font(font))
    }
}
