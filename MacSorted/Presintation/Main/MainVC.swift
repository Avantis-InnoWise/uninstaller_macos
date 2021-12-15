import Cocoa

final class MainVC: NSViewController {
    // MARK: Outlets
    
    @IBOutlet private weak var uninstallerButton: SectionButton!
    @IBOutlet private weak var fileDeleterButton: SectionButton!
    @IBOutlet private weak var searchField: NSTextField!
    @IBOutlet private weak var selectAllButton: BorderedRoundedButton!
    @IBOutlet private weak var uninstallButton: NSButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uninstallerButton.state = .on
        fileDeleterButton.state = .off
        
        searchField.appearance = NSAppearance(named: .aqua)
    }
    
    // MARK: Actions
    
    @IBAction private func uninstallButtonWasTapped(_ sender: BorderedRoundedButton) {
    }
    
    @IBAction private func selectAllButtonWasTapped(_ sender: GradientButton) {
    }
    
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
    }
}
