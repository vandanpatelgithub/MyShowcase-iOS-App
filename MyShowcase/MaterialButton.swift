import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: 30.0 / 255.0, green: 136.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0).CGColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
