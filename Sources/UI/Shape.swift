
import AppKit
import CoreGraphics
import SwiftUI

public protocol Shape: View {
    func path(in rect: CGRect) -> CGPath
}

extension Shape {
    public var body: some View { ShapeView(shape: self) }
    public var swiftUI: some SwiftUI.View { AnyShape(shape: self) }
}

extension NSColor: View {
    public var body: some View { ShapeView(shape: Rectangle(), color: self) }
    public var swiftUI: some SwiftUI.View { SwiftUI.Color(self) }
}

struct AnyShape: SwiftUI.Shape {

    let path: (CGRect) -> CGPath
    init<S: Shape>(shape: S) {
        path = shape.path(in:)
    }

    func path(in rect: CGRect) -> Path {
        Path(path(rect))
    }
}

public struct ShapeView<S: Shape>: BuiltinView, View {
    public typealias Body = Never
    var shape: S
    var color: NSColor =  .red

    func render(in context: CGContext, size: CGSize) {
        context.setFillColor(color.cgColor)
        context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        context.fillPath()
    }

    func size(proposed: ProposedSize) -> CGSize {
        CGSize(proposed)
    }

    public var swiftUI: some SwiftUI.View {
        AnyShape(shape: shape)
    }
}

public struct Rectangle: Shape {
    public init() {}
    public func path(in rect: CGRect) -> CGPath {
        CGPath(rect: rect, transform: nil)
    }
}

public struct Ellipse: Shape {
    public init() {}
    public func path(in rect: CGRect) -> CGPath {
        CGPath(ellipseIn: rect, transform: nil)
    }
}
