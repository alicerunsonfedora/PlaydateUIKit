/// A container view controller that provides stack-based navigation.
///
/// Navigation controllers allow switching between multiple view controllers in a stack. The topmost view controller is
/// the one receiving updates in the navigation controller's lifecycle, and all other view controllers are suspended.
public class UINavigationController: UIViewController {
    /// The view controllers this navigation controller manages.
    public private(set) var viewControllers = [UIViewController]()

    /// The topmost view controller of the navigation stack.
    public var topmostViewController: UIViewController? {
        viewControllers.last
    }

    /// Create a navigation controller with a starting root view controller.
    /// - Parameter rootViewController: The view controller that will be the navigation controller's root of the stack.
    public init(rootViewController: UIViewController) {
        viewControllers = [rootViewController]
        super.init()
        rootViewController.navigationController = self
    }

    public override func update() {
        guard let topmostViewController else {
            super.update()
            return
        }
        topmostViewController.update()
    }

    /// Push a view controller onto the navigation stack, becoming the topmost view controller.
    /// - Parameter viewController: The view controller to push on the stack.
    public func push(viewController: UIViewController) {
        viewControllers.append(viewController)
        viewController.navigationController = self
    }

    /// Pop the topmost view controller from the navigation stack.
    public func popViewController() -> UIViewController? {
        let top = viewControllers.popLast()
        top?.navigationController = nil
        return top
    }
}