import UIKit
import Firebase

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
        
        if let userName = username.text where userName.characters.count != 0, let image = profilePic.image {
            
            DataService.ds.REF_USERNAMES.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.hasChild(userName) {
                    self.showErrorAlert("INVALID USERNAME", message: "username already exists. Please select a different user name.")
                } else {
                    let trimmedUsername = userName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let userNameDictionary = ["username": trimmedUsername]
                    let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID)
                
                    DataService.ds.createUsername(trimmedUsername, uid: uid!)
                    DataService.ds.REF_USER_CURRENT.updateChildValues(userNameDictionary)
                    NSUserDefaults.standardUserDefaults().setValue(userName, forKey: KEY_USERNAME)
                    let imagePath = DataService.ds.saveImageAndCreatePath(image)
                    NSUserDefaults.standardUserDefaults().setValue(imagePath, forKey: KEY_PROFILE_PIC_PATH)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
            
        } else {
            self.showErrorAlert("INVALID USERNAME", message: "usename can not be empty!")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = image
    }
    
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default , handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
