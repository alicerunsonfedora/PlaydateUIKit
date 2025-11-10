
public extension UIView {
    /// Adds the subviews to the current view.
    ///
    /// > Note: This is a convenience method that calls ``addSubview(_:)`` for each view.
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
