
import SwiftUI

public struct GeometryReader<Content: View>: View, BuiltinView {

    public typealias Body = Never

    let content: (GeometryProxy) -> Content
    public init(content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }

    func size(proposed: CGSize) -> CGSize {
        proposed
    }

    func render(in context: CGContext, size: CGSize) {
        let proxy = GeometryProxy(size: size)
        let content = self.content(proxy)
        let contentSize = content._size(proposed: size)
        content._render(in: context, size: contentSize)
    }

    public var swiftUI: some SwiftUI.View {
        SwiftUI.GeometryReader { proxy -> Content.SwiftUIView in
            let proxy = GeometryProxy(size: proxy.size)
            return content(proxy).swiftUI
        }
    }
}

public struct GeometryProxy {
    public let size: CGSize
}
