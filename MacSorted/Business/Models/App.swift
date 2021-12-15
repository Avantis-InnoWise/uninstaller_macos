import Foundation

struct App: Hashable {
    var name: String
    var path: URL
    var iconPath: URL
    var dataLocations: [PathInfo]
    var uninstallerPath: String?
}
