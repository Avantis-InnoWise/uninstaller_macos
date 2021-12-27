import Foundation
import AppKit

final class UninstallerComposer {
    let viewController: UninstallerVC
    
    class func assemble(withInput input: UninstallerInput) -> UninstallerComposer {
        let presenter = UninstallerPresenter(with: input.appsManager)
        
        let viewController = NSStoryboard.main?.instantiateController(
            withIdentifier: String(describing: UninstallerVC.self)
        ) as! UninstallerVC
        
        viewController.output = presenter
        presenter.view = viewController
        
        return UninstallerComposer(viewController: viewController)
    }
    
    private init(viewController: UninstallerVC) {
      self.viewController = viewController
    }
}

struct UninstallerInput {
    let appsManager: AppsManager
}

protocol UninstallerViewOutput: AnyObject {
    var items: [CheckboxTableCellModel] { get }
    
    func viewDidLoad()
    func reloadModel()
    func update(with filter: String)
    func toggleSelection(at index: Int)
    func selectAllButtonWasTapped()
    func uninstallSelectedItemsWasTapped()
}

protocol UninstallerViewInput: AnyObject {
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
