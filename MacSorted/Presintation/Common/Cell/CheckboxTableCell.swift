import Cocoa

final class CheckboxTableCell: NSTableCellView {
    static let reuseId = "AppTableCellView"
    
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
    
    func configure(with item: CheckboxTableCellModel, checkboxHandler: @escaping () -> Void) {
        checkbox.state = item.isSelected ? .on : .off
        appIconImageView.image = item.image
        appNameLabel.stringValue = item.title
        appLocationLabel.stringValue = item.subtitle
        self.checkboxHandler = checkboxHandler
    }
}
