import Cocoa

final class UninstallerVC: NSViewController {
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 50
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var searchField: NSTextField!
    @IBOutlet private weak var selectAllButton: GradientButton!
    @IBOutlet private weak var uninstallButton: BorderedRoundedButton!
    @IBOutlet private weak var tableVeiw: NSTableView!
    
    // MARK: Properties
    
    var output: UninstallerViewOutput!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        
        searchField.appearance = NSAppearance(named: .aqua)
        searchField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction private func uninstallButtonWasTapped(_ sender: BorderedRoundedButton) {
        output.uninstallSelectedItemsWasTapped()
    }
    
    @IBAction private func selectAllButtonWasTapped(_ sender: GradientButton) {
        output.selectAllButtonWasTapped()
    }
}

// MARK: NSTableViewDataSource
extension UninstallerVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        output.items.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        output.items[row]
    }
}

// MARK: NSTableViewDelegate
extension UninstallerVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier(CheckboxTableCell.reuseId)
        
        guard let cellView = tableView.makeView(withIdentifier: cellId, owner: self) as? CheckboxTableCell
        else { return nil }
        cellView.configure(with: output.items[row]) { [weak self] in
            self?.output.toggleSelection(at: row)
            
            self?.uninstallButton.isColored =
            self?.output.items.contains { $0.isSelected } ?? false
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        Constant.rowHeight
    }
}

// MARK: NSSearchFieldDelegate
extension UninstallerVC: NSSearchFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let object = obj.object as? NSTextField else { return }
        let filter = object.stringValue.trimmingCharacters(in: .whitespaces).lowercased()
        output.update(with: filter)
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline(_:)) else { return false }
        output.reloadModel()
        return true
    }
}

// MARK: FileDeleterViewInput
extension UninstallerVC: UninstallerViewInput {
    func update() {
        tableVeiw.reloadData()
        
        uninstallButton.isColored = output.items.contains { $0.isSelected }
    }
}
