
/// A delegate that listens for events emitted by a ``UITextField``.
public protocol UITextFieldDelegate: AnyObject {
    /// Tells the delegate that the text field has changed its text contents.
    /// - Parameter textField: The text field that changed its text.
    /// - Parameter newText: The new contents of the text field.
    func textField(_ textField: UITextField, editingChangedText newText: String?)
}

public extension UITextFieldDelegate {
    func textField(_ textField: UITextField, editingChangedText newText: String?) {}
}