import UIKit
import Firebase
import Alamofire
import FirebaseStorage
import EZLoadingActivity

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    var imageSelected = false
    static var imageCache = NSCache()
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 350
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageURL {
                image = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, image: image)
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageURL == nil {
            return 160
        }
        else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func postButtonPressed(sender: MaterialButton) {
        
        if let txt = postField.text where txt != "" {
            if let image = imageSelectorImage.image where imageSelected == true {
                EZLoadingActivity.show("Uploading...", disableUI: false)
                let imageRef = STORAGE_URL.child("\(NSDate.timeIntervalSinceReferenceDate()).png")
                let imageData: NSData = UIImagePNGRepresentation(image)!
                
                let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
                    if error == nil {
                        let downloadURL = metadata!.downloadURL()
                        print("URL : \(downloadURL)")
                        self.postToFirebase(downloadURL?.absoluteString)
                    }
                }
                
                uploadTask.observeStatus(.Progress, handler: { (snapshot) in
                    if let progress = snapshot.progress {
                        let percentComplete = 100 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                        print(percentComplete)
                        
                    }
                })
                
                uploadTask.observeStatus(.Success, handler: { (snapshot) in
                    EZLoadingActivity.hide(success: true, animated: true)
                    print("Image Uploaded Successfully")
                })
                
                uploadTask.observeStatus(.Failure, handler: { (snapshot) in
                    EZLoadingActivity.hide(success: false, animated: true)
                })
                
                
            }
            else {
                self.postToFirebase(nil)
            }
        }
    }
    
    func postToFirebase(imageURL: String?) {
        var post: Dictionary<String, AnyObject> = [
            "description": postField.text!,
            "likes": 0,
            ]
        
        if imageURL != nil {
            post["imageUrl"] = imageURL!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
}
