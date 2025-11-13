import PlaydateKit

/// A view that displays a bitmap image.
open class UIImageView: UIView {
    open override var canBeFocused: Bool { false }

    /// The image to display in the view.
    open var image: UIImage?

    /// Create an image view with a given image and frame.
    /// - Parameter image: The image to draw in the image view.
    /// - Parameter frame: The frame to draw the image into.
    public init(image: UIImage? = nil, frame: UIRect = .zero) {
        self.image = image
        super.init(frame: frame)
    }

    public convenience init(image: UIImage? = nil, at point: Point) {
        self.init(image: image, frame: .inferredContentSize(at: point))
        self.frame.size = image?.contentIntrinsicSize ?? .zero
    }

    public override func draw() {
        guard let bitmap = image?.pdBitmap else { return }
        if Graphics.drawMode != (image?.drawMode ?? .copy) {
            Graphics.drawMode = image?.drawMode ?? .copy
        }
        guard let contentIntrinsicSize = image?.contentIntrinsicSize else {
            Graphics.drawBitmap(bitmap, at: frame.origin)
            return
        }
        Graphics.drawBitmap(
            bitmap,
            at: Point(
                x: frame.midX - (contentIntrinsicSize.width / 2),
                y: frame.midY - (contentIntrinsicSize.height / 2)
            ))
    }
}