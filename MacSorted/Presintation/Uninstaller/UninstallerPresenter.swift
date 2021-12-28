import Foundation
import AppKit

final class UninstallerPresenter {
    // MARK: Constants
    
    private enum Constant {
        static let decisionAlertTitle = "Delete?"
        static let decisionAlertMessage = "Would you like to proceed uninstalling the chosen application/s?"
        static let alertConfirmButtonTitle = "Confirm"
        static let alertCancelButtonTitle = "Cancel"
        static let errorAlertTitle = "Error"
        static let alertOkButtonTitle = "Ok"
    }
    
    // MARK: Properties
    
    weak var view: UninstallerViewInput!
    
    private let appsManager: AppsManagerProtocol
    
    private var appItems = [CheckboxTableCellModel]()
    private var filter = ""
    
    // MARK: Lifecycle
    
    init(with appsManager: AppsManagerProtocol) {
        self.appsManager = appsManager
    }
}

// MARK: UninstallerViewOutput
extension UninstallerPresenter: UninstallerViewOutput {
    var items: [CheckboxTableCellModel] {
        filter.isEmpty
        ? appItems
        : appItems.filter { $0.title.lowercased().contains(filter) }
    }
    
    func viewDidLoad() {
        reloadModel()
    }
    
    func reloadModel() {
        appsManager.fetch { [weak self] apps in
            self?.appItems = apps.compactMap {
                CheckboxTableCellModel(
                    isSelected: false,
                    title: $0.name,
                    subtitle: $0.path.path,
                    image: NSImage(contentsOf: $0.iconPath),
                    sourceLocations: [$0.path] + $0.dataLocations
                )
            }
            
            self?.view.update()
        }
    }
    
    func update(with filter: String) {
        self.filter = filter
        view.update()
    }
    
    func toggleSelection(at index: Int) {
        let item = items[index]
        guard let unfilteredIndex = appItems.firstIndex(where: { $0 == item }) else { return }
        appItems[unfilteredIndex].isSelected.toggle()
    }
    
    func selectAllButtonWasTapped() {
        let isSelected = items.contains { !$0.isSelected }
        items.forEach { item in
            guard let unfilteredIndex = appItems.firstIndex(where: { $0 == item })
            else { return }
            appItems[unfilteredIndex].isSelected = isSelected
        }
        view.update()
    }
    
    func uninstallSelectedItemsWasTapped() {
        guard !items.filter({ $0.isSelected }).isEmpty else { return }
        
        view.showDecisionAlert(
            title: Constant.decisionAlertTitle,
            message: Constant.decisionAlertMessage,
            okButtonTitle: Constant.alertConfirmButtonTitle,
            cancelButtonTitle: Constant.alertCancelButtonTitle
        ) { [weak self] in
            let dispatchGroup = DispatchGroup()
            dispatchGroup.setTarget(queue: .global(qos: .userInteractive))
            
            for item in self?.items ?? [] where item.isSelected {
                dispatchGroup.enter()
                self?.appsManager.uninstall(with: item.sourceLocations) { [weak self] error in
                    guard let error = error else {
                        self?.appItems.removeAll { $0 == item }
                        dispatchGroup.leave()
                        return
                    }
                    
                    dispatchGroup.leave()
                    self?.view.showInformalAlert(
                        title: Constant.errorAlertTitle,
                        message: error.localizedDescription,
                        buttonTitle: Constant.alertOkButtonTitle
                    )
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.view.update()
            }
        }
    }
}
