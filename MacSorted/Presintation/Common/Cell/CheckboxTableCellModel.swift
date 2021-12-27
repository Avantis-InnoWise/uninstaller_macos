import Foundation
import Cocoa

struct CheckboxTableCellModel: Equatable {
    var isSelected: Bool
    
    let title: String
    let subtitle: String
    let image: NSImage?
    let sourceLocations: [URL]
    
    init(
        isSelected: Bool,
        title: String,
        subtitle: String,
        image: NSImage?,
        sourceLocations: [URL]
    ) {
        self.isSelected = isSelected
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.sourceLocations = sourceLocations
    }
}
