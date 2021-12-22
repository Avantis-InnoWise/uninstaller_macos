import Cocoa

class BorderedRoundedButton: NSButton {
    // MARK: Constant
    
    private enum Constant {
        static let titleColor = NSColor(named: "offButtonTitle")!
        static let borderColor = NSColor(named: "buttonBorder")
        static let backgroundColor = NSColor(named: "roundedButtonBackground")
        static let backgroundBlueColor = NSColor(named: "roundedButtonColoredBackground")
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 5
        static let semiAlphaComponent: CGFloat = 0.5
        static let gradientInitialAlpha: CGFloat = 0.7
    }
    
    // MARK: Properties
    
    @IBInspectable var isColored: Bool = false { didSet { draw(bounds) } }
    @IBInspectable var сolor: NSColor = Constant.backgroundBlueColor ?? .clear
    
    private var backgroundColor: NSColor? {
        isColored ? сolor : Constant.backgroundColor
    }
    
    // MARK: Lifecycle
    
    override func draw(_ dirtyRect: NSRect) {
        if isColored {
            drawGradient(
                in: dirtyRect,
                initialColor: backgroundColor?
                    .withAlphaComponent(Constant.gradientInitialAlpha) ?? .clear,
                finalColor: backgroundColor ?? .clear
            )
        }
        
        super.draw(dirtyRect)
        
        if !isColored {
            layer?.backgroundColor = isHighlighted
            ? backgroundColor?.withAlphaComponent(Constant.semiAlphaComponent).cgColor
            : backgroundColor?.cgColor
        }
        
        layer?.borderColor = isColored
        ? сolor.cgColor
        : Constant.borderColor?.cgColor
        
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [
                NSAttributedString.Key.foregroundColor : isColored
                ? NSColor.white
                : Constant.titleColor
            ]
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wantsLayer = true
        layer?.borderColor = Constant.borderColor?.cgColor
        layer?.borderWidth = Constant.borderWidth
        layer?.cornerRadius = Constant.cornerRadius
        layer?.backgroundColor = Constant.backgroundColor?.cgColor
        layer?.masksToBounds = true
        
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [
                NSAttributedString.Key.foregroundColor : isColored
                ? NSColor.white
                : Constant.titleColor
            ]
        )
    }
}
