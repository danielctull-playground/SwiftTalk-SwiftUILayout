
import CoreGraphics

protocol BuiltinView {
    func render(in context: CGContext, size: CGSize)
    func size(proposed: CGSize) -> CGSize
    typealias Body = Never
}
