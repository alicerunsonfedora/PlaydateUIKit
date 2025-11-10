import PlaydateKit

/// A wrapper view that displays the current frames per second.
public final class UIFrameCounter: UIView {
    public override var canBeFocused: Bool { false }

    public override func process() {
        super.process()
        setNeedsDraw()
    }

    public override func draw() {
        super.draw()
        System.drawFPS(at: frame.origin)
    }
}