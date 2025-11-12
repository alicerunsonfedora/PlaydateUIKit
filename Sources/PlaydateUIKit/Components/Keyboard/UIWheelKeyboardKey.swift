import PlaydateKit

/// A view that displays a key inside of a ``UIWheelKeyboard``.
class UIWheelKeyboardKey: UIControl {
    private enum Constants {
        static let frameInset = 4
    }

    var key: UIWheelKeyboardCode {
        didSet { didSetKey() }
    }
    var font: UIFont {
        didSet { label.font = font }
    }

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
        if state.contains(.selected) {
            label.textColor = .white
        } else {
            label.textColor = .black
        }

        Graphics.fillEllipse(in: frame.pdRect, color: .white)
        if state.contains(.selected) {
            let insetRect = frame.inset(by: .uniform(Float(Constants.frameInset)))
            Graphics.fillEllipse(in: insetRect.pdRect)
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