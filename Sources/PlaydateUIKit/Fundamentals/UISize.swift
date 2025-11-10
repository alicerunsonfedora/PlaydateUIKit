
/// A structure that represents a size.
public struct UISize {
    /// The size's width.
    public var width: Float

    /// The size's height.
    public var height: Float 
}

public extension UISize {
    /// A size of zero.
    static var zero: UISize { UISize(width: 0, height: 0) }
}