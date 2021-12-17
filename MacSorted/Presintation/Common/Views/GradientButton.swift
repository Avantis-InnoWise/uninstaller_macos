import Cocoa

class GradientButton: BorderedRoundedButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer?.backgroundColor = NSColor.white.cgColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        drawGradient(in: dirtyRect)
        super.draw(dirtyRect)
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.masksToBounds = true
    }
}
