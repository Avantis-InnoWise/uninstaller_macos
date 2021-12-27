import Cocoa

final class FileDeleterVC: NSViewController {
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 50
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var searchField: NSTextField!
    @IBOutlet private weak var selectAllButton: GradientButton!
    @IBOutlet private weak var deleteButton: BorderedRoundedButton!
    @IBOutlet private weak var tableVeiw: NSTableView!
    
    // MARK: Properties
    
    var output: FileDeleterViewOutput!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.appearance = NSAppearance(named: .aqua)
        searchField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction private func findDuplicatesButtonWasTapped(_ sender: BorderedRoundedButton) {
        output.findDuplicatedFilesWasTapped()
    }
    
    @IBAction private func findOldFilesButtonWasTapped(_ sender: BorderedRoundedButton) {
        output.findOldFilesWasTapped()
    }
    
    @IBAction private func deleteButtonWasTapped(_ sender: BorderedRoundedButton) {
        output.deleteSelectedItemsWasTapped()
    }
    
    @IBAction private func selectAllButtonWasTapped(_ sender: GradientButton) {
        output.selectAllButtonWasTapped()
    }
}

// MARK: NSTableViewDataSource
extension FileDeleterVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        output.items.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        output.items[row]
    }
}

// MARK: NSTableViewDelegate
extension FileDeleterVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier(CheckboxTableCell.reuseId)
        
        guard let cellView = tableView.makeView(
            withIdentifier: cellId,
            owner: self
        ) as? CheckboxTableCell else { return nil }
        
        cellView.configure(with: output.items[row]) { [weak self] in
            self?.output.toggleSelection(at: row)
            
            self?.deleteButton.isColored = self?.output.items.contains { $0.isSelected } ?? false
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        Constant.rowHeight
    }
}

// MARK: NSSearchFieldDelegate
extension FileDeleterVC: NSSearchFieldDelegate {
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
extension FileDeleterVC: FileDeleterViewInput {
    func update() {
        tableVeiw.reloadData()
        
        deleteButton.isColored = output.items.contains { $0.isSelected }
    }
    
    func showInformalAlert(title: String, message: String, buttonTitle: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: buttonTitle)
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    func showDecisionAlert(
        title: String,
        message: String,
        okButtonTitle: String,
        cancelButtonTitle: String,
        decisionCompletion: () -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: okButtonTitle)
        alert.addButton(withTitle: cancelButtonTitle)
        alert.alertStyle = .warning
        if alert.runModal() == .alertFirstButtonReturn {
            decisionCompletion()
        }
    }
}
