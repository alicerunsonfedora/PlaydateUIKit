import UTF8ViewExtensions

// NOTE(marquiskurt): These are only here because some collection API-specific content doesn't quite work under
// Embedded Swift for varying reasons. So, we need to redirect the content to use the UTF-8 view instead of the raw
// content.

public extension String {
    /// Whether the string has no content.
    var isEmpty: Bool { utf8.isEmpty }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.equals(rhs)
    }

    func equals(_ other: String) -> Bool {
        return self.utf8 == other.utf8
    }

    /// Returns a copy of the string, removing the last character.
    ///
    /// If the string failed to drop the last character, it returns itself.
    func droppingLastCharacter() -> Self {
        return self.droppingLast(k: 1)
    }

    /// Returns a copy of the string, removing the last _k_ characters.
    ///
    /// If the string failed to drop the last character, it returns itself.
    /// - Parameter k: The number of characters to drop.
    func droppingLast(k characters: Int) -> Self {
        if isEmpty { return self }
        let utf8View = self.utf8
        let substring = utf8View.dropLast(characters)
        guard let newSelf = String(substring) else { return self }
        return newSelf
    }
}

public extension Array where Element == String {
    func firstIndex(of value: String) -> Index? {
        self.firstIndex { $0.equals(value) }
    }
}