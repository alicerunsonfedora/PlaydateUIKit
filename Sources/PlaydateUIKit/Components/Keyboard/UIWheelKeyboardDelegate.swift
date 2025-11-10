
/// A delegate that listens for events emitted by a ``UIWheelKeyboard``.
public protocol UIWheelKeyboardDelegate: AnyObject {
    /// Tells the delegate that a key has been pressed on the keyboard.
    /// - Parameter keyboard: The keyboard sending the event.
    /// - Parameter key: The key that was pressed on the keyboard.
    func keyboard(_ keyboard: UIWheelKeyboard, didPress key: UIWheelKeyboardCode)
}

public extension UIWheelKeyboardDelegate {
    func keyboard(_ keyboard: UIWheelKeyboard, didPress key: UIWheelKeyboardCode) {}
}