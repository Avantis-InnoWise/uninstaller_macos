import Foundation
import AppKit

final class FileDeleterComposer {
    let viewController: FileDeleterVC
    
    class func assemble(withInput input: FileDeleterInput) -> FileDeleterComposer {
        let presenter = FileDeleterPresenter(with: input.fileManager)
        
        let viewController = NSStoryboard(
            name: "Main",
            bundle: Bundle.main
        ).instantiateController(
            withIdentifier: String(describing: FileDeleterVC.self)
        ) as! FileDeleterVC
        
        viewController.output = presenter
        presenter.view = viewController
        
        return FileDeleterComposer(viewController: viewController)
    }
    
    private init(viewController: FileDeleterVC) {
      self.viewController = viewController
    }
}

struct FileDeleterInput {
    let fileManager: FilesManager
}

protocol FileDeleterViewOutput: AnyObject {
    var items: [CheckboxTableCellModel] { get }
    
    func reloadModel()
    func findDuplicatedFilesWasTapped()
    func findOldFilesWasTapped()
    func update(with filter: String)
    func toggleSelection(at index: Int)
    func selectAllButtonWasTapped()
    func deleteSelectedItemsWasTapped()
}

protocol FileDeleterViewInput: AnyObject {
    func update()
    func showInformalAlert(title: String, message: String, buttonTitle: String)
    func showDecisionAlert(
        title: String,
        message: String,
        okButtonTitle: String,
        cancelButtonTitle: String,
        decisionCompletion: () -> Void
    )
}
