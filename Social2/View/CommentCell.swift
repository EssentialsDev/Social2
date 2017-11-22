//
//  CommentCell.swift
//  Social2
//
//  Created by Kasey Schlaudt on 9/13/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        postText.text = ""
    }
    
    var post: Post!
    
    func configCell(post: Post) {
        self.post = post
        self.username.text = post.username
        self.postText.text = post.postText
        
        let ref = Storage.storage().reference(forURL: post.userImg)
        ref.getData(maxSize: 100000000, completion: { (data, error) in
            if error != nil {
                print("couldnt load img")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData){
                        self.userImg.image = img
                    }
                }
            }
        })
    }
}
