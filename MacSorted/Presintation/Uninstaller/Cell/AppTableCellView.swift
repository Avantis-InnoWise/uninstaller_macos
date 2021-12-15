import Cocoa

final class AppTableCellView: NSTableCellView {
    // MARK: Outlets
    
    @IBOutlet private weak var checkbox: NSButton!
    @IBOutlet private weak var appIconImageView: NSImageView!
    @IBOutlet private weak var appNameLabel: NSTextField!
    @IBOutlet private weak var appLocationLabel: NSTextField!
    
    // MARK: Configs
    
    func configure(with app: App) {
        appIconImageView.image = NSImage(contentsOf: app.iconPath)
        appNameLabel.stringValue = app.name
        appLocationLabel.stringValue = app.path.path
    }
}
