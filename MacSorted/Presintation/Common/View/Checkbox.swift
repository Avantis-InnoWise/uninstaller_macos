import Cocoa

final class Checkbox: GradientButton {
    private enum Constant {
        static let checkImage = NSImage(named: "checkbox")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        image = state == NSControl.StateValue.on ? Constant.checkImage : nil
        super.draw(dirtyRect)
    }
}
