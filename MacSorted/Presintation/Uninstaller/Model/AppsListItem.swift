import Foundation

struct AppsListItem {
    let app: App
    var isSelected: Bool = false
    
    mutating func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    mutating func toggleSelection() {
        isSelected.toggle()
    }
}
