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
        
//        let currentUserReference = DataService.ds.REF_USER_CURRENT
        
        if let userName = username.text where userName.characters.count != 0 {
            
//            let userNameDictionary = ["username": userName]
//            currentUserReference.updateChildValues(userNameDictionary)
            NSUserDefaults.standardUserDefaults().setValue(userName, forKey: KEY_USERNAME)
        }
        
        if let image = profilePic.image {
            let imagePath = DataService.ds.saveImageAndCreatePath(image)
            NSUserDefaults.standardUserDefaults().setValue(imagePath, forKey: KEY_PROFILE_PIC_PATH)
        
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = image
    }
    
    
}
