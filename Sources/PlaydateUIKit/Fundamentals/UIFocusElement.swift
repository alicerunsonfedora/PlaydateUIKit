
/// A class that represents an element that can gain focus.
open class UIFocusElement {
    /// Whether this element can gain focus.
    public var canBeFocused: Bool { true }

    /// Whether the element is currently focused.
    public var isFocused = false
}