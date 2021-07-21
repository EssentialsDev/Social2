//
//  PostVC.swift
//  Social2
//
//  Created by Cory Lowry on 7/20/21.
//  Copyright © 2021 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase

class PostVC: UIViewController {
    
    @IBOutlet weak var postText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func post(_ sender: AnyObject) {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImg = data["userImg"]
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "userImg": userImg as AnyObject,
                "postText": self.postText.text as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("textPosts").childByAutoId()
            firebasePost.setValue(post)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
