import Foundation
import Cocoa

struct CheckboxTableCellModel: Equatable {
    var isSelected: Bool
    let image: NSImage?
    let title: String
    let subtitle: String
}
