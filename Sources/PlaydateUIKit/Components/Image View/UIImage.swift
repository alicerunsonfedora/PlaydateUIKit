import PlaydateKit

/// An object that represents a drawable image.
public class UIImage {
    /// The image's name.
    ///
    /// For a standard image, this corresponds to the image's name in the `Resources/Images` directory. For symbols,
    /// this corresponds to the symbol's name.
    public var name: String

    var drawMode: Graphics.Bitmap.DrawMode = .copy

    /// The intrinsic content size of the image.
    public var contentIntrinsicSize: UISize {
        guard let pdBitmap else { return .zero }
        let data = pdBitmap.getData(mask: nil, data: nil)
        return UISize(width: Float(data.width), height: Float(data.height))
    }

    var pdBitmap: Graphics.Bitmap?

    /// Construct an image of a given name.
    /// - Parameter name: The name of the image as it exists in `Resources/Images`.
    public init(name: String) {
        self.name = name
        self.pdBitmap = try? Graphics.Bitmap(path: "Resources/Images/\(name)")
    }

    /// Construct an image from a symbol name according to a specified text style.
    /// - Parameter symbolName: The symbol to create a drawable image out of.
    /// - Parameter textStyle: The preferred text style of the symbol.
    public init(symbolName: String, textStyle: UIFont.TextStyle = .body) {
        self.name = symbolName

        guard let idx = Self.symbolOrder.firstIndex(of: symbolName) else {
            System.error("Symbol '\(symbolName)' not available in the symbol set.")
            return
        }

        guard let symbolTable = try? Graphics.BitmapTable(
            path: "PlaydateUIKit_Resources/Fonts/UISymbols-Regular-\(textStyle.preferredFontSize)") else {
            return
        }
        self.pdBitmap = symbolTable.bitmap(at: idx)?.copy()
    }

    init(name: String, bitmap: Graphics.Bitmap?) {
        self.name = name
        self.pdBitmap = bitmap
    }

    public func inverted() -> UIImage {
        let image = UIImage(name: self.name, bitmap: self.pdBitmap?.copy())
        image.drawMode = .inverted
        return image
    }
}

extension UIImage {
    static let symbolOrder = [
        "checkmark",
        "checkmark.circle",
        "checkmark.circle.fill",
        "xmark",
        "xmark.circle",
        "xmark.circle.fill",
        "crank",
        "crank.fill",
        "crank.circle",
        "crank.circle.fill",
        "chevron.left",
        "chevron.right",
        "chevron.up",
        "chevron.down"
    ]
}