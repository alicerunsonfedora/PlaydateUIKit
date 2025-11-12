import PlaydateKit

/// A structure that describes insets inside of a rectangle.
///
/// This is generally used to provide insets and padding to ``UIRect`` types.
public struct UIEdgeInsets {
    /// The inset from the top edge of a rectangle.
    public var top: Float

    /// The inset from the leading edge of a rectangle.
    public var leading: Float

    /// The inset from the trailing edge of a rectangle.
    public var trailing: Float

    /// The inset from the bottom edge of the rectangle.
    public var bottom: Float

    /// Create a set of edge insets.
    /// - Parameter top: The inset from the top edge of a rectangle.
    /// - Parameter leading: The inset from the leading edge of a rectangle.
    /// - Parameter trailing: The inset from the trailing edge of a rectangle.
    /// - Parameter bottom: The inset from the bottom edge of a rectangle.
    public init(top: Float, leading: Float, trailing: Float, bottom: Float) {
        self.top = top
        self.leading = leading
        self.trailing = trailing
        self.bottom = bottom
    }

    /// Create a set of edge insets at uniform scales on the horizontal and vertical edges.
    /// - Parameter horizontal: The inset from the horizontal edges of the rectangle.
    /// - Parameter vertical: The inset from the vertical edges of the rectangle.
    public init(horizontal: Float, vertical: Float) {
        self.top = vertical
        self.leading = horizontal
        self.trailing = horizontal
        self.bottom = vertical
    }
}

public extension UIEdgeInsets {
    /// An equal inset of zero on all edges.
    static var zero: UIEdgeInsets { UIEdgeInsets(top: 0, leading: 0, trailing: 0, bottom: 0) }

    /// Create a set of edge insets at a uniform scale.
    /// - Parameter value: The inset from all edges of a rectangle.
    static func uniform(_ value: Float) -> Self {
        return UIEdgeInsets(top: value, leading: value, trailing: value, bottom: value)
    }

    /// Create a set of edge insets for the horizontal edges.
    /// - Parameter value: The inset from the leading and trailing edges of a rectangle.
    static func horizontal(_ value: Float) -> Self {
        return UIEdgeInsets(top: 0, leading: value, trailing: value, bottom: 0)
    }

    /// Create a set of edge insets for the vertical edges.
    /// - Parameter value: The inset from the top and bottom edges of a rectangle.
    static func vertical(_ value: Float) -> Self {
        return UIEdgeInsets(top: value, leading: 0, trailing: 0, bottom: value)
    }
}

public extension UIRect {
    /// Create a rectangle inset by a set of edge insets.
    /// - Parameter edgeInsets: The insets to apply to the rectangle.
    func inset(by edgeInsets: UIEdgeInsets) -> Self {
        UIRect(
            at: origin.translatedBy(dx: edgeInsets.leading, dy: edgeInsets.top),
            size: UISize(
            width: size.width - (edgeInsets.trailing * 2),
            height: size.height - (edgeInsets.bottom * 2)))
    }
}