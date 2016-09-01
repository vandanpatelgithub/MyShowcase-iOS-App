import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: 255.0 / 255.0, green: 108.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.5).CGColor
        layer.borderWidth = 1.0
    }
    
    //For Placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 0)
    }
    
    //For editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 0)
    }
}
