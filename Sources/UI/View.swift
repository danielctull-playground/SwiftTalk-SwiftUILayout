
import AppKit
import CoreGraphics
import SwiftUI

public protocol View {
    associatedtype Body: View
    var body: Body { get }

    associatedtype SwiftUIView: SwiftUI.View
    var swiftUI: SwiftUIView { get }
}

extension View {

    public var swiftUI: some SwiftUI.View {
        body.swiftUI
    }
}

extension View where Body == Never {
    public var body: Never { fatalError("This should never be called.") }
}

extension Never: View {
    public typealias Body = Never
}

extension View {

    func _render(in context: CGContext, size: CGSize) {
        if let builtin = self as? BuiltinView {
            context.saveGState()
            builtin.render(in: context, size: size)
            context.restoreGState()
        } else {
            body._render(in: context, size: size)
        }
    }

    func _size(proposed: CGSize) -> CGSize {
        if let builtin = self as? BuiltinView {
            return builtin.size(proposed: proposed)
        } else {
            return body._size(proposed: proposed)
        }
    }
}
