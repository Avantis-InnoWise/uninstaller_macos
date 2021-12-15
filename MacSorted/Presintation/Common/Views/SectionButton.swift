import Cocoa

final class SectionButton: NSButton {
    // MARK: Constants
    
    private enum Constant {
        static let onButtonTitleColor = NSColor(named: "onButtonTitle")!
        static let offButtonTitleColor = NSColor(named: "offButtonTitle")!
        static let selectedButtonColor = NSColor(named: "selectedButton")!
        static let unselectedButtonColor = NSColor(named: "unselectedButton")!
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
