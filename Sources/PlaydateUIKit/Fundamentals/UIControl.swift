import PlaydateKit

/// A delegate that listens for events emitted by a ``UIControl``.
public protocol UIControlDelegate: AnyObject {
    /// Tells the delegate a control was momentarily pressed.
    /// - Parameter sender: The control that was pressed.
    func controlPressed(_ sender: UIControl)
}

/// A base class for defining a control.
///
/// This class is generally not used on its own; rather, this class is used to define custom user controls.
open class UIControl: UIView {
    /// A structure that represents the state of a user interface control.
    public struct State: OptionSet, Sendable, Hashable {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The control is in its normal state.
        public static let normal = State(rawValue: 1 << 0)

        /// The control is being highlighted.
        public static let highlighted = State(rawValue: 1 << 1)

        /// The control is being selected.
        public static let selected = State(rawValue: 1 << 2)

        /// The control is disabled.
        public static let disabled = State(rawValue: 1 << 3)
    }

    /// The control's delegate.
    ///
    /// Use this to listen for when certain control events are emitted.
    public var controlDelegate: (any UIControlDelegate)?

    /// The current state of the control.
    open var state: State = .normal {
        didSet { setNeedsDraw() }
    }

    open override var isFocused: Bool {
        didSet {
            if isFocused {
                state.insert(.highlighted)
            } else {
                state.remove(.highlighted)
            }
        }
    }

    /// Whether the control is enabled.
    open var isEnabled: Bool {
        get { return !state.contains(.disabled) }
        set {
            if newValue {
                state.remove(.disabled)
            } else {
                state.insert(.disabled)
            }
        }
    }

    /// Whether the control is actively selected.
    open var isSelected: Bool {
        get { return state.contains(.selected) }
        set {
            if newValue {
                state.insert(.selected)
            } else {
                state.remove(.selected)
            }
        }
    }
}