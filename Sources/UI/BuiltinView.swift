
import CoreGraphics

protocol BuiltinView {
    func size(proposed: ProposedSize) -> CGSize
    func render(in context: CGContext, size: CGSize)
    typealias Body = Never
}
