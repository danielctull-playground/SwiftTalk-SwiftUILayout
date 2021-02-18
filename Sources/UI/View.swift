import AppKit
import CoreGraphics

public protocol View {
    associatedtype Body: View
    var body: Body { get }
}

extension View where Body == Never {
    public var body: Never { fatalError("This should never be called.") }
}

extension Never: View {
    public typealias Body = Never
}

extension View {

    func _render(context: CGContext, size: CGSize) {
        if let builtin = self as? BuiltinView {
            builtin.render(context: context, size: size)
        } else {
            body._render(context: context, size: size)
        }
    }
}
