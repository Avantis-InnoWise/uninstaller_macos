import Foundation
import AppKit

final class FileDeleterPresenter {
    // MARK: Constants
    
    private enum Constant {
        static let decisionAlertTitle = "Delete?"
        static let decisionAlertMessage = "Would you like to delete the chosen file/s?"
        static let noResultsAlertTitle = "No results"
        static let noResultsAlertMessage = "No results were found for current search request"
        static let errorAlertTitle = "Error"
        static let alertOkButtonTitle = "Ok"
        static let alertConfirmButtonTitle = "Confirm"
        static let alertCancelButtonTitle = "Cancel"
    }
    
    // MARK: Properties
    
    weak var view: FileDeleterViewInput!
    
    private let fileManager: FilesManager
    
    private var fileItems = [CheckboxTableCellModel]()
    private var filter = ""
    private var shouldFilter = true
    
    // MARK: Lifecycle
    
    init(with fileManaer: FilesManager) {
        self.fileManager = fileManaer
    }
}

// MARK: FileDeleterViewOutput
extension FileDeleterPresenter: FileDeleterViewOutput {
    var items: [CheckboxTableCellModel] {
        filter.isEmpty || !shouldFilter
        ? fileItems
        : fileItems.filter { $0.title.lowercased().contains(filter) }
    }
    
    func reloadModel() {
        shouldFilter = true
        findFiles(filteredBy: filter)
    }
    
    func findDuplicatedFilesWasTapped() {
        shouldFilter = false
        findDuplicatedFiles()
    }
    
    func findOldFilesWasTapped() {
        shouldFilter = false
        findOldFiles()
    }
    
    func update(with filter: String) {
        self.filter = filter
    }
    
    func toggleSelection(at index: Int) {
        let item = items[index]
        guard let unfilteredIndex = fileItems.firstIndex(where: { $0 == item }) else { return }
        fileItems[unfilteredIndex].isSelected.toggle()
    }
    
    func selectAllButtonWasTapped() {
        let isSelected = items.contains { !$0.isSelected }
        items.forEach { item in
            guard let unfilteredIndex = fileItems.firstIndex(where: { $0 == item })
            else { return }
            fileItems[unfilteredIndex].isSelected = isSelected
        }
        view.update()
    }
    
    func deleteSelectedItemsWasTapped() {
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
                self?.fileManager.deleteFile(item.subtitle) { [weak self] error in
                    guard let error = error else {
                        self?.fileItems.removeAll { $0 == item }
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

// MARK: Private
private extension FileDeleterPresenter {
    func findDuplicatedFiles() {
        fileManager.findDuplicatedFiles { [weak self] duplicatedFiles in
            self?.updateModel(with: duplicatedFiles)
        }
    }
    
    func findOldFiles() {
        fileManager.findOldFiles { [weak self] oldFiles in
            self?.updateModel(with: oldFiles)
        }
    }
    
    func findFiles(filteredBy filter: String = "") {
        guard !filter.isEmpty || !shouldFilter else { return }
        fileManager.getAllFiles(with: filter) { [weak self] files in
            self?.updateModel(with: files)
        }
    }
    
    func updateModel(with files: [File]) {
        guard !files.isEmpty else {
            view.showInformalAlert(
                title: Constant.noResultsAlertTitle,
                message: Constant.noResultsAlertMessage,
                buttonTitle: Constant.alertOkButtonTitle
            )
            return
        }
        
        fileItems = files.compactMap {
            CheckboxTableCellModel(
                isSelected: false,
                image: $0.isDirectory
                ? NSImage(named: "folder")
                : NSImage(named: "files"),
                title: $0.name,
                subtitle: $0.path
            )
        }
        
        view.update()
    }
}
