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
    
    private let appFetcher = AppFetcher()
    private var apps = [AppsListItem]()
    
    private var filteredApps = [AppsListItem]()
    
    private var filter = "" {
        didSet {
            filteredApps = filter.isEmpty
            ? apps
            : apps.filter { $0.app.name.lowercased().contains(filter) }
            
            uninstallButton.isColored = filteredApps.contains { $0.isSelected }
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
        updateSelection()
    }
}

// MARK: Private
private extension UninstallerVC {
    func updateSelection() {
        let isSelected = !filteredApps.contains { $0.isSelected }
        || filteredApps.contains { $0.isSelected } && filteredApps.contains { !$0.isSelected }
        zip(.zero..<apps.count, .zero..<filteredApps.count).forEach {
            apps[$0.0].setSelected(isSelected)
            filteredApps[$0.1].setSelected(isSelected)
        }
        
        uninstallButton.isColored = isSelected
        tableVeiw.reloadData()
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
        let cellId = NSUserInterfaceItemIdentifier(CheckboxTableCell.reuseId)
        
        guard let cellView = tableView.makeView(withIdentifier: cellId, owner: self) as? CheckboxTableCell
        else { return nil }
        let model = CheckboxTableCellModel(
            isSelected: filteredApps[row].isSelected,
            image: NSImage(contentsOf: filteredApps[row].app.iconPath) ?? NSImage(),
            title: filteredApps[row].app.name,
            subtitle: filteredApps[row].app.path.path
        )
        cellView.configure(with: model) { [weak self] in
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
