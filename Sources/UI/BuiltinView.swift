
import CoreGraphics

protocol BuiltinView {
    func render(context: CGContext, size: CGSize)
    typealias Body = Never
}
