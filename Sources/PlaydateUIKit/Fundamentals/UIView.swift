import PlaydateKit

/// An object responsible for drawing graphical elements onto the Playdate's screen.
open class UIView: UIFocusElement {
    /// The intrinsic size of the view's contents.
    open var contentIntrinsicSize: UISize {
        frame.size
    }

    /// The frame that the view inherits/resides in.
    open var frame: UIRect 

    /// Whether the view is currently focused.
    ///
    /// When this view is focused, its subviews will also gain the focused status.
    open override var isFocused: Bool {
        didSet {
            for subview in subviews {
                subview.isFocused = isFocused
            }
        }
    }

    /// Whether the view is hidden and should not be drawn.
    open var isHidden = false

    /// The view's parent.
    ///
    /// This is typically set when a view is added as a subview to another view.
    public var superview: UIView?

    /// The subviews that this view inherits.
    public var subviews: [UIView] { _subviews }

    /// The view's background color.
    open var backgroundColor: Graphics.Color = .clear

    private var internalAddress = -1
    var needsRenderPass = true {
        didSet { didSetNeedsRenderPass() }
    }
    private var _subviews: [UIView] = []

    /// Create a view of a given frame.
    /// - Parameter frame: The view's frame.
    public init(frame: UIRect) {
        self.frame = frame
        super.init()

        if frame.infersSizeFromContentIntrinsicSize {
            self.frame.size = contentIntrinsicSize
        }
    }

    /// Create a view using a PlaydateKit rectangle.
    /// - Parameter pdRect: The rectangle to create a frame for.
    public init(pdRect: Rect) {
        self.frame = UIRect(
            at: pdRect.origin,
            size: UISize(width: pdRect.width, height: pdRect.height))
    }

    /// Add a view to the current view as a child.
    ///
    /// The subview's update cycle is managed by this view's update cycle.
    /// - Parameter view: The view to add as a subview.
    public func addSubview(_ view: UIView) {
        _subviews.append(view)
        view.superview = self
        internalAddress = _subviews.count
        setNeedsDraw()
    }

    /// Draw the contents of the view to the screen when necessary.
    public func redrawIfNeeded() {
        guard needsRenderPass else { return }
        updateLayout()
        draw()
        needsRenderPass = false
    }

    /// Add a view to the current view as a child at the given index.
    ///
    /// The subview's update cycle is managed by this view's update cycle.
    /// - Parameter view: The view to add as a subview.
    /// - Parameter index: The new index of the subview to insert. 
    public func insertSubview(_ view: UIView, at index: Int) {
        _subviews.insert(view, at: index)
        view.superview = self
        internalAddress = _subviews.count
        setNeedsDraw()
    }

    /// Remove the view from its superview.
    public func removeFromSuperview() {
        guard let superview, superview._subviews.indices.contains(internalAddress) else { return }
        superview._subviews.remove(at: internalAddress)
    }

    /// Signal to the view that it needs to redraw its contents to the screen.
    public func setNeedsDraw() {
        needsRenderPass = true
    }

    /// Process given inputs.
    ///
    /// This method should be called before drawing to the screen.
    open func process() {
        for subview in subviews {
            subview.process()
        }
    }

    /// Update the layout of the view and its subviews.
    open func updateLayout() {
        for subview in subviews {
            subview.updateLayout()
        }
    }

    /// Draw the view's contents to the screen.
    open func draw() {
        if isHidden { return }
        if Graphics.drawMode != .copy { Graphics.drawMode = .copy }
        Graphics.fillRect(frame.pdRect, color: backgroundColor)
        for subview in subviews {
            Graphics.drawMode = .copy
            subview.draw()
        }
    }

    private func didSetNeedsRenderPass() {
        guard let superview else {
            for subview in _subviews {
                subview.needsRenderPass = self.needsRenderPass
            }
            return
        }
        if superview.needsRenderPass != self.needsRenderPass {
            superview.needsRenderPass = self.needsRenderPass
        }
    }
}
