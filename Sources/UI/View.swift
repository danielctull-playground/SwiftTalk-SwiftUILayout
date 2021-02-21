
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

struct ProposedSize {
    var width: CGFloat?
    var height: CGFloat?
}

extension ProposedSize {

    init(_ size: CGSize) {
        self.init(width: size.width, height: size.height)
    }
}

extension CGSize {

    init(_ size: ProposedSize, default: CGFloat = 10) {
        self.init(width: size.width ?? `default`,
                  height: size.height ?? `default`)
    }
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

    func _size(proposed: ProposedSize) -> CGSize {
        if let builtin = self as? BuiltinView {
            return builtin.size(proposed: proposed)
        } else {
            return body._size(proposed: proposed)
        }
    }
}
