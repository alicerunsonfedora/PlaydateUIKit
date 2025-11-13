import PlaydateKit

private enum Constants {
    static let horizontalPadding = 12
    static let verticalPadding = 4
    static let cornerRadius = 8
    static let borderedSelectionInset = 3
}

/// A control that executes a callback when interacted with.
///
/// Buttons are typically used to perform an action when tapped on. Pressing the A button will activate the button and
/// trigger the action associated with it. Buttons can appear as static pieces of text, an image, or a combination of
/// both.
open class UIButton: UIControl {
    /// An enumeration of the available button styles.
    public enum Style {
        /// The button displays as a plain piece of text.
        case plain

        /// The button appears with a rounded border around its edges.
        case bordered
    }

    /// The font used on the button's label text.
    open var font: UIFont = .preferredSystemFont(for: .body) {
        didSet {
            label.font = font
            setNeedsDraw()
        }
    }

    public override var contentIntrinsicSize: UISize {
        let labelSize = label.contentIntrinsicSize

        return UISize(
            width: Float(Constants.horizontalPadding * 2) + 8 + labelSize.height + labelSize.width,
            height: labelSize.height + Float(Constants.verticalPadding * 2))
    }

    /// The button's current style.
    open var style: Style {
        didSet { setNeedsDraw() }
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()

    lazy var label: UILabel = {
        let label = UILabel(text: nil, frame: frame)
        label.font = font 
        label.textColor = .xor
        label.isHidden = true
        label.isMultiline = false
        label.textAlignment = .center
        label.verticalTextAlignment = .center
        return label
    }()

    var buttonConfigurations: [UIControl.State: ButtonModelConfig] {
        didSet { setNeedsDraw() }
    }

    /// Create a button of a given style and frame.
    /// - Parameter style: The button's appearance.
    /// - Parameter frame: The frame that the button inherits.
    public init(style: Style, frame: UIRect) {
        self.style = style
        self.buttonConfigurations = [:]
        super.init(frame: frame)
        setupView()
    }

    public convenience init(title: String, image: UIImage, style: Style, frame: UIRect) {
        self.init(style: style, frame: frame)
        let standardConfig = ButtonModelConfig(text: title, image: image)
        self.buttonConfigurations = [.normal : standardConfig]
        if frame.infersSizeFromContentIntrinsicSize {
            imageView.image = standardConfig.image
            label.text = standardConfig.text
            self.frame.size = contentIntrinsicSize
        }
        setupView()
    }

    public override func process() {
        guard isFocused, isEnabled else { return }
        super.process()

        let (current, pressed, released) = System.buttonState
        if current.contains(.a), state != [.normal, .selected] {
            state = [.normal, .selected]
        } else if pressed.contains(.a), state != [.normal, .highlighted] {
            state = [.normal, .highlighted]
        } else if released.contains(.a) {
            state = [.normal]
            controlDelegate?.controlPressed(self)
        }
    }

    public override func updateLayout() {
        if frame.infersSizeFromContentIntrinsicSize { frame.size = contentIntrinsicSize }
        let availableFrame = self.frame.inset(
            by: UIEdgeInsets(
                horizontal: Float(Constants.horizontalPadding),
                vertical: Float(Constants.verticalPadding)
            )
        )
        let configuration = getHighestPriorityConfiguration()
        switch (configuration.text, configuration.image) {
        case (_, nil):
            label.frame = availableFrame
        case (nil, _):
            let imageSize = UISize(width: availableFrame.size.height, height: availableFrame.size.height)
            imageView.frame = UIRect(
                at: Point(
                    x: availableFrame.midX - (imageSize.width / 2),
                    y: availableFrame.minY
                ),
                size: imageSize)
        case (_, _):
            imageView.frame = UIRect(
                at: availableFrame.origin,
                size: UISize(width: availableFrame.size.height, height: availableFrame.size.height)
            )
            label.frame = UIRect(
                at: Point(
                    x: imageView.frame.maxX + 8,
                    y: imageView.frame.minY
                ),
                size: UISize(
                    width: availableFrame.size.width - 8 - imageView.frame.size.width,
                    height: availableFrame.size.height
                )
            )
        }
        super.updateLayout()
    }

    public override func draw() {
        updateButtonConfiguration()
        if style == .bordered {
            Graphics.drawRoundRect(self.frame.pdRect, radius: Constants.cornerRadius, lineWidth: 2)
        }
        if state.contains(.selected) {
            let innerFrame = style == .bordered ? self.frame.inset(by: .uniform(3)) : self.frame
            Graphics.fillRoundRect(
                innerFrame.pdRect,
                radius: style == .bordered
                    ? Constants.cornerRadius - Constants.borderedSelectionInset
                    : Constants.cornerRadius
                )
        }
        super.draw()
    }

    private func setupView() {
        addSubviews([imageView, label])
        if frame.infersSizeFromContentIntrinsicSize { frame.size = contentIntrinsicSize }
    }
}