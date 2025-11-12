import PlaydateKit

/// A structure that defines a rectangle.
public struct UIRect: Equatable {
    /// The origin point of the rectangle (i.e., its top left corner).
    public var origin: Point

    /// The area of the rectangle from the origin.
    public var size: UISize

    /// Whether the size should be inferred from the content intrinsic size.
    ///
    /// When this is set, ``size`` will be set to zero, and it will be the responsibility of the view or drawable to
    /// query for the correct intrinsic size. For example, when using this with a ``UILabel``, the size is inferred
    /// from the width and height of the text block:
    ///
    /// ```swift
    /// import PlaydateUIKit
    /// 
    /// let myLabel = UILabel(text: "Foo", frame: .inferredContentSize(at: .zero))
    /// ```
    public private(set) var infersSizeFromContentIntrinsicSize: Bool

    /// A PlaydateKit rectangle that represents the current rectangle.
    public var pdRect: Rect {
        Rect(origin: origin, width: size.width, height: size.height)
    }

    /// Create a rectangle at a given point and size.
    /// - Parameter origin: The starting point of the rectangle.
    /// - Parameter size: The rectangle's size.
    public init(at origin: Point, size: UISize) {
        self.origin = origin
        self.size = size
        infersSizeFromContentIntrinsicSize = false
    }

    /// Create a rectangle that infers its size from an intrinsic content size.
    /// - Parameter origin: The starting point of the rectangle.
    public static func inferredContentSize(at origin: Point) -> Self {
        var rect = UIRect(at: origin, size: .zero)
        rect.infersSizeFromContentIntrinsicSize = true
        return rect
    }
}

public extension UIRect {
    /// An empty rectangle (i.e., a zero value).
    static var zero: UIRect { UIRect(at: .zero, size: .zero) }

    /// A rectangle that represents the Playdate's display.
    static var display: UIRect { UIRect(at: .zero, size: .display) }

    /// The rectangle's minimum X value.
    var minX: Float { origin.x }

    /// The rectangle's median or "middle" X value.
    var midX: Float { origin.x + (size.width / 2) }

    /// The rectangle's maximum X value.
    var maxX: Float { origin.x + size.width }

    /// The rectangle's minimum Y value.
    var minY: Float { origin.y }

    /// The rectangle's median or "middle" Y value.
    var midY: Float { origin.y + (size.height / 2) }

    /// The rectangle's maximum Y value.
    var maxY: Float { origin.y + size.height }

    /// The point that represents the center of the rectangle.
    var center: Point { Point(x: midX, y: midY) }

    /// The point that represents the end of the rectangle.
    var end: Point { Point(x: maxX, y: maxY) }
}