import Cocoa

final class UninstallerVC: NSViewController {
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 50
        static let tableCellId = "AppTableCellView"
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var searchField: NSTextField!
    @IBOutlet private weak var selectAllButton: BorderedRoundedButton!
    @IBOutlet private weak var uninstallButton: NSButton!
    @IBOutlet private weak var tableVeiw: NSTableView!
    
    // MARK: Properties
    
    private let appFetcher = AppFetcher()
    private var apps = [AppsListItem]()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.appearance = NSAppearance(named: .aqua)
        
        appFetcher.fetch { [weak self] apps in
            self?.apps = apps.compactMap { AppsListItem(app: $0) }
            self?.tableVeiw.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction private func uninstallButtonWasTapped(_ sender: BorderedRoundedButton) {
    }
    
    @IBAction private func selectAllButtonWasTapped(_ sender: GradientButton) {
    }
}

// MARK: NSTableViewDataSource
extension UninstallerVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        apps.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        apps[row]
    }
}

// MARK: NSTableViewDelegate
extension UninstallerVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier(Constant.tableCellId)
        
        guard let cellView = tableView.makeView(withIdentifier: cellId, owner: self) as? AppTableCellView
        else { return nil }
        cellView.configure(with: apps[row]) { [weak self] in
            self?.apps[row].toggleSelection()
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        Constant.rowHeight
    }
}
