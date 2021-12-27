import Cocoa

final class SectionButton: NSButton {
    // MARK: Constants
    
    private enum Constant {
        static let onButtonTitleColor = NSColor(srgbRed: 0.945, green: 0.945, blue: 0.945, alpha: 1)
        static let offButtonTitleColor = NSColor(srgbRed: 0.588, green: 0.588, blue: 0.588, alpha: 1)
        static let selectedButtonColor = NSColor(srgbRed: 0.478, green: 0.686, blue: 1, alpha: 1)
        static let unselectedButtonColor = NSColor(srgbRed: 0.941, green: 0.941, blue: 0.941, alpha: 1)
    }
    
    // MARK: Lifecycle
    
    override func draw(_ dirtyRect: NSRect) {
        setupUI()
        
        super.draw(dirtyRect)
    }
}

// MARK: Private
private extension SectionButton {
    func setupUI() {
        layer?.backgroundColor = state == .on
        ? Constant.selectedButtonColor.cgColor
        : Constant.unselectedButtonColor.cgColor

        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [
                NSAttributedString.Key.foregroundColor :
                    state == .on ? Constant.onButtonTitleColor : Constant.offButtonTitleColor
            ]
        )
    }
}
