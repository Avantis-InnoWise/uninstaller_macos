import Cocoa

extension NSButton {
    func drawGradient(
        in rect: NSRect,
        with gradientAngle: CGFloat = 270.0,
        initialColor: NSColor = NSColor(named: "gradientButtonTop")!,
        finalColor: NSColor = NSColor(named: "gradientButtonBottom")!
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
