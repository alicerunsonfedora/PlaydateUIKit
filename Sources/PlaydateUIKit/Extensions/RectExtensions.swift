import PlaydateKit

public extension Rect {
    /// Create a rectangle of a given origin and size.
    /// - Parameter origin: The origin point of the rectangle.
    /// - Parameter size: The width and height of the rectangle.
    init(at origin: Point, size: UISize) {
        self.init(origin: origin, width: size.width, height: size.height)
    }
}