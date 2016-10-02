import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var post: Post!
    var request: Request?
    
    let userName = NSUserDefaults.standardUserDefaults().valueForKey(KEY_USERNAME) as! String
    let imagePath = NSUserDefaults.standardUserDefaults().valueForKey(KEY_PROFILE_PIC_PATH) as! String

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        
        showcaseImage.clipsToBounds = true
    }

    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        self.descriptionText.text = post.postDescription
        self.likesLabel.text = "\(post.likes)"
        self.username.text = userName
        self.profilePic.image = DataService.ds.imageForPath(imagePath)
        
        if post.imageURL != nil { 
            
            if image != nil {
                self.showcaseImage.image = image
            } else {
                request = Alamofire.request(.GET, post.imageURL!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    
                    if error == nil {
                        let image  = UIImage(data: data!)
                        self.showcaseImage.image = image
                        FeedVC.imageCache.setObject(image!, forKey: post.imageURL!)
                    }
                })
            }
            
        } else {
            self.showcaseImage.hidden = true
        }
    }
}
