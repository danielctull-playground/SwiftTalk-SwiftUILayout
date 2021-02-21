
import SwiftUI

public struct AnyView: View, BuiltinView {

    public typealias Body = Never

    public let swiftUI: SwiftUI.AnyView
    private let content: AnyViewContent

    public init<V: View>(_ view: V) {
        content = AnyViewStorage(view)
        swiftUI = SwiftUI.AnyView(view.swiftUI)
    }

    func size(proposed: ProposedSize) -> CGSize {
        content.size(proposed: proposed)
    }

    func render(in context: CGContext, size: CGSize) {
        content.render(in: context, size: size)
    }
}

// A trick for type erasure using a base class and a concrete generic subclass.
fileprivate class AnyViewContent: BuiltinView {

    func size(proposed: ProposedSize) -> CGSize {
        fatalError()
    }

    func render(in context: CGContext, size: CGSize) {
        fatalError()
    }
}

fileprivate final class AnyViewStorage<V: View>: AnyViewContent {

    let view: V
    init(_ view: V) {
        self.view = view
    }

    override func size(proposed: ProposedSize) -> CGSize {
        view._size(proposed: proposed)
    }

    override func render(in context: CGContext, size: CGSize) {
        view._render(in: context, size: size)
    }
}
