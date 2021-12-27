import Cocoa

extension NSButton {
    func drawGradient(
        in rect: NSRect,
        with gradientAngle: CGFloat = 270.0,
        initialColor: NSColor = NSColor(srgbRed: 1, green: 1, blue: 1, alpha: 1),
        finalColor: NSColor = NSColor(srgbRed: 0.945, green: 0.945, blue: 0.945, alpha: 1)
    ) {
        let gradientAngle = gradientAngle
        let gradient = NSGradient(colors: [
            isHighlighted
            ? finalColor.withAlphaComponent(0.5)
            : finalColor,
            initialColor
        ])
        gradient?.draw(in: rect, angle: gradientAngle)
    }
}
