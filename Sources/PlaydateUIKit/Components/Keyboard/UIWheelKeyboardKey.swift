import PlaydateKit

/// A view that displays a key inside of a ``UIWheelKeyboard``.
class UIWheelKeyboardKey: UIView {
    enum State {
        case normal
        case activated
    }

    private enum Constants {
        static let frameInset = 4
    }

    var key: UIWheelKeyboardCode {
        didSet { didSetKey() }
    }
    var font: UIFont {
        didSet { label.font = font }
    }
    var state: State = .normal

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.verticalTextAlignment = .center
        label.isMultiline = false
        label.font = font
        return label
    }()

    init(key: UIWheelKeyboardCode, font: UIFont) {
        self.key = key
        self.font = font
        super.init(frame: .zero)
        addSubview(label)
    }

    override func updateLayout() {
        super.updateLayout()
        label.frame = self.frame
    }

    override func draw() {
        guard !isHidden else { return }
        Graphics.fillEllipse(in: frame, color: .white)
        if state == .activated {
            let insetRect = frame.insetBy(dx: Float(Constants.frameInset), dy: Float(Constants.frameInset))
            Graphics.fillEllipse(in: insetRect)
            Graphics.drawMode = .fillWhite
        }

        super.draw()
        Graphics.drawMode = .copy
    }

    private func didSetKey() {
        switch key {
        case let .character(char):
            label.text = char
        case .delete:
            label.text = nil
        }
    }
}