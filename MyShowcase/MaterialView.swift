import UIKit

class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor(red: 255.0 / 255.0, green: 108.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0).CGColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
