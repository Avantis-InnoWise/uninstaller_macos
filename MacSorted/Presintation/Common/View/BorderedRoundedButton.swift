import Cocoa

class BorderedRoundedButton: NSButton {
    // MARK: Constant
    
    private enum Constant {
        static let titleColor = NSColor(srgbRed: 0.588, green: 0.588, blue: 0.588, alpha: 1)
        static let borderColor = NSColor(srgbRed: 0.878, green: 0.878, blue: 0.878, alpha: 1)
        static let backgroundColor = NSColor(srgbRed: 0.945, green: 0.945, blue: 0.945, alpha: 1)
        static let backgroundBlueColor = NSColor(srgbRed: 0.302, green: 0.580, blue: 1, alpha: 1)
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 5
        static let semiAlphaComponent: CGFloat = 0.5
        static let gradientInitialAlpha: CGFloat = 0.7
    }
    
    // MARK: Properties
    
    var isColored = false { didSet { draw(bounds) } }
    
    private var backgroundColor: NSColor? {
        isColored ? Constant.backgroundBlueColor : Constant.backgroundColor
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
        ? Constant.backgroundBlueColor.cgColor
        : Constant.borderColor.cgColor
        
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
        layer?.borderColor = Constant.borderColor.cgColor
        layer?.borderWidth = Constant.borderWidth
        layer?.cornerRadius = Constant.cornerRadius
        layer?.backgroundColor = Constant.backgroundColor.cgColor
        layer?.masksToBounds = true
        
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [NSAttributedString.Key.foregroundColor : Constant.titleColor]
        )
    }
}
