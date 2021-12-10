import Cocoa

final class SectionButtons: NSButton {
    
    private enum Constant {
        static let onButtonTitleColor = NSColor(named: "onButtonTitle")!
        static let offButtonTitleColor = NSColor(named: "offButtonTitle")!
        static let selectedButtonColor = NSColor(named: "selectedButton")!
        static let unselectedButtonColor = NSColor(named: "unselectedButton")!
        static let titleAppUninstaller = "App Uninstaller"
        static let titleFileDeleter = "File Deleter"
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        setupUI()
        
        super.draw(dirtyRect)
    }
    
    private func setupUI() {
        layer?.backgroundColor = state == .on
        ? Constant.selectedButtonColor.cgColor
        : Constant.unselectedButtonColor.cgColor
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [
                NSAttributedString.Key.foregroundColor :
                    state == .on ? Constant.onButtonTitleColor : Constant.offButtonTitleColor,
                NSAttributedString.Key.paragraphStyle : pstyle
            ]
        )
    }
}

