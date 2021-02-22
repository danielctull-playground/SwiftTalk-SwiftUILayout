
import CoreGraphics

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
