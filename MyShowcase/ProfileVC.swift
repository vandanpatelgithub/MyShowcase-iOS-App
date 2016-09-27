import UIKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: MaterialTextField!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 108.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.profilePic.clipsToBounds = true
        
    }
    
    @IBAction func profilePicPressed(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(sender: UIButton) {
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = image
    }
}
