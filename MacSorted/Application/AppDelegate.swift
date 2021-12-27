import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        guard !flag else { return false }
        sender.windows.forEach { $0.makeKeyAndOrderFront(self) }
        return true
    }
}

