
extension UIWheelKeyboard.KeySet {
    var keys: [String] {
        switch self {
        case let .alphanumeric(includeCapitalization):
            let latinAlphabet = [
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                "u", "v", "w", "x", "y", "z"]
            let latinUppercasedAlphabet = [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                "U", "V", "W", "X", "Y", "Z"]  
            var keys = latinAlphabet
            if includeCapitalization {
                keys.append(contentsOf: latinUppercasedAlphabet)
            }
            keys.append(contentsOf: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
            return keys
        case let .custom(keys, _):
            return keys
        }
    }
    
    var font: UIFont {
        switch self {
        case .alphanumeric:
            return .preferredSystemFont(for: .body)
        case let .custom(_, customFont):
            return customFont
        }
    }
}