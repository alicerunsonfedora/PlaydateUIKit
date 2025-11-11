public extension UIFont {
    /// An enumeration of the various standard text styles.
    enum TextStyle: Equatable {
        /// The text style used for general body text.
        case body

        /// The text style used for captions where the main content is not important itself.
        case caption

        /// The text style used for title texts.
        case title

        var preferredFontSize: Int {
            switch self {
            case .body: 11
            case .caption: 10
            case .title: 20
            }
        }
    }

    /// Use a preferred font for a given text style.
    ///
    /// - Parameter textStyle: The text style that determines the font to use.
    static func preferredSystemFont(for textStyle: UIFont.TextStyle) -> UIFont {
        switch textStyle {
        case .body:
            return UIFont(systemFontSize: textStyle.preferredFontSize, systemFontWeight: .medium)
        case .caption:
            return UIFont(systemFontSize: textStyle.preferredFontSize, systemFontWeight: .bold)
        case .title:
            return UIFont(systemFontSize: textStyle.preferredFontSize, systemFontWeight: .medium)
        }
    }
}