import Cocoa

final class AppTableCellView: NSTableCellView {
    // MARK: Outlets
    
    @IBOutlet private weak var checkbox: Checkbox!
    @IBOutlet private weak var appIconImageView: NSImageView!
    @IBOutlet private weak var appNameLabel: NSTextField!
    @IBOutlet private weak var appLocationLabel: NSTextField!
    
    // MARK: Properties
    
    private var checkboxHandler: (() -> Void)?
    
    // MARK: Actions
    
    @IBAction private func checkboxWasTapped(_ sender: Checkbox) {
        checkboxHandler?()
    }
    
    // MARK: Configs
    
    func configure(with item: AppsListItem, checkboxHandler: @escaping () -> Void) {
        checkbox.state = item.isSelected ? .on : .off
        appIconImageView.image = NSImage(contentsOf: item.app.iconPath)
        appNameLabel.stringValue = item.app.name
        appLocationLabel.stringValue = item.app.path.path
        self.checkboxHandler = checkboxHandler
    }
}
