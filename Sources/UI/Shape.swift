
import AppKit
import CoreGraphics

public protocol Shape: View {
    func path(in rect: CGRect) -> CGPath
}

extension Shape {
    public var body: some View {
        ShapeView(shape: self)
    }
}

extension NSColor: View {
    public var body: some View {
        ShapeView(shape: Rectangle(), color: self)
    }
}

public struct ShapeView<S: Shape>: BuiltinView, View {
    public typealias Body = Never
    var shape: S
    var color: NSColor =  .red

    func render(context: CGContext, size: CGSize) {
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        context.fillPath()
        context.restoreGState()
    }

    func size(proposed: CGSize) -> CGSize {
        proposed
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
