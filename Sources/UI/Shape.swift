import AppKit
import CoreGraphics

protocol Shape: View {
    func path(in rect: CGRect) -> CGPath
}

extension Shape {
    var body: some View {
        ShapeView(shape: self)
    }
}

extension NSColor: View {
    public var body: some View {
        ShapeView(shape: Rectangle(), color: self)
    }
}

struct ShapeView<S: Shape>: BuiltinView, View {
    var shape: S
    var color: NSColor =  .red

    func render(context: CGContext, size: CGSize) {
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        context.fillPath()
        context.restoreGState()
    }
}

struct Rectangle: Shape {
    func path(in rect: CGRect) -> CGPath {
        CGPath(rect: rect, transform: nil)
    }
}

struct Ellipse: Shape {
    func path(in rect: CGRect) -> CGPath {
        CGPath(ellipseIn: rect, transform: nil)
    }
}
