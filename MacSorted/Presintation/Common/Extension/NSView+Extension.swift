import Cocoa

extension NSView {
    func pinEdgesToSuperviewEdges(offset: CGFloat = 0, excluding: [NSObject] = []) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if !excluding.contains(topAnchor) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
        }
        
        if !excluding.contains(leadingAnchor) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset).isActive = true
        }
        
        if !excluding.contains(trailingAnchor) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset).isActive = true
        }
        
        if !excluding.contains(bottomAnchor) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset).isActive = true
        }
    }
}
