import Cocoa

final class MainVC: NSViewController {
    // MARK: Outlets
    
    @IBOutlet private weak var uninstallerButton: SectionButton!
    @IBOutlet private weak var fileDeleterButton: SectionButton!
    @IBOutlet private weak var containerView: NSView!
    
    private var uninstallerVC: UninstallerVC?
    private var fileDeleterVC: FileDeleterVC?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uninstallerButton.state = .on
        fileDeleterButton.state = .off
        
        uninstallerVC = storyboard?.instantiateController(withIdentifier: String(describing: UninstallerVC.self)) as? UninstallerVC
        if let uninstallerVC = uninstallerVC {
            addChild(uninstallerVC)
            containerView.addSubview(uninstallerVC.view)
            uninstallerVC.view.pinEdgesToSuperviewEdges()
        }
        fileDeleterVC = getFileDeleterVC()
        if let fileDeleterVC = fileDeleterVC {
            addChild(fileDeleterVC)
        }
    }
    
    // MARK: Actions
    
    @IBAction private func sectionButtonWasTapped(_ sender: SectionButton) {
        guard sender.state == NSControl.StateValue.on else {
            sender.state = NSControl.StateValue.on
            return
        }
        
        uninstallerButton.state = sender == uninstallerButton && uninstallerButton.state == NSControl.StateValue.on
        ? NSControl.StateValue.on
        : NSControl.StateValue.off
        fileDeleterButton.state =  sender == fileDeleterButton && fileDeleterButton.state == NSControl.StateValue.on
        ? NSControl.StateValue.on
        : NSControl.StateValue.off
        
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        
        if sender == uninstallerButton, let uninstallerVC = uninstallerVC {
            containerView.addSubview(uninstallerVC.view)
            uninstallerVC.view.pinEdgesToSuperviewEdges()
        } else if sender == fileDeleterButton, let fileDeleterVC = fileDeleterVC {
            containerView.addSubview(fileDeleterVC.view)
            fileDeleterVC.view.pinEdgesToSuperviewEdges()
        }
    }
}

// MARK: Private
private extension MainVC {
    func getFileDeleterVC() -> FileDeleterVC {
        let input = FileDeleterInput(fileManager: FilesManager())
        let composer = FileDeleterComposer.assemble(withInput: input)
        return composer.viewController
    }
}
