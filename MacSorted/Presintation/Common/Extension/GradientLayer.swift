import Cocoa

extension CAGradientLayer {

    func backgroundGradientColor() -> CAGradientLayer {
        let topColor = NSColor(red: (0/255.0), green: (153/255.0), blue:(51/255.0), alpha: 1)
        let bottomColor = NSColor(red: (0/255.0), green: (153/255.0), blue:(255/255.0), alpha: 1)

        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        return gradientLayer

    }
}
