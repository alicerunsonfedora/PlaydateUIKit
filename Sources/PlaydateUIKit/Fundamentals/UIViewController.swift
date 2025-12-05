import PlaydateKit

/// An object that controls a singular view.
open class UIViewController {
    /// The view this controller managers.
    public var view: UIView

    /// The navigation controller driving this controller.
    ///
    /// If this view controller is present in a navigation controller's stack, it can be accessed here.
    public var navigationController: UINavigationController?

    /// Creates a view controller with an empty view.
    public init() {
        view = UIView(frame: .display)
        view.setNeedsDraw()
    }

    /// Sets the specified focus element as the active one.
    /// - Parameter element: The element to give focus to.
    public func focus(on element: UIFocusElement) {
        guard element.canBeFocused else { return }
        for subview in view.subviews {
            subview.isFocused = false
        }
        element.isFocused = true
        view.setNeedsDraw()
    }

    /// Perform a single update cycle on the controller's view.
    public func update() {
        view.process()
        if view.needsRenderPass { Graphics.clear(color: .white) }
        view.redrawIfNeeded()
    }
}
