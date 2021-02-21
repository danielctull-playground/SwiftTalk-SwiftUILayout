
import CoreGraphics
import SwiftUI

extension CGContext {

    func translate(for child: CGSize, in parent: CGSize, alignment: Alignment) {
        let parent = alignment.point(for: parent)
        let child = alignment.point(for: child)
        let x = parent.x - child.x
        let y = parent.y - child.y
        translateBy(x: x, y: y)
    }
}

public struct Alignment {
    let horizontal: HorizontalAlignment
    let vertical: VerticalAlignment
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

extension Alignment {
    public static let center = Self(horizontal: .center, vertical: .center)

    public static let leading = Self(horizontal: .leading, vertical: .center)
    public static let trailing = Self(horizontal: .trailing, vertical: .center)

    public static let top = Self(horizontal: .center, vertical: .top)
    public static let bottom = Self(horizontal: .center, vertical: .bottom)

    public static let topLeading = Self(horizontal: .leading, vertical: .top)
    public static let topTrailing = Self(horizontal: .trailing, vertical: .top)

    public static let bottomLeading = Self(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Self(horizontal: .trailing, vertical: .bottom)
}

extension Alignment {

    func point(for size: CGSize) -> CGPoint {
        let x = horizontal.alignmentID.defaultValue(in: size)
        let y = vertical.alignmentID.defaultValue(in: size)
        return CGPoint(x: x, y: y)
    }
}

// MARK: - HorizontalAlignment

public struct HorizontalAlignment {
    let alignmentID: AlignmentID.Type
    public init(alignmentID: AlignmentID.Type) {
        self.alignmentID = alignmentID
    }
}

extension HorizontalAlignment {
    public static let leading = Self(alignmentID: HorizontalLeading.self)
    public static let center = Self(alignmentID: HorizontalCenter.self)
    public static let trailing = Self(alignmentID: HorizontalTrailing.self)
}

// MARK: - VerticalAlignment

public struct VerticalAlignment {
    let alignmentID: AlignmentID.Type
    public init(alignmentID: AlignmentID.Type) {
        self.alignmentID = alignmentID
    }
}

extension VerticalAlignment {
    public static let top = Self(alignmentID: VerticalTop.self)
    public static let center = Self(alignmentID: VerticalCenter.self)
    public static let bottom = Self(alignmentID: VerticalBottom.self)
}

// MARK: - AlignmentID

public protocol AlignmentID: SwiftUI.AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat
}

enum HorizontalLeading: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { 0 }
}

enum HorizontalCenter: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { size.width / 2 }
}

enum HorizontalTrailing: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { size.width }
}

enum VerticalTop: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { 0 }
}

enum VerticalCenter: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { size.height / 2 }
}

enum VerticalBottom: AlignmentID {
    static func defaultValue(in size: CGSize) -> CGFloat { size.height }
}

// MARK: - Converting to SwiftUI

extension Alignment {

    var swiftUI: SwiftUI.Alignment {
        SwiftUI.Alignment(horizontal: horizontal.swiftUI,
                          vertical: vertical.swiftUI)
    }
}

extension HorizontalAlignment {

    var swiftUI: SwiftUI.HorizontalAlignment {
        SwiftUI.HorizontalAlignment(alignmentID)
    }
}

extension VerticalAlignment {

    var swiftUI: SwiftUI.VerticalAlignment {
        SwiftUI.VerticalAlignment(alignmentID)
    }
}

extension AlignmentID {

    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        defaultValue(in: CGSize(width: context.width, height: context.height))
    }
}
