import PlaydateKit

/// A view that displays a piece of text in a frame.
open class UILabel: UIView {
    open override var canBeFocused: Bool { false }

    open override var contentIntrinsicSize: UISize {
        guard let pdFont = font?.pdFont, let text else { return super.contentIntrinsicSize }
        if isMultiline { return super.contentIntrinsicSize }

        let textWidth = pdFont.getTextWidth(for: text, tracking: 0)
        return UISize(width: Float(textWidth), height: Float(pdFont.height))
    }

    /// The text that is presented in the label.
    open var text: String?

    /// The font the label uses to render the text.
    open var font: UIFont? = .preferredSystemFont(for: .body)

    /// Whether the label spans multiple lines.
    open var isMultiline: Bool = true

    /// The alignment of the text in the label.
    open var textAlignment: UIHorizontalAlignment = .leading

    /// The vertical alignment of the text in the label.
    /// > Note: When ``isMultiline`` is enabled, this property will take no effect.
    open var verticalTextAlignment: UIVerticalAlignment = .top

    /// The color of the text label.
    open var textColor: Graphics.SolidColor = .black

    /// Create a label.
    /// - Parameter text: The text contents of the label.
    /// - Parameter frame: The frame that the text is rendered in.
    public init(text: String? = nil, frame: UIRect = .zero) {
        self.text = text
        super.init(frame: frame)
    }

    open override func draw() {
        super.draw()
        if let pdFont = font?.pdFont {
            Graphics.setFont(pdFont)
        }
        guard let text else { return }

        switch textColor {
        case .black:
            Graphics.drawMode = .fillBlack
        case .white:
            Graphics.drawMode = .fillWhite
        case .xor:
            Graphics.drawMode = .xor
        case .clear:
            fallthrough
        @unknown default:
            Graphics.drawMode = .copy
        }

        if isMultiline {
            Graphics.drawTextInRect(text, in: frame.pdRect, aligned: Graphics.TextAlignment(uiHorizontalAlignment: textAlignment))
            return
        }

        var topPoint = frame.origin
        switch verticalTextAlignment {
        case .top:
            break
        case .center:
            topPoint.y = frame.center.y
        case .bottom:
            topPoint.y = frame.maxY
        }

        switch textAlignment {
        case .leading:
            break
        case .center:
            topPoint.x = frame.center.x
        case .trailing:
            topPoint.x = frame.maxX
        }

        switch textAlignment {
        case .leading:
            Graphics.drawText(text, at: topPoint)
        case .center:
            let widthOffset = contentIntrinsicSize.width / 2
            let heightOffset = contentIntrinsicSize.height / 2
            Graphics.drawText(text, at: topPoint.translatedBy(dx: -widthOffset, dy: -heightOffset))
        case .trailing:
            Graphics.drawText(text, at: topPoint.translatedBy(dx: -contentIntrinsicSize.width, dy: 0))
        }

        Graphics.drawMode = .copy
    }
}