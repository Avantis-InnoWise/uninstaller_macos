import Cocoa

final class UninstallerVC: NSViewController {
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 50
        static let tableCellId = "AppTableCellView"
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var searchField: NSTextField!
    @IBOutlet private weak var selectAllButton: GradientButton!
    @IBOutlet private weak var uninstallButton: BorderedRoundedButton!
    @IBOutlet private weak var tableVeiw: NSTableView!
    
    // MARK: Properties
    
    private let appFetcher = AppFetcher()
    private var apps = [AppsListItem]()
    
    private var filteredApps = [AppsListItem]()
    
    private var filter = "" {
        didSet {
            filteredApps = filter.isEmpty ? apps : apps.filter { $0.app.name.lowercased().contains(filter) }
            tableVeiw.reloadData()
        }
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.appearance = NSAppearance(named: .aqua)
        searchField.delegate = self
        
        appFetcher.fetch { [weak self] apps in
            self?.apps = apps.compactMap { AppsListItem(app: $0) }
            self?.filteredApps = self?.apps ?? []
            self?.tableVeiw.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction private func uninstallButtonWasTapped(_ sender: BorderedRoundedButton) {
//        for app in filteredApps where app.isSelected {
//            appFetcher.uninstall(app.app)
//        }
    }
    
    @IBAction private func selectAllButtonWasTapped(_ sender: GradientButton) {
    }
}

// MARK: NSTableViewDataSource
extension UninstallerVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        filteredApps.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        filteredApps[row]
    }
}

// MARK: NSTableViewDelegate
extension UninstallerVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier(Constant.tableCellId)
        
        guard let cellView = tableView.makeView(withIdentifier: cellId, owner: self) as? AppTableCellView
        else { return nil }
        cellView.configure(with: filteredApps[row]) { [weak self] in
            self?.filteredApps[row].toggleSelection()
            
            self?.uninstallButton.isColored = self?.filteredApps.contains { $0.isSelected } ?? false
            
            guard let indexInUnfilteredApps = self?.apps.firstIndex(where: { $0.app == self?.filteredApps[row].app }) else { return }
            self?.apps[indexInUnfilteredApps].toggleSelection()
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
        filter = object.stringValue.trimmingCharacters(in: .whitespaces).lowercased()
    }
}
