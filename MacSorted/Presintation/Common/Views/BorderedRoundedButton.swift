import Cocoa

class BorderedRoundedButton: NSButton {
    // MARK: Constant
    
    private enum Constant {
        static let titleColor = NSColor(named: "offButtonTitle")!
        static let borderColor = NSColor(named: "buttonBorder")
        static let backgroundColor = NSColor(named: "roundedButtonBackground")
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 5
        static let semiAlphaComponent: CGFloat = 0.5
    }
    
    // MARK: Lifecycle
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        layer?.backgroundColor = isHighlighted
        ? Constant.backgroundColor?.withAlphaComponent(Constant.semiAlphaComponent).cgColor
        : Constant.backgroundColor?.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wantsLayer = true
        layer?.borderColor = Constant.borderColor?.cgColor
        layer?.borderWidth = Constant.borderWidth
        layer?.cornerRadius = Constant.cornerRadius
        layer?.backgroundColor = Constant.backgroundColor?.cgColor
        
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [NSAttributedString.Key.foregroundColor : Constant.titleColor]
        )
    }
}
