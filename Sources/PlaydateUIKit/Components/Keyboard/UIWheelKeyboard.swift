import PlaydateKit

/// An enumeration of the the key codes supported by a ``UIWheelKeyboard``.
public enum UIWheelKeyboardCode {
    /// An individual character or character cluster.
    case character(String)

    /// The delete key.
    case delete
}

/// A keyboard that displays characters in a wheel.
public class UIWheelKeyboard: UIView {
    /// An enumeration of the key sets the keyboard supports.
    public enum KeySet {
        /// The standard Latin alphabet, including or excluding capitalized letters.
        case alphanumeric(includeCapitalization: Bool)

        /// A custom key set with a given font.
        case custom(keys: [String], font: UIFont)
    }

    private enum Direction {
        case down, up
    }

    private enum Constants {
        static let backgroundWidth = 64
        static let keySize = 32
        static let keyPadding = 8
        static let activeKeySize = 40
        static let keySlots = 5
    }

    private var currentSelectedKey = 0
    private var activeKeyPressed = false

    /// The delegate that will listen to keyboard events.
    public var delegate: (any UIWheelKeyboardDelegate)?

    /// The set of keys that this keyboard uses.
    public var keySet: KeySet {
        didSet {
            didSetKeySet()
        }
    }

    public init(keySet: KeySet) {
        self.keySet = keySet
        super.init(
            frame: UIRect(
                at: Point(x: Display.width - Constants.backgroundWidth, y: 0),
                size: UISize(
                    width: Float(Constants.backgroundWidth),
                    height: Float(Display.height)
                )
            )
        )
        setupView()
    }

    public override func process() {
        super.process()
        if (isHidden || !isFocused) { return }

        let (_, pushed, released) = System.buttonState
        if pushed.contains(.a) {
            activeKeyPressed = true
            setNeedsDraw()
        }

        if released.contains(.down) {
            slideKeyboard(.down)
        } else if released.contains(.up) {
            slideKeyboard(.up)
        } else if released.contains(.a) {
            activeKeyPressed = false
            delegate?.keyboard(self, didPress: .character(keySet.keys[currentSelectedKey]))
            setNeedsDraw()
        } else if released.contains(.b) {
            delegate?.keyboard(self, didPress: .delete)
        }

        let crankTicks = System.getCrankTicks(4)
        if crankTicks == -1 {
            slideKeyboard(.up)
        } else if crankTicks == 1 {
            slideKeyboard(.down)
        }
    }

    public override func updateLayout() {
        super.updateLayout()

        let maxKeyMargin = (Constants.backgroundWidth - Constants.activeKeySize) / 2
        let minKeyMargin = (Constants.backgroundWidth - Constants.keySize) / 2
        
        let keysHeight = (Constants.keySize + Constants.keyPadding) * Constants.keySlots 
        var currentY = Display.height / 2 - (keysHeight / 2)
        
        let centerKeyIndex = currentSelectedKey
        let startKeyIndex = centerKeyIndex - 2 
        let endKeyIndex = centerKeyIndex + 2

        let keySlotIndices = subviews.indices 
        let keyIndices = startKeyIndex...endKeyIndex
        
        for (keySlot, key) in zip(keySlotIndices, keyIndices) {
            let subview = subviews[keySlot]
            guard keySet.keys.indices.contains(key) else {
                subview.frame = UIRect(
                    at: Point(
                        x: Display.width - (Constants.backgroundWidth - minKeyMargin),
                        y: currentY
                    ),
                    size: UISize(
                        width: Float(Constants.keySize),
                        height: Float(Constants.keySize)
                    )
                )
                subview.isHidden = true
                currentY += Constants.keySize + Constants.keyPadding
                continue
            }

            let isActiveKey = (key == currentSelectedKey)        
            let computedKeySize = isActiveKey ? Constants.activeKeySize : Constants.keySize
            let computedMargin = isActiveKey ? maxKeyMargin : minKeyMargin

            

            subview.frame = UIRect(
                at: Point(
                    x: Display.width - (Constants.backgroundWidth - computedMargin),
                    y: currentY
                ),
                size: UISize(
                    width: Float(computedKeySize),
                    height: Float(computedKeySize)
                )
            )
            subview.isHidden = false

            let keyCode = UIWheelKeyboardCode.character(keySet.keys[key])
            if let keyView = subview as? UIWheelKeyboardKey {
                keyView.key = keyCode
                keyView.isSelected = isActiveKey && activeKeyPressed
            }
            
            currentY += computedKeySize + Constants.keyPadding
        }
    }

    private func setupView() {
        backgroundColor = .black
        for _ in 1...5 {
            let key = UIWheelKeyboardKey(key: .delete, font: keySet.font)
            addSubview(key)
        }
        updateLayout()
    }

    private func slideKeyboard(_ direction: Direction) {
        switch direction {
        case .down:
            currentSelectedKey = min(currentSelectedKey + 1, keySet.keys.endIndex - 1)
        case .up:
            currentSelectedKey = max(keySet.keys.startIndex, currentSelectedKey - 1)
        }
        setNeedsDraw()
    }

    private func didSetKeySet() {
        for subview in subviews {
            if let key = subview as? UIWheelKeyboardKey {
                key.font = keySet.font
            }
        }
    }
}
