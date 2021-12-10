import Cocoa

final class MainVC: NSViewController {
    
    @IBOutlet private weak var uninstallerButton: SectionButtons!
    @IBOutlet private weak var fileDeleterButton: SectionButtons!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uninstallerButton.state = .on
        fileDeleterButton.state = .off
    }
    
    @IBAction private func uninstallerWastapped(_ sender: SectionButtons) {
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
