import AppKit

extension NSViewController {
    func showInformalAlert(title: String, message: String, buttonTitle: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: buttonTitle)
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    func showDecisionAlert(
        title: String,
        message: String,
        okButtonTitle: String,
        cancelButtonTitle: String,
        decisionCompletion: () -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: okButtonTitle)
        alert.addButton(withTitle: cancelButtonTitle)
        alert.alertStyle = .warning
        if alert.runModal() == .alertFirstButtonReturn {
            decisionCompletion()
        }
    }
}
