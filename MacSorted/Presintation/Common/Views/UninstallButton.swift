import Cocoa

final class UninstallButton: NSButton {
    
    private enum Constant {
        static let onButtonTitleColor = NSColor(named: "onButtonTitle")!
        static let offButtonTitleColor = NSColor(named: "offButtonTitle")!
        static let selectedButtonColor = NSColor(named: "selectedButton")!
        static let unselectedButtonColor = NSColor(named: "unselectedButton")!
        static let bordersColor = NSColor(named: "bordersButtons")!
        static let titleUninstall = "Uninstall"
    }
    
    override func draw(_ dirtyRect: NSRect) {
        setupUI()
        
        super.draw(dirtyRect)
    }
    
    private func setupUI() {
        title = Constant.titleUninstall
        layer?.backgroundColor = state == .on
        ? Constant.selectedButtonColor.cgColor
        : Constant.unselectedButtonColor.cgColor
        
        layer?.cornerRadius = 5
        layer?.borderWidth = 1
        layer?.borderColor = Constant.bordersColor.cgColor
        
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
