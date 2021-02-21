
import CoreGraphics

protocol BuiltinView {
    func render(in context: CGContext, size: CGSize)
    func size(proposed: ProposedSize) -> CGSize
    typealias Body = Never
}
