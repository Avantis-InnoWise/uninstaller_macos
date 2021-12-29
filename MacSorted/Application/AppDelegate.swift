import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    // MARK: Constants
    
    private enum Constant {
        static let menuIconImage = NSImage(named: "menu_icon")
    }
    
    // MARK: Properties
    
    private var statusBarMenu: NSMenu?
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let popover = NSPopover()
    
    // MARK: Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem.button?.imageScaling = .scaleProportionallyUpOrDown
        statusItem.button?.image = Constant.menuIconImage
        statusItem.button?.action = #selector(statusBarButtonWasClicked(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        popover.contentViewController = getMainVC()
        popover.animates = true
    }
    
    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        guard !flag else { return false }
        sender.windows.forEach { $0.makeKeyAndOrderFront(self) }
        return true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil
    }
}

// MARK: Private
private extension AppDelegate {
    func getMainVC() -> MainVC {
        let mainVC = NSStoryboard(
            name: NSStoryboard.Name("Main"),
            bundle: Bundle.main
        ).instantiateController(
            withIdentifier: String(describing: MainVC.self)
        ) as! MainVC
        
        return mainVC
    }
    
    func showPopover(sender: Any?) {
        guard let button = statusItem.button else { return }
        popover.show(
            relativeTo: button.bounds,
            of: button,
            preferredEdge: NSRectEdge.minY
        )
    }
    
    func closePopover(sender: Any?)  {
        popover.performClose(sender)
    }
    
    // MARK: Actions
    
    @objc func statusBarButtonWasClicked(_ sender: NSStatusItem) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .leftMouseUp {
            popover.isShown
            ? closePopover(sender: sender)
            : showPopover(sender: sender)
        } else {
            statusBarMenu = NSMenu()
            statusBarMenu?.delegate = self
            statusBarMenu?.addItem(
                withTitle: NSApp.isActive ? "Quit" : "Open",
                action: #selector(menuItemWasTapped),
                keyEquivalent: "")
            statusItem.menu = statusBarMenu
            statusItem.button?.performClick(nil)
        }
    }
    
    @objc func menuItemWasTapped() {
        NSApp.isActive
        ? NSApp.terminate(self)
        : showPopover(sender: statusItem.button)
    }
}
