import Cocoa

final class SelectAllButton: NSButton {
    
    private enum Constant {
        static let buttonTitleColor = NSColor(named: "offButtonTitle")!
        static let backgroundColorButton = NSColor(named: "unselectedButton")!
        static let bordersColor = NSColor(named: "bordersButtons")!
        static let titleSelectAll = "Select all"
        static let gradientTopColor = NSColor(named: "gradientTop")!
        static let gradientBottonColor = NSColor(named: "gradientBotton")!
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        setupUI()
        
        super.draw(dirtyRect)
    }
    
    private func setupUI() {
        
        layer?.backgroundColor = Constant.backgroundColorButton.cgColor
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors =
        [Constant.gradientTopColor.cgColor,Constant.gradientBottonColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = bounds
        layer?.insertSublayer(gradientLayer, at: 0)
//        Use diffrent colors
        
        layer?.cornerRadius = 5
        layer?.borderWidth = 1
        
        
        title = Constant.titleSelectAll
        layer?.borderColor = Constant.bordersColor.cgColor
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        attributedTitle = NSAttributedString(
            string: attributedTitle.string,
            attributes: [
                NSAttributedString.Key.foregroundColor :
                    Constant.buttonTitleColor,
                NSAttributedString.Key.paragraphStyle : pstyle
            ]
        )
        
    }
}

