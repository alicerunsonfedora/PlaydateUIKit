extension UIButton {
    struct ButtonModelConfig {
        var text: String?
        var image: UIImage?
    }

    /// Sets the button's image for the specified control state.
    ///
    /// If no image is set for the other control states, the image assigned to the `.normal` control state will be used
    /// instead.
    /// - Parameter image: The image that will be visible for the specified control state.
    /// - Parameter state: The control state that the image appears for.
    public func setImage(_ image: UIImage, for state: UIControl.State) {
        var configuration = ButtonModelConfig(text: nil, image: image)
        if let existingConfig = buttonConfigurations[state] {
            configuration.text = existingConfig.text
        }
        buttonConfigurations[state] = configuration
        if state == .normal {
            imageView.image = image
            updateLayout()
        }
    }
    
    /// Sets the button's title for the specified control state.
    ///
    /// If no title is set for the other control states, the title assigned to the `.normal` control state will be used
    /// instead.
    /// - Parameter title: The title that will be visible for the specified control state.
    /// - Parameter state: The control state that the image appears for.
    public func setTitle(_ title: String, for state: UIControl.State) {
        var configuration = ButtonModelConfig(text: title, image: nil)
        if let existingConfig = buttonConfigurations[state] {
            configuration.image = existingConfig.image
        }
        buttonConfigurations[state] = configuration
        if state == .normal {
            label.text = title
            updateLayout()
        }
    }

    func getHighestPriorityConfiguration() -> ButtonModelConfig {
        let normalConfig = buttonConfigurations[.normal, default: ButtonModelConfig()]
        var configuration = ButtonModelConfig(text: normalConfig.text, image: normalConfig.image)
        if state.contains(.disabled) {
            guard let disabled = buttonConfigurations[.disabled] else {
                return configuration
            }
            if let text = disabled.text { configuration.text = text }
            if let image = disabled.image { configuration.image = image }
        } else if state.contains(.selected) {
            guard let selected = buttonConfigurations[.selected] else {
                return configuration
            }
            if let text = selected.text { configuration.text = text }
            if let image = selected.image { configuration.image = image }
        } else if state.contains(.highlighted) {
            guard let highlighted = buttonConfigurations[.highlighted] else {
                return configuration
            }
            if let text = highlighted.text { configuration.text = text }
            if let image = highlighted.image { configuration.image = image }
        }
        return configuration
    }
    
    func updateButtonConfiguration() {
        let configuration = getHighestPriorityConfiguration()
        label.isHidden = configuration.text?.isEmpty != false
        imageView.isHidden = configuration.image == nil
        
        label.text = configuration.text
        label.textColor = isSelected ? .white : .black
        imageView.image = isSelected ? configuration.image?.inverted() : configuration.image
    }
}
