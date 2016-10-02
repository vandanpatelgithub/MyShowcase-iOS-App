import Foundation

class Post {
    private var _postDescription: String!
    private var _imageURL: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageURL: String? {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageURL: String?, username: String) {
        self._postDescription = description
        self._imageURL = imageURL
        self._username = username
    }
        
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageURL = dictionary["imageUrl"] as? String {
            self._imageURL = imageURL
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
    }
}
