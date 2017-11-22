//
//  Post.swift
//  Social2
//
//  Created by Kasey Schlaudt on 9/7/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _username: String!
    private var _userImg: String!
    private var _postText: String!
    private var _postKey:  String!
    private var _postRef: DatabaseReference!
    
    var username: String {
        return _username
    }
    
    var userImg: String {
        return _userImg
    }
    
    var postText: String {
        return _postText
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(postText: String, username: String, userImg: String) {
        _postText = postText
        _username = username
        _userImg = userImg
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let username = postData["username"] as? String {
            _username = username
        }
        
        if let userImg = postData["userImg"] as? String {
            _userImg = userImg
        }
        
        if let postText = postData["postText"] as? String {
            _postText = postText
        }
        
        _postRef = Database.database().reference().child("posts").child(_postKey)
    }
}
