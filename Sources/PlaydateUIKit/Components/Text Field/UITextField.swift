import PlaydateKit

/// An entry field that allows the user to provide text with the keyboard.
open class UITextField: UIView {
    /// An enumeration of the text field styles supported.
    public enum TextFieldStyle {
        /// A plain style with no border.
        case plain

        /// A style with a border around the field.
        case bordered 
    }

    /// The text field's delegate.
    public var delegate: (any UITextFieldDelegate)?

    public override var isFocused: Bool {
        didSet {
            for subview in subviews { subview.isFocused = isFocused }
            keyboard.isHidden = !isFocused
        }
    }

    /// The text field's visual style.
    public var style = TextFieldStyle.plain {
        didSet { setNeedsDraw() }
    }

    /// The supported character keyset this text field uses.
    public var supportedCharacters: UIWheelKeyboard.KeySet {
        didSet { setNeedsDraw() }
    }

    /// The helper text that appears below the text field.
    ///
    /// This should be used whenever possible to describe the purpose of the text field, if the context is not clearly
    /// evident.
    public var helperText: String? {
        didSet {
            helperTextLabel.text = helperText
            helperTextLabel.isHidden = (helperText == nil)
            setNeedsDraw()
        }
    }

    /// The text contents of the text field.
    public var text: String? {
        didSet { setNeedsDraw() }
    }

    private lazy var displayedText: UILabel = {
        let label = UILabel(text: self.text, frame: self.frame.insetBy(dx: 4, dy: 4))
        label.font = supportedCharacters.font
        label.text = ""
        return label
    }()

    private lazy var helperTextLabel: UILabel = {
        let label = UILabel(
            text: self.helperText,
            frame: Rect(
                origin: self.frame.origin.translatedBy(dx: 0, dy: self.frame.height + 6),
                width: self.frame.width,
                height: 20)
            )
        label.font = .preferredFont(for: .caption)
        label.isMultiline = false
        label.isHidden = (helperText == nil)
        return label
    }()

    private lazy var keyboard: UIWheelKeyboard = {
        let keyboard = UIWheelKeyboard(keySet: supportedCharacters)
        keyboard.delegate = self
        return keyboard
    }()

    /// Construct a text field with a supporte keyset in a frame.
    /// - Parameter keySet: The supported character keyset this text field will use.
    /// - Parameter frame: The text field's bounding frame.
    public init(keySet: UIWheelKeyboard.KeySet, frame: Rect = .zero) {
        self.supportedCharacters = keySet
        self.text = nil
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        addSubview(keyboard)
        addSubview(displayedText)
        addSubview(helperTextLabel)
    }

    override open func draw() {
        super.draw()

        if style == .bordered {
            Graphics.drawRoundRect(self.frame, radius: 8, lineWidth: 2)
        }
    }
}

extension UITextField: UIWheelKeyboardDelegate {
    public func keyboard(_ keyboard: UIWheelKeyboard, didPress key: UIWheelKeyboardCode) {
        guard let text = displayedText.text else { return }
        switch key {
        case let .character(char):
            if text.isEmpty {
                displayedText.text = char
            } else {
                displayedText.text = text + char
            }
        case .delete:
            if text.isEmpty { return }
            displayedText.text = text.droppingLastCharacter()
        }
        self.text = displayedText.text
        setNeedsDraw()
        delegate?.textField(self, editingChangedText: self.text)
    }
}