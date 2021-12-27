import Foundation

struct File: Hashable {
    let name: String
    let path: String
    let isDirectory: Bool
    let dateModified: Date?
    let dateAccessed: Date?

    var description: String { path }

    init(
        path: String,
        isDirectory: Bool,
        dateModified: Date?,
        dateAccessed: Date?,
        name: String? = nil
    ) {
        self.path = path
        self.dateModified = dateModified
        self.dateAccessed = dateAccessed
        self.isDirectory = isDirectory
        
        guard let name = name else {
            self.name = NSURL(fileURLWithPath: path).lastPathComponent ?? "Unknown"
            return
        }
        self.name = name
    }
}
