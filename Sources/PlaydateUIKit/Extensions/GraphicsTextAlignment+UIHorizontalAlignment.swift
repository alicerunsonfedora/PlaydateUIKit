import PlaydateKit

extension Graphics.TextAlignment {
    init(uiHorizontalAlignment alignment: UIHorizontalAlignment) {
        switch alignment {
        case .leading:
            self = .left
        case .center:
            self = .center
        case .trailing:
            self = .right
        }
    }
}